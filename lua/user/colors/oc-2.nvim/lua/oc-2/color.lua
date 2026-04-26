-- Line-for-line Lua port of opencode's `packages/ui/src/theme/color.ts`.
-- Function signatures, names, and semantics are kept identical so the
-- upstream resolve.ts port (`oc-2.resolve`) can consume this module
-- verbatim and produce byte-identical output for the same input.
--
-- Source:
--   https://github.com/anomalyco/opencode/blob/dev/packages/ui/src/theme/color.ts

local M = {}

local function clamp(v, min, max)
  if v < min then return min end
  if v > max then return max end
  return v
end

local function hue(v)
  return ((v % 360) + 360) % 360
end

-- Hex <-> RGB (channels in [0, 1]) -----------------------------------------

---@param hex string  "#rgb" / "#rgba" / "#rrggbb" / "#rrggbbaa"
---@return number r, number g, number b  each in [0, 1]
function M.hexToRgb(hex)
  local h = hex:gsub("#", "")
  -- Expand short form #rgb / #rgba to full 6/8 chars by duplicating digits.
  if #h == 3 or #h == 4 then
    local out = {}
    for i = 1, #h do
      out[#out + 1] = h:sub(i, i) .. h:sub(i, i)
    end
    h = table.concat(out)
  end
  -- Ignore alpha when present.
  local rgb = #h == 8 and h:sub(1, 6) or h
  local num = tonumber(rgb, 16)
  local r = math.floor(num / 65536) % 256
  local g = math.floor(num / 256) % 256
  local b = num % 256
  return r / 255, g / 255, b / 255
end

---@param r number in [0, 1]
---@param g number in [0, 1]
---@param b number in [0, 1]
---@return string hex  "#rrggbb"
function M.rgbToHex(r, g, b)
  local function to_hex(v)
    local clamped = clamp(v, 0, 1)
    local i = math.floor(clamped * 255 + 0.5) -- Math.round
    return string.format("%02x", i)
  end
  return "#" .. to_hex(r) .. to_hex(g) .. to_hex(b)
end

-- sRGB <-> linear ----------------------------------------------------------

local function linearToSrgb(c)
  if c <= 0.0031308 then return c * 12.92 end
  return 1.055 * c ^ (1 / 2.4) - 0.055
end

local function srgbToLinear(c)
  if c <= 0.04045 then return c / 12.92 end
  return ((c + 0.055) / 1.055) ^ 2.4
end

-- Math.cbrt: real cube root that preserves sign. Lua's `^` returns NaN
-- for negative bases with fractional exponents, so do it manually.
local function cbrt(x)
  if x < 0 then return -((-x) ^ (1 / 3)) end
  return x ^ (1 / 3)
end

-- RGB (linear-input sRGB, 0-1) <-> OKLCH ----------------------------------

---@return table { l, c, h }
function M.rgbToOklch(r, g, b)
  local lr = srgbToLinear(r)
  local lg = srgbToLinear(g)
  local lb = srgbToLinear(b)

  local l_ = 0.4122214708 * lr + 0.5363325363 * lg + 0.0514459929 * lb
  local m_ = 0.2119034982 * lr + 0.6806995451 * lg + 0.1073969566 * lb
  local s_ = 0.0883024619 * lr + 0.2817188376 * lg + 0.6299787005 * lb

  local l = cbrt(l_)
  local m = cbrt(m_)
  local s = cbrt(s_)

  local L  = 0.2104542553 * l + 0.7936177850 * m - 0.0040720468 * s
  local a  = 1.9779984951 * l - 2.4285922050 * m + 0.4505937099 * s
  local bO = 0.0259040371 * l + 0.7827717662 * m - 0.8086757660 * s

  local C = math.sqrt(a * a + bO * bO)
  local H = math.atan2(bO, a) * (180 / math.pi)
  if H < 0 then H = H + 360 end

  return { l = L, c = C, h = H }
end

---@param oklch table { l, c, h }
---@return number r, number g, number b in [0, 1] (may be out of gamut)
function M.oklchToRgb(oklch)
  local L, C, H = oklch.l, oklch.c, oklch.h

  local a = C * math.cos((H * math.pi) / 180)
  local b = C * math.sin((H * math.pi) / 180)

  local l = L + 0.3963377774 * a + 0.2158037573 * b
  local m = L - 0.1055613458 * a - 0.0638541728 * b
  local s = L - 0.0894841775 * a - 1.2914855480 * b

  local l3 = l * l * l
  local m3 = m * m * m
  local s3 = s * s * s

  local lr = 4.0767416621 * l3 - 3.3077115913 * m3 + 0.2309699292 * s3
  local lg = -1.2684380046 * l3 + 2.6097574011 * m3 - 0.3413193965 * s3
  local lb = -0.0041960863 * l3 - 0.7034186147 * m3 + 1.7076147010 * s3

  return linearToSrgb(lr), linearToSrgb(lg), linearToSrgb(lb)
end

function M.hexToOklch(hex)
  local r, g, b = M.hexToRgb(hex)
  return M.rgbToOklch(r, g, b)
end

-- Fit an OKLCH point back into sRGB gamut by iteratively reducing chroma.
-- Matches the 24-step 0.9x decay loop in color.ts so values line up exactly.
function M.fitOklch(oklch)
  local base = {
    l = clamp(oklch.l, 0, 1),
    c = math.max(0, oklch.c),
    h = hue(oklch.h),
  }

  local r, g, b = M.oklchToRgb(base)
  if r >= 0 and r <= 1 and g >= 0 and g <= 1 and b >= 0 and b <= 1 then
    return base
  end

  local c = base.c
  for _ = 1, 24 do
    c = c * 0.9
    local next = { l = base.l, c = c, h = base.h }
    local nr, ng, nb = M.oklchToRgb(next)
    if nr >= 0 and nr <= 1 and ng >= 0 and ng <= 1 and nb >= 0 and nb <= 1 then
      return next
    end
  end

  return { l = base.l, c = 0, h = base.h }
end

function M.oklchToHex(oklch)
  local r, g, b = M.oklchToRgb(M.fitOklch(oklch))
  return M.rgbToHex(r, g, b)
end

-- Scale generation ---------------------------------------------------------

---Generate a 12-step accent scale from a seed color in OKLCH space.
---@param seed string hex
---@param isDark boolean
---@return string[] 12-element list of hex colors
function M.generateScale(seed, isDark)
  local base = M.hexToOklch(seed)
  local scale = {}

  local lightSteps
  if isDark then
    lightSteps = {
      0.118, 0.138, 0.167, 0.202, 0.246, 0.304, 0.378, 0.468,
      clamp(base.l * 0.825, 0.53, 0.705),
      clamp(base.l * 0.89, 0.61, 0.79),
      clamp(base.l + 0.033, 0.868, 0.943),
      0.984,
    }
  else
    lightSteps = {
      0.993, 0.983, 0.962, 0.936, 0.906, 0.866, 0.811, 0.74,
      base.l,
      math.max(0, base.l - 0.036),
      0.49,
      0.27,
    }
  end

  local chromaMultipliers
  if isDark then
    chromaMultipliers = { 0.52, 0.68, 0.86, 1.02, 1.14, 1.24, 1.36, 1.48, 1.56, 1.64, 1.62, 1.15 }
  else
    chromaMultipliers = { 0.12, 0.24, 0.46, 0.68, 0.84, 0.98, 1.08, 1.16, 1.22, 1.26, 1.18, 0.98 }
  end

  for i = 1, 12 do
    scale[i] = M.oklchToHex({
      l = lightSteps[i],
      c = base.c * chromaMultipliers[i],
      h = base.h,
    })
  end

  return scale
end

---Neutral 12-step scale. If `ink` is provided, we blend from a computed
---background toward `ink` using the `steps` table (compact-mode behavior).
---Otherwise we build a low-chroma scale directly from the seed.
function M.generateNeutralScale(seed, isDark, ink)
  if ink then
    local base = M.hexToOklch(seed)
    local function lift(tone)
      return M.oklchToHex({
        l = base.l + (1 - base.l) * tone,
        c = base.c * math.max(0, 1 - tone),
        h = base.h,
      })
    end
    local function sink(tone)
      return M.oklchToHex({
        l = base.l * (1 - tone),
        c = base.c * math.max(0, 1 - tone * (isDark and 0.12 or 0.3)),
        h = base.h,
      })
    end

    local bg
    if isDark then
      local tone = clamp(0.19 + math.max(0, base.l - 0.12) * 0.33 + base.c * 1.95, 0.17, 0.27)
      bg = sink(tone)
    else
      if base.l < 0.82 then
        bg = lift(0.86)
      else
        local tone = clamp(0.1 + base.c * 3.2 + math.max(0, 0.95 - base.l) * 0.35, 0.1, 0.28)
        bg = lift(tone)
      end
    end

    local steps
    if isDark then
      steps = { 0, 0.018, 0.039, 0.064, 0.097, 0.143, 0.212, 0.31, 0.46, 0.649, 0.845, 0.984 }
    else
      steps = { 0, 0.022, 0.042, 0.068, 0.102, 0.146, 0.208, 0.296, 0.432, 0.61, 0.81, 0.965 }
    end

    local out = {}
    for i, step in ipairs(steps) do
      out[i] = M.mixColors(bg, ink, step)
    end
    return out
  end

  local base = M.hexToOklch(seed)
  local scale = {}
  local neutralChroma = math.min(base.c, isDark and 0.068 or 0.04)

  local lightSteps
  if isDark then
    lightSteps = {
      0.138, 0.156, 0.178, 0.202, 0.232, 0.272, 0.326, 0.404,
      clamp(base.l * 0.83, 0.43, 0.55),
      0.596, 0.719, 0.956,
    }
  else
    lightSteps = {
      0.991, 0.979, 0.964, 0.946, 0.931, 0.913, 0.891, 0.83,
      base.l,
      0.617, 0.542, 0.205,
    }
  end

  for i = 1, 12 do
    scale[i] = M.oklchToHex({
      l = lightSteps[i],
      c = neutralChroma,
      h = base.h,
    })
  end

  return scale
end

---Compositing scale over pure black / pure white using per-step alpha.
function M.generateAlphaScale(scale, isDark)
  local alphas
  if isDark then
    alphas = { 0.02, 0.04, 0.08, 0.12, 0.16, 0.2, 0.26, 0.36, 0.44, 0.52, 0.76, 0.96 }
  else
    alphas = { 0.01, 0.03, 0.06, 0.09, 0.12, 0.15, 0.2, 0.28, 0.48, 0.56, 0.64, 0.88 }
  end

  local out = {}
  for i, hex in ipairs(scale) do
    local r, g, b = M.hexToRgb(hex)
    local a = alphas[i]
    local bg = isDark and 0 or 1
    out[i] = M.rgbToHex(r * a + bg * (1 - a), g * a + bg * (1 - a), b * a + bg * (1 - a))
  end
  return out
end

-- mix in OKLCH space, picking the shortest arc for the hue
function M.mixColors(c1_hex, c2_hex, amount)
  local c1 = M.hexToOklch(c1_hex)
  local c2 = M.hexToOklch(c2_hex)
  local delta = ((((c2.h - c1.h) % 360) + 540) % 360) - 180
  return M.oklchToHex({
    l = c1.l + (c2.l - c1.l) * amount,
    c = c1.c + (c2.c - c1.c) * amount,
    h = c1.h + delta * amount,
  })
end

function M.shift(color, value)
  local base = M.hexToOklch(color)
  return M.oklchToHex({
    l = base.l + (value.l or 0),
    c = base.c * (value.c or 1),
    h = base.h + (value.h or 0),
  })
end

---Linear sRGB blend. `alpha = 1` returns foreground, `alpha = 0` returns bg.
function M.blend(color, background, alpha)
  local fr, fg, fb = M.hexToRgb(color)
  local br, bg_, bb = M.hexToRgb(background)
  return M.rgbToHex(
    fr * alpha + br * (1 - alpha),
    fg * alpha + bg_ * (1 - alpha),
    fb * alpha + bb * (1 - alpha)
  )
end

function M.lighten(color, amount)
  local oklch = M.hexToOklch(color)
  oklch.l = clamp(oklch.l + amount, 0, 1)
  return M.oklchToHex(oklch)
end

function M.darken(color, amount)
  local oklch = M.hexToOklch(color)
  oklch.l = clamp(oklch.l - amount, 0, 1)
  return M.oklchToHex(oklch)
end

---Mirrors the TS `withAlpha`: produces a `rgba(R, G, B, A)` string. Consumers
---(e.g. resolve.lua) decide how to flatten this into concrete hex when
---needed; the token-resolution path ends up blending these strings against
---the resolved background before nvim sees them.
function M.withAlpha(color, alpha)
  local r, g, b = M.hexToRgb(color)
  return string.format("rgba(%d, %d, %d, %s)",
    math.floor(r * 255 + 0.5),
    math.floor(g * 255 + 0.5),
    math.floor(b * 255 + 0.5),
    tostring(alpha))
end

return M
