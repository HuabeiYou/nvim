-- Best-effort 1:1 Lua port of opencode's
--   https://github.com/anomalyco/opencode/blob/dev/packages/ui/src/theme/resolve.ts
--
-- Given a theme JSON (compact palette + overrides in our case), produces
-- the resolved token table (≈248 entries per variant) that the web UI
-- ships. We preserve the original token names so highlight groups can map
-- directly to them.
--
-- Implementation notes:
--   * TS arrays are zero-indexed; Lua is one-indexed. Every `scale[N]`
--     reference in the TS source becomes `scale[N + 1]` here. The comment
--     at each site notes the TS index.
--   * `withAlpha` in TS produces a CSS `rgba(...)` string; consumers treat
--     these as overlay values that mix with the resolved background at
--     paint time. We mirror that behaviour literally and let the caller
--     decide whether to flatten via `flatten_token()` below.
--   * "overlay" mode (i.e. when `background-base` is an override that
--     isn't a hex) is inactive for oc-2 — it defines a normal hex palette
--     without overriding background-base — but we still implement it so
--     future themes parse.

local color = require("oc-2.color")

local M = {}

-- ---------------------------------------------------------------------------
-- utility helpers

local function clamp(v, min, max)
  if v < min then return min end
  if v > max then return max end
  return v
end

-- Starts-with that ignores the `var(...)` branch. In TS: `!value?.startsWith("#")`.
local function getHex(value)
  if type(value) ~= "string" then return nil end
  if value:sub(1, 1) ~= "#" then return nil end
  return value
end

-- WCAG-style relative luminance. Matches `lum()` in resolve.ts.
local function lum(hex)
  local r, g, b = color.hexToRgb(hex)
  local function lift(v)
    if v <= 0.04045 then return v / 12.92 end
    return ((v + 0.055) / 1.055) ^ 2.4
  end
  return 0.2126 * lift(r) + 0.7152 * lift(g) + 0.0722 * lift(b)
end

local function contrast_ratio(a, b)
  local x, y = lum(a), lum(b)
  local light = math.max(x, y)
  local dark  = math.min(x, y)
  return (light + 0.05) / (dark + 0.05)
end

-- Pick black or white based on contrast against a fill.
local function on_color(fill)
  local light = "#ffffff"
  local dark  = "#000000"
  if contrast_ratio(light, fill) > contrast_ratio(dark, fill) then
    return light
  end
  return dark
end

-- ---------------------------------------------------------------------------
-- resolve.ts::getColors — flatten variant into the shape resolve.ts uses.

---@param variant table  the oc-2-style `.dark` / `.light` block
---@return table ThemeColors
local function getColors(variant)
  if variant.palette and variant.seeds then
    error("Theme variant cannot define both `palette` and `seeds`")
  end

  if variant.palette then
    local p = variant.palette
    return {
      compact     = true,
      neutral     = p.neutral,
      ink         = p.ink,
      primary     = p.primary,
      accent      = p.accent or p.info,
      success     = p.success,
      warning     = p.warning,
      error       = p.error,
      info        = p.info,
      interactive = p.interactive or p.primary,
      diffAdd     = p.diffAdd,
      diffDelete  = p.diffDelete,
    }
  end

  if variant.seeds then
    local s = variant.seeds
    return {
      compact     = false,
      neutral     = s.neutral,
      ink         = nil,
      primary     = s.primary,
      accent      = s.info,
      success     = s.success,
      warning     = s.warning,
      error       = s.error,
      info        = s.info,
      interactive = s.interactive,
      diffAdd     = s.diffAdd,
      diffDelete  = s.diffDelete,
    }
  end

  error("Theme variant requires `palette` or `seeds`")
end

-- ---------------------------------------------------------------------------
-- Neutral alpha scale — NOT the same as generateAlphaScale, despite the
-- name similarity. It blends between scale[11] (the most saturated end)
-- and scale[0] (the background end) with variant-dependent alpha steps.

local function generateNeutralAlphaScale(neutralScale, isDark)
  local alphas
  if isDark then
    alphas = { 0.038, 0.066, 0.1, 0.142, 0.19, 0.252, 0.334, 0.446, 0.58, 0.718, 0.854, 0.985 }
  else
    alphas = { 0.03, 0.06, 0.1, 0.145, 0.2, 0.265, 0.35, 0.47, 0.61, 0.74, 0.86, 0.97 }
  end

  local out = {}
  -- TS: blend(neutralScale[11], neutralScale[0], alpha) — foreground is
  -- the strongest tone, background is the lightest.
  for i, alpha in ipairs(alphas) do
    out[i] = color.blend(neutralScale[12], neutralScale[1], alpha)
  end
  return out
end

-- ---------------------------------------------------------------------------
-- resolveThemeVariant — the bulk of the port.

---@param variant table
---@param isDark boolean
---@return table<string, string> tokens
function M.resolveThemeVariant(variant, isDark)
  local colors    = getColors(variant)
  local overrides = variant.overrides or {}

  local neutral     = color.generateNeutralScale(colors.neutral, isDark, colors.ink)
  local primary     = color.generateScale(colors.primary, isDark)
  local accent      = color.generateScale(colors.accent, isDark)
  local success     = color.generateScale(colors.success, isDark)
  local warning     = color.generateScale(colors.warning, isDark)
  local error_scale = color.generateScale(colors.error, isDark)
  local info        = color.generateScale(colors.info, isDark)
  local interactive = color.generateScale(colors.interactive, isDark)

  -- amber = scale of `shift(warning, ...)` with different direction per mode
  local amber_seed
  if isDark then
    amber_seed = color.shift(colors.warning, { h = -16, l = -0.058, c = 1.14 })
  else
    amber_seed = color.shift(colors.warning, { h = -22, l = -0.082, c = 0.94 })
  end
  local amber = color.generateScale(amber_seed, isDark)

  -- blue = scale of `shift(interactive, { h: -12, l: 0.128, c: 1.12 })`
  local blue = color.generateScale(color.shift(colors.interactive, { h = -12, l = 0.128, c = 1.12 }), isDark)

  -- diff scales: either the override seed or a shifted accent color.
  local diffAdd_seed = colors.diffAdd
  if not diffAdd_seed then
    diffAdd_seed = color.shift(colors.success, {
      c = isDark and 0.7 or 0.55,
      l = isDark and -0.18 or 0.14,
    })
  end
  local diffAdd = color.generateScale(diffAdd_seed, isDark)

  local diffDelete_seed = colors.diffDelete
  if not diffDelete_seed then
    diffDelete_seed = color.shift(colors.error, {
      c = isDark and 0.82 or 0.7,
      l = isDark and -0.08 or 0.08,
    })
  end
  local diffDelete = color.generateScale(diffDelete_seed, isDark)

  -- tint / body — only used when compact=true (our case)
  local ink = colors.ink or colors.neutral
  local tint = colors.compact and color.hexToOklch(ink) or nil
  local body = nil
  if tint then
    body = color.shift(ink, {
      l = isDark and math.max(0, 0.88 - tint.l) * 0.4 or -math.max(0, tint.l - 0.18) * 0.24,
      c = isDark and 1.04 or 1.02,
    })
  end

  -- overlay mode (background-base overridden with a non-hex value)
  local backgroundOverride = overrides["background-base"]
  local backgroundHex      = getHex(backgroundOverride)
  local overlay            = backgroundOverride ~= nil and backgroundHex == nil
  local background         = backgroundHex or neutral[1] -- TS: neutral[0]

  -- alphaTone: either wrap as rgba(...) overlay string, or blend against bg
  local function alphaTone(col, alpha)
    if overlay then
      return color.withAlpha(col, alpha)
    end
    return color.blend(col, background, alpha)
  end

  -- borderTone used when colors.compact is true
  local function borderTone(light_alpha, dark_alpha)
    local a
    if isDark then
      a = math.min(1, dark_alpha + 0.024 + (colors.compact and 0.08 or 0))
    else
      a = math.min(1, light_alpha + 0.024)
    end
    return alphaTone(ink, a)
  end

  -- content(): computes syntax token colour in compact mode.
  local function content(seed, scale)
    local base = color.hexToOklch(seed)
    local value
    if isDark then
      if base.l > 0.84 then
        value = color.shift(seed, { c = 1.18 })
      else
        value = scale[11] -- TS: scale[10]
      end
    else
      value = scale[11]   -- TS: scale[10]
    end
    return color.shift(value, {
      l = isDark and 0.034 or -0.024,
      c = isDark and 1.3 or 1.18,
    })
  end

  -- modified(): diff-modified icon colour
  local function modified()
    if not colors.compact then
      return isDark and "#ffba92" or "#FF8C00"
    end
    local warningHue = color.hexToOklch(colors.warning).h
    local deleteHue  = color.hexToOklch(colors.diffDelete or colors.error).h
    local delta      = math.abs(((((deleteHue - warningHue) % 360) + 540) % 360) - 180)
    if delta < 48 then
      return isDark and "#ffba92" or "#FF8C00"
    end
    return content(colors.warning, warning)
  end

  -- diff "hidden" surface, computed via the `surface()` helper
  local function surface(seed, alpha)
    return {
      base    = alphaTone(seed, alpha.base),
      weak    = alphaTone(seed, alpha.weak),
      weaker  = alphaTone(seed, alpha.weaker),
      strong  = alphaTone(seed, alpha.strong),
      stronger = alphaTone(seed, alpha.stronger),
    }
  end

  local diffHiddenSurface = surface(
    isDark
      and color.shift(colors.interactive, { c = 0.55, l = 0 })
      or  color.shift(colors.interactive, { c = 0.45, l = 0.08 }),
    isDark
      and { base = 0.14, weak = 0.08, weaker = 0.18, strong = 0.26, stronger = 0.42 }
      or  { base = 0.12, weak = 0.08, weaker = 0.16, strong = 0.24, stronger = 0.36 }
  )

  local neutralAlpha = generateNeutralAlphaScale(neutral, isDark)

  -- --- commonly-referenced scale picks (match TS variable names) ----------
  local brandb = primary[9]              -- TS: primary[8]
  local brandh = primary[10]             -- TS: primary[9]
  local interb = interactive[isDark and 7 or 5] -- [6] / [4]
  local interh = interactive[isDark and 8 or 6] -- [7] / [5]
  local interw = interactive[isDark and 6 or 4] -- [5] / [3]
  local succb  = success[isDark and 7 or 5]
  local succw  = success[isDark and 6 or 4]
  local succs  = success[11]             -- TS: [10]
  local warnb  = warning[isDark and 7 or 5]
  local warnw  = warning[isDark and 6 or 4]
  local warns  = warning[11]
  local critb  = error_scale[isDark and 7 or 5]
  local critw  = error_scale[isDark and 6 or 4]
  local crits  = error_scale[11]
  local infob  = info[isDark and 7 or 5]
  local infow  = info[isDark and 6 or 4]
  local infos  = info[11]

  local tokens = {}

  -- Backgrounds ------------------------------------------------------------
  tokens["background-base"]     = neutral[1]  -- [0]
  tokens["background-weak"]     = neutral[3]  -- [2]
  tokens["background-strong"]   = neutral[1]  -- [0]
  tokens["background-stronger"] = isDark and neutral[2] or "#fcfcfc" -- [1]

  -- Surfaces ---------------------------------------------------------------
  tokens["surface-base"]                    = neutralAlpha[2] -- [1]
  tokens["base"]                            = neutralAlpha[2]
  tokens["surface-base-hover"]              = neutralAlpha[3] -- [2]
  tokens["surface-base-active"]             = neutralAlpha[3]
  tokens["surface-base-interactive-active"] = color.withAlpha(interactive[3], 0.3) -- [2]
  tokens["base2"]                           = neutralAlpha[2]
  tokens["base3"]                           = neutralAlpha[2]
  tokens["surface-inset-base"]              = neutralAlpha[2]
  tokens["surface-inset-base-hover"]        = neutralAlpha[3]
  tokens["surface-inset-strong"]            = isDark
    and color.withAlpha(neutral[1], 0.5)
    or  color.withAlpha(neutral[4], 0.09) -- [3]
  tokens["surface-inset-strong-hover"]      = tokens["surface-inset-strong"]

  tokens["surface-raised-base"]           = neutralAlpha[1]
  tokens["surface-float-base"]            = isDark and neutral[2] or neutral[12] -- [1] / [11]
  tokens["surface-float-base-hover"]      = isDark and neutral[3] or neutral[11] -- [2] / [10]
  tokens["surface-raised-base-hover"]     = neutralAlpha[2]
  tokens["surface-raised-base-active"]    = neutralAlpha[3]
  tokens["surface-raised-strong"]         = isDark and neutralAlpha[4] or neutral[1] -- [3] / [0]
  tokens["surface-raised-strong-hover"]   = isDark and neutralAlpha[6] or "#ffffff"  -- [5]
  tokens["surface-raised-stronger"]       = isDark and neutralAlpha[6] or "#ffffff"
  tokens["surface-raised-stronger-hover"] = isDark and neutralAlpha[7] or "#ffffff"  -- [6]
  tokens["surface-weak"]                  = neutralAlpha[3] -- [2]
  tokens["surface-weaker"]                = neutralAlpha[4] -- [3]
  tokens["surface-strong"]                = isDark and neutralAlpha[7] or "#ffffff" -- [6]
  tokens["surface-raised-stronger-non-alpha"] = isDark and neutral[3] or "#ffffff"  -- [2]

  tokens["surface-brand-base"]  = brandb
  tokens["surface-brand-hover"] = brandh

  tokens["surface-interactive-base"]        = interb
  tokens["surface-interactive-hover"]       = interh
  tokens["surface-interactive-weak"]        = interw
  tokens["surface-interactive-weak-hover"]  = interb

  tokens["surface-success-base"]   = succb
  tokens["surface-success-weak"]   = succw
  tokens["surface-success-strong"] = succs
  tokens["surface-warning-base"]   = warnb
  tokens["surface-warning-weak"]   = warnw
  tokens["surface-warning-strong"] = warns
  tokens["surface-critical-base"]  = critb
  tokens["surface-critical-weak"]  = critw
  tokens["surface-critical-strong"] = crits
  tokens["surface-info-base"]      = infob
  tokens["surface-info-weak"]      = infow
  tokens["surface-info-strong"]    = infos

  -- Diff surfaces ----------------------------------------------------------
  tokens["surface-diff-unchanged-base"] = isDark and neutral[1] or "#ffffff00"
  tokens["surface-diff-skip-base"]      = isDark and neutralAlpha[1] or neutral[2]
  tokens["surface-diff-hidden-base"]     = diffHiddenSurface.base
  tokens["surface-diff-hidden-weak"]     = diffHiddenSurface.weak
  tokens["surface-diff-hidden-weaker"]   = diffHiddenSurface.weaker
  tokens["surface-diff-hidden-strong"]   = diffHiddenSurface.strong
  tokens["surface-diff-hidden-stronger"] = diffHiddenSurface.stronger
  tokens["surface-diff-add-base"]     = diffAdd[3]                       -- [2]
  tokens["surface-diff-add-weak"]     = diffAdd[isDark and 4 or 2]       -- [3] / [1]
  tokens["surface-diff-add-weaker"]   = diffAdd[isDark and 3 or 1]       -- [2] / [0]
  tokens["surface-diff-add-strong"]   = diffAdd[5]                       -- [4]
  tokens["surface-diff-add-stronger"] = diffAdd[isDark and 11 or 9]      -- [10] / [8]
  tokens["surface-diff-delete-base"]     = diffDelete[3]
  tokens["surface-diff-delete-weak"]     = diffDelete[isDark and 4 or 2]
  tokens["surface-diff-delete-weaker"]   = diffDelete[isDark and 3 or 1]
  tokens["surface-diff-delete-strong"]   = diffDelete[isDark and 5 or 6] -- [4] / [5]
  tokens["surface-diff-delete-stronger"] = diffDelete[isDark and 11 or 9]

  -- Inputs -----------------------------------------------------------------
  tokens["input-base"]     = isDark and neutral[2] or neutral[1]
  tokens["input-hover"]    = isDark and neutral[3] or neutral[2]
  tokens["input-active"]   = isDark and interactive[7] or interactive[1]
  tokens["input-selected"] = isDark and interactive[8] or interactive[4]
  tokens["input-focus"]    = isDark and interactive[7] or interactive[1]
  tokens["input-disabled"] = neutral[4]

  -- Text -------------------------------------------------------------------
  if colors.compact then
    tokens["text-base"]   = body
    tokens["text-weak"]   = color.shift(body, { l = isDark and -0.11 or 0.11, c = 0.9 })
    tokens["text-weaker"] = color.shift(body, {
      l = isDark and -0.2 or 0.21,
      c = isDark and 0.78 or 0.72,
    })
    if isDark then
      tokens["text-strong"] = color.blend("#ffffff", body, 0.9)
    else
      tokens["text-strong"] = color.shift(body, { l = -0.07, c = 1.04 })
    end
  else
    tokens["text-base"]   = neutral[11]
    tokens["text-weak"]   = neutral[9]
    tokens["text-weaker"] = neutral[8]
    tokens["text-strong"] = neutral[12]
  end
  tokens["text-invert-base"]   = isDark and neutral[11] or neutral[2]
  tokens["text-invert-weak"]   = isDark and neutral[9] or neutral[3]
  tokens["text-invert-weaker"] = isDark and neutral[8] or neutral[4]
  tokens["text-invert-strong"] = isDark and neutral[12] or neutral[1]
  tokens["text-interactive-base"] = interactive[isDark and 11 or 10]
  tokens["text-on-brand-base"]       = on_color(brandb)
  tokens["text-on-interactive-base"] = on_color(interb)
  tokens["text-on-interactive-weak"] = on_color(interb)
  tokens["text-on-success-base"]     = on_color(succb)
  tokens["text-on-critical-base"]    = on_color(critb)
  tokens["text-on-critical-weak"]    = on_color(critb)
  tokens["text-on-critical-strong"]  = on_color(crits)
  tokens["text-on-warning-base"]     = on_color(warnb)
  tokens["text-on-info-base"]        = on_color(infob)
  tokens["text-diff-add-base"]       = diffAdd[11]    -- [10]
  tokens["text-diff-delete-base"]    = diffDelete[10] -- [9]
  tokens["text-diff-delete-strong"]  = diffDelete[12] -- [11]
  tokens["text-diff-add-strong"]     = diffAdd[isDark and 8 or 12] -- [7] / [11]
  tokens["text-on-info-weak"]        = on_color(infob)
  tokens["text-on-info-strong"]      = on_color(infos)
  tokens["text-on-warning-weak"]     = on_color(warnb)
  tokens["text-on-warning-strong"]   = on_color(warns)
  tokens["text-on-success-weak"]     = on_color(succb)
  tokens["text-on-success-strong"]   = on_color(succs)
  tokens["text-on-brand-weak"]       = on_color(brandb)
  tokens["text-on-brand-weaker"]     = on_color(brandb)
  tokens["text-on-brand-strong"]     = on_color(brandh)

  -- Buttons ----------------------------------------------------------------
  tokens["button-primary-base"]    = neutral[12]
  tokens["button-secondary-base"]  = isDark and neutral[3] or neutral[1]
  tokens["button-secondary-hover"] = isDark and neutral[4] or neutral[2]
  tokens["button-ghost-hover"]     = neutralAlpha[2]
  tokens["button-ghost-hover2"]    = neutralAlpha[3]

  -- Borders ----------------------------------------------------------------
  tokens["border-base"]      = colors.compact and borderTone(0.22, 0.16) or neutralAlpha[7]
  tokens["border-hover"]     = colors.compact and borderTone(0.28, 0.2) or neutralAlpha[8]
  tokens["border-active"]    = colors.compact and borderTone(0.34, 0.24) or neutralAlpha[9]
  tokens["border-selected"]  = color.withAlpha(interactive[9], isDark and 0.9 or 0.99) -- [8]
  tokens["border-disabled"]  = colors.compact and borderTone(0.18, 0.12) or neutralAlpha[8]
  tokens["border-focus"]     = colors.compact and borderTone(0.34, 0.24) or neutralAlpha[9]

  tokens["border-weak-base"]    = colors.compact and borderTone(0.1, 0.08) or neutralAlpha[isDark and 6 or 5]
  tokens["border-strong-base"]  = colors.compact and borderTone(0.34, 0.24) or neutralAlpha[isDark and 8 or 7]
  tokens["border-strong-hover"] = colors.compact and borderTone(0.4, 0.28) or neutralAlpha[8]
  tokens["border-strong-active"] = colors.compact and borderTone(0.46, 0.32) or neutralAlpha[isDark and 8 or 7]
  tokens["border-strong-selected"] = color.withAlpha(interactive[6], 0.6)
  tokens["border-strong-disabled"] = colors.compact and borderTone(0.14, 0.1) or neutralAlpha[6]
  tokens["border-strong-focus"]    = colors.compact and borderTone(0.46, 0.32) or neutralAlpha[isDark and 8 or 7]

  tokens["border-weak-hover"]    = colors.compact and borderTone(0.16, 0.12) or neutralAlpha[isDark and 7 or 6]
  tokens["border-weak-active"]   = colors.compact and borderTone(0.22, 0.16) or neutralAlpha[isDark and 8 or 7]
  tokens["border-weak-selected"] = color.withAlpha(interactive[5], isDark and 0.6 or 0.5)
  tokens["border-weak-disabled"] = colors.compact and borderTone(0.08, 0.06) or neutralAlpha[6]
  tokens["border-weak-focus"]    = colors.compact and borderTone(0.22, 0.16) or neutralAlpha[isDark and 8 or 7]
  tokens["border-weaker-base"]   = colors.compact and borderTone(0.06, 0.04) or neutralAlpha[3]

  tokens["border-interactive-base"]     = interactive[7]
  tokens["border-interactive-hover"]    = interactive[8]
  tokens["border-interactive-active"]   = interactive[9]
  tokens["border-interactive-selected"] = interactive[9]
  tokens["border-interactive-disabled"] = neutral[8]
  tokens["border-interactive-focus"]    = interactive[9]

  tokens["border-success-base"]     = success[7]
  tokens["border-success-hover"]    = success[8]
  tokens["border-success-selected"] = success[9]
  tokens["border-warning-base"]     = warning[7]
  tokens["border-warning-hover"]    = warning[8]
  tokens["border-warning-selected"] = warning[9]
  tokens["border-critical-base"]    = error_scale[7]
  tokens["border-critical-hover"]   = error_scale[8]
  tokens["border-critical-selected"] = error_scale[9]
  tokens["border-info-base"]        = info[7]
  tokens["border-info-hover"]       = info[8]
  tokens["border-info-selected"]    = info[9]
  tokens["border-color"]            = "#ffffff"

  -- Icons ------------------------------------------------------------------
  local compact_light = colors.compact and not isDark
  tokens["icon-base"]     = compact_light and tokens["text-weak"] or neutral[isDark and 10 or 9]
  tokens["icon-hover"]    = compact_light and tokens["text-base"] or neutral[11]
  tokens["icon-active"]   = compact_light and tokens["text-strong"] or neutral[12]
  tokens["icon-selected"] = compact_light and tokens["text-strong"] or neutral[12]
  tokens["icon-disabled"] = neutral[isDark and 7 or 8]
  tokens["icon-focus"]    = compact_light and tokens["text-strong"] or neutral[12]
  tokens["icon-invert-base"] = isDark and neutral[1] or "#ffffff"
  tokens["icon-weak-base"]    = neutral[isDark and 6 or 7]
  tokens["icon-weak-hover"]   = neutral[isDark and 12 or 8]
  tokens["icon-weak-active"]  = neutral[9]
  tokens["icon-weak-selected"] = neutral[isDark and 9 or 10]
  tokens["icon-weak-disabled"] = neutral[isDark and 4 or 6]
  tokens["icon-weak-focus"]    = neutral[9]
  tokens["icon-strong-base"]     = neutral[12]
  tokens["icon-strong-hover"]    = isDark and "#f6f3f3" or "#151313"
  tokens["icon-strong-active"]   = isDark and "#fcfcfc" or "#020202"
  tokens["icon-strong-selected"] = isDark and "#fdfcfc" or "#020202"
  tokens["icon-strong-disabled"] = neutral[8]
  tokens["icon-strong-focus"]    = isDark and "#fdfcfc" or "#020202"
  tokens["icon-brand-base"]       = isDark and "#ffffff" or neutral[12]
  tokens["icon-interactive-base"] = interactive[9]
  tokens["icon-success-base"]    = success[isDark and 9 or 7]
  tokens["icon-success-hover"]   = success[10]
  tokens["icon-success-active"]  = success[11]
  tokens["icon-warning-base"]    = amber[isDark and 9 or 7]
  tokens["icon-warning-hover"]   = amber[10]
  tokens["icon-warning-active"]  = amber[11]
  tokens["icon-critical-base"]   = error_scale[isDark and 9 or 10]
  tokens["icon-critical-hover"]  = error_scale[10]
  tokens["icon-critical-active"] = error_scale[11]
  tokens["icon-info-base"]       = info[isDark and 9 or 7]
  tokens["icon-info-hover"]      = info[isDark and 10 or 8]
  tokens["icon-info-active"]     = info[11]
  tokens["icon-on-brand-base"]       = on_color(brandb)
  tokens["icon-on-brand-hover"]      = on_color(brandh)
  tokens["icon-on-brand-selected"]   = on_color(brandh)
  tokens["icon-on-interactive-base"] = on_color(interb)

  tokens["icon-agent-plan-base"]  = info[9]
  tokens["icon-agent-docs-base"]  = amber[9]
  tokens["icon-agent-ask-base"]   = blue[9]
  tokens["icon-agent-build-base"] = interactive[isDark and 11 or 9]

  tokens["icon-on-success-base"]     = on_color(succb)
  tokens["icon-on-success-hover"]    = on_color(succs)
  tokens["icon-on-success-selected"] = on_color(succs)
  tokens["icon-on-warning-base"]     = on_color(warnb)
  tokens["icon-on-warning-hover"]    = on_color(warns)
  tokens["icon-on-warning-selected"] = on_color(warns)
  tokens["icon-on-critical-base"]     = on_color(critb)
  tokens["icon-on-critical-hover"]    = on_color(crits)
  tokens["icon-on-critical-selected"] = on_color(crits)
  tokens["icon-on-info-base"]     = on_color(infob)
  tokens["icon-on-info-hover"]    = on_color(infos)
  tokens["icon-on-info-selected"] = on_color(infos)

  tokens["icon-diff-add-base"]       = diffAdd[11]
  tokens["icon-diff-add-hover"]      = diffAdd[isDark and 10 or 12] -- [9]/[11]
  tokens["icon-diff-add-active"]     = diffAdd[isDark and 11 or 12] -- [10]/[11]
  tokens["icon-diff-delete-base"]    = diffDelete[10]
  tokens["icon-diff-delete-hover"]   = diffDelete[isDark and 11 or 11] -- [10]/[10]
  tokens["icon-diff-modified-base"]  = modified()

  -- Syntax + markdown ------------------------------------------------------
  if colors.compact then
    tokens["syntax-comment"]     = "var(--text-weak)"
    tokens["syntax-regexp"]      = "var(--text-base)"
    tokens["syntax-string"]      = content(colors.success, success)
    tokens["syntax-keyword"]     = content(colors.accent, accent)
    tokens["syntax-primitive"]   = content(colors.primary, primary)
    tokens["syntax-operator"]    = isDark and "var(--text-weak)" or "var(--text-base)"
    tokens["syntax-variable"]    = "var(--text-strong)"
    tokens["syntax-property"]    = content(colors.info, info)
    tokens["syntax-type"]        = content(colors.warning, warning)
    tokens["syntax-constant"]    = content(colors.accent, accent)
    tokens["syntax-punctuation"] = isDark and "var(--text-weak)" or "var(--text-base)"
    tokens["syntax-object"]      = "var(--text-strong)"
    tokens["syntax-success"]     = success[11]
    tokens["syntax-warning"]     = amber[11]
    tokens["syntax-critical"]    = error_scale[11]
    tokens["syntax-info"]        = content(colors.info, info)
    tokens["syntax-diff-add"]    = diffAdd[11]
    tokens["syntax-diff-delete"] = diffDelete[11]
    tokens["syntax-diff-unknown"] = "#ff0000"

    tokens["markdown-heading"]          = content(colors.primary, primary)
    tokens["markdown-text"]             = tokens["text-base"]
    tokens["markdown-link"]             = content(colors.interactive, interactive)
    tokens["markdown-link-text"]        = content(colors.info, info)
    tokens["markdown-code"]             = content(colors.success, success)
    tokens["markdown-block-quote"]      = content(colors.warning, warning)
    tokens["markdown-emph"]             = content(colors.warning, warning)
    tokens["markdown-strong"]           = content(colors.accent, accent)
    tokens["markdown-horizontal-rule"]  = tokens["border-base"]
    tokens["markdown-list-item"]        = content(colors.interactive, interactive)
    tokens["markdown-list-enumeration"] = content(colors.info, info)
    tokens["markdown-image"]            = content(colors.interactive, interactive)
    tokens["markdown-image-text"]       = content(colors.info, info)
    tokens["markdown-code-block"]       = tokens["text-base"]
  else
    tokens["syntax-comment"]     = "var(--text-weak)"
    tokens["syntax-regexp"]      = "var(--text-base)"
    tokens["syntax-string"]      = isDark and "#00ceb9" or "#006656"
    tokens["syntax-keyword"]     = "var(--text-weak)"
    tokens["syntax-primitive"]   = isDark and "#ffba92" or "#fb4804"
    tokens["syntax-operator"]    = isDark and "var(--text-weak)" or "var(--text-base)"
    tokens["syntax-variable"]    = "var(--text-strong)"
    tokens["syntax-property"]    = isDark and "#ff9ae2" or "#ed6dc8"
    tokens["syntax-type"]        = isDark and "#ecf58c" or "#596600"
    tokens["syntax-constant"]    = isDark and "#93e9f6" or "#007b80"
    tokens["syntax-punctuation"] = isDark and "var(--text-weak)" or "var(--text-base)"
    tokens["syntax-object"]      = "var(--text-strong)"
    tokens["syntax-success"]     = success[11]
    tokens["syntax-warning"]     = amber[11]
    tokens["syntax-critical"]    = error_scale[11]
    tokens["syntax-info"]        = isDark and "#93e9f6" or "#0092a8"
    tokens["syntax-diff-add"]    = diffAdd[11]
    tokens["syntax-diff-delete"] = diffDelete[11]
    tokens["syntax-diff-unknown"] = "#ff0000"

    tokens["markdown-heading"]          = isDark and "#9d7cd8" or "#d68c27"
    tokens["markdown-text"]             = isDark and "#eeeeee" or "#1a1a1a"
    tokens["markdown-link"]             = isDark and "#fab283" or "#3b7dd8"
    tokens["markdown-link-text"]        = isDark and "#56b6c2" or "#318795"
    tokens["markdown-code"]             = isDark and "#7fd88f" or "#3d9a57"
    tokens["markdown-block-quote"]      = isDark and "#e5c07b" or "#b0851f"
    tokens["markdown-emph"]             = isDark and "#e5c07b" or "#b0851f"
    tokens["markdown-strong"]           = isDark and "#f5a742" or "#d68c27"
    tokens["markdown-horizontal-rule"]  = isDark and "#808080" or "#8a8a8a"
    tokens["markdown-list-item"]        = isDark and "#fab283" or "#3b7dd8"
    tokens["markdown-list-enumeration"] = isDark and "#56b6c2" or "#318795"
    tokens["markdown-image"]            = isDark and "#fab283" or "#3b7dd8"
    tokens["markdown-image-text"]       = isDark and "#56b6c2" or "#318795"
    tokens["markdown-code-block"]       = isDark and "#eeeeee" or "#1a1a1a"
  end

  -- Avatars ----------------------------------------------------------------
  tokens["avatar-background-pink"]   = isDark and "#501b3f" or "#feeef8"
  tokens["avatar-background-mint"]   = isDark and "#033a34" or "#e1fbf4"
  tokens["avatar-background-orange"] = isDark and "#5f2a06" or "#fff1e7"
  tokens["avatar-background-purple"] = isDark and "#432155" or "#f9f1fe"
  tokens["avatar-background-cyan"]   = isDark and "#0f3058" or "#e7f9fb"
  tokens["avatar-background-lime"]   = isDark and "#2b3711" or "#eefadc"
  tokens["avatar-text-pink"]   = isDark and "#e34ba9" or "#cd1d8d"
  tokens["avatar-text-mint"]   = isDark and "#95f3d9" or "#147d6f"
  tokens["avatar-text-orange"] = isDark and "#ff802b" or "#ed5f00"
  tokens["avatar-text-purple"] = isDark and "#9d5bd2" or "#8445bc"
  tokens["avatar-text-cyan"]   = isDark and "#369eff" or "#0894b3"
  tokens["avatar-text-lime"]   = isDark and "#c4f042" or "#5d770d"

  -- User overrides (win over everything above) -----------------------------
  for k, v in pairs(overrides) do
    tokens[k] = v
  end

  -- Post-override derivations mirroring resolve.ts --------------------------
  if colors.compact and overrides["text-weak"] and not overrides["text-weaker"] then
    local weak = tokens["text-weak"]
    if type(weak) == "string" and weak:sub(1, 1) == "#" then
      tokens["text-weaker"] = color.shift(weak, {
        l = isDark and -0.12 or 0.12,
        c = 0.75,
      })
    else
      tokens["text-weaker"] = weak
    end
  end

  if colors.compact then
    if not overrides["markdown-text"] then
      tokens["markdown-text"] = tokens["text-base"]
    end
    if not overrides["markdown-code-block"] then
      tokens["markdown-code-block"] = tokens["text-base"]
    end
  end

  if not overrides["text-stronger"] then
    tokens["text-stronger"] = tokens["text-strong"]
  end

  return tokens
end

---Resolve both variants at once.
---@param theme table  parsed oc-2.json
---@return { light: table, dark: table }
function M.resolveTheme(theme)
  return {
    light = M.resolveThemeVariant(theme.light, false),
    dark  = M.resolveThemeVariant(theme.dark, true),
  }
end

-- ---------------------------------------------------------------------------
-- Flatten token values that are `var(--name)` or `rgba(...)` into concrete
-- hex strings, suitable for consumers (nvim) that can't render CSS vars /
-- alpha. Called once after `resolveThemeVariant`.

local function parse_rgba(s)
  -- rgba(R, G, B, A)
  local r, g, b, a = s:match("^rgba%((%d+),%s*(%d+),%s*(%d+),%s*([%d%.]+)%)$")
  if not r then return nil end
  return tonumber(r), tonumber(g), tonumber(b), tonumber(a)
end

---Resolve a `var(--token)` reference chain to its final hex value, with a
---small cycle guard.
local function resolve_var(tokens, value, seen)
  seen = seen or {}
  while type(value) == "string" and value:sub(1, 4) == "var(" do
    local name = value:match("^var%(%-%-(.-)%)$")
    if not name or seen[name] then return value end
    seen[name] = true
    value = tokens[name]
  end
  return value
end

---Turn an `rgba(...)` overlay string into a hex color by compositing it
---against the resolved background-base (or a caller-provided hex).
local function rgba_to_hex(rgba_str, bg_hex)
  local r, g, b, a = parse_rgba(rgba_str)
  if not r then return nil end
  local br, bg_, bb = color.hexToRgb(bg_hex)
  local fr, fg_, fb = r / 255, g / 255, b / 255
  return color.rgbToHex(
    fr * a + br * (1 - a),
    fg_ * a + bg_ * (1 - a),
    fb * a + bb * (1 - a)
  )
end

---Return a new table where every value is a `#rrggbb` string. `var(...)`
---chains are resolved; `rgba(...)` overlays are composited onto the
---resolved `background-base`.
function M.flatten(tokens)
  local bg = tokens["background-base"] or "#000000"
  if type(bg) == "string" and bg:sub(1, 1) ~= "#" then
    bg = resolve_var(tokens, bg) or "#000000"
    if type(bg) ~= "string" or bg:sub(1, 1) ~= "#" then bg = "#000000" end
  end

  local out = {}
  for k, v in pairs(tokens) do
    local resolved = resolve_var(tokens, v)
    if type(resolved) == "string" then
      if resolved:sub(1, 4) == "rgba" then
        local hex = rgba_to_hex(resolved, bg)
        out[k] = hex or resolved
      elseif resolved:sub(1, 1) == "#" then
        -- Preserve 8-digit hex (#rrggbbaa) by flattening onto bg.
        if #resolved == 9 then
          local ar, ag, ab = color.hexToRgb(resolved:sub(1, 7))
          local alpha = tonumber(resolved:sub(8, 9), 16) / 255
          local br, bg2, bb = color.hexToRgb(bg)
          out[k] = color.rgbToHex(
            ar * alpha + br * (1 - alpha),
            ag * alpha + bg2 * (1 - alpha),
            ab * alpha + bb * (1 - alpha)
          )
        else
          out[k] = resolved
        end
      else
        out[k] = resolved
      end
    else
      out[k] = resolved
    end
  end
  return out
end

return M
