-- Loads opencode's oc-2 theme JSON and runs it through the 1:1 Lua port of
-- `resolve.ts` to produce the full ~248-token table that opencode ships
-- client-side. A small set of friendly aliases (`c.bg`, `c.fg`, `c.keyword`,
-- etc.) sit on top so the highlight-group modules don't have to sprinkle
-- bracket-string lookups everywhere.
--
-- Every value in the returned table is a concrete `#rrggbb` string:
--   * `var(--token)` references are resolved recursively
--   * `rgba(...)` overlays are composited against `background-base`
--   * `#rrggbbaa` 8-digit hex is flattened onto the background too
--
-- Source theme JSON:
--   https://github.com/anomalyco/opencode/blob/dev/packages/ui/src/theme/themes/oc-2.json

local resolve = require("oc-2.resolve")

local M = {}

local PLUGIN_ROOT = debug.getinfo(1, "S").source:sub(2):match("(.*/)"):gsub("/lua/oc%-2/$", "")
local THEME_PATH = PLUGIN_ROOT .. "/lua/oc-2/themes/oc-2.json"

---Read a file and return its contents.
local function read_file(path)
  local f, err = io.open(path, "r")
  if not f then error("oc-2: cannot open " .. path .. ": " .. tostring(err)) end
  local data = f:read("*a")
  f:close()
  return data
end

---@type { light: table<string, string>?, dark: table<string, string>? }
local cache = {}

---Load oc-2.json and resolve+flatten both variants. Result is cached.
local function load_resolved()
  if cache.dark and cache.light then return cache end
  local raw = read_file(THEME_PATH)
  local theme = vim.json.decode(raw)
  local resolved = resolve.resolveTheme(theme)
  cache.light = resolve.flatten(resolved.light)
  cache.dark  = resolve.flatten(resolved.dark)
  return cache
end

-- ---------------------------------------------------------------------------
-- Aliases — keep the highlight-group code readable. The left-hand name is
-- what the editor.lua / syntax.lua / etc. modules reference; the right-hand
-- token name matches opencode's resolve.ts output exactly.

local function build_aliases(t, isDark)
  local a = {}

  -- Surfaces / backgrounds
  a.bg            = t["surface-base"]              -- main editor bg
  a.bg_dark       = t["background-base"]           -- darker inset (statusline)
  a.bg_highlight  = t["surface-raised-base"]       -- slightly lifted panels
  a.bg_float      = t["surface-float-base"]        -- floating windows
  a.bg_visual     = t["surface-raised-base-hover"] -- visual/select hover
  a.bg_statusline = t["background-base"]
  a.bg_sidebar    = t["surface-base"]
  a.bg_popup      = t["surface-float-base"]
  a.bg_cursorline = t["surface-raised-base"]
  a.bg_menu_sel   = t["surface-base-active"]
  a.bg_inset      = t["surface-inset-base"]

  -- Text
  a.fg          = t["text-base"]
  a.fg_dark     = t["text-weak"]
  a.fg_gutter   = t["text-weaker"]
  a.fg_strong   = t["text-strong"]
  a.fg_invert   = t["text-invert-base"]

  -- Borders
  a.border        = t["border-base"]
  a.border_weak   = t["border-weak-base"]
  a.border_weaker = t["border-weaker-base"]
  a.border_strong = t["border-strong-base"]

  -- Syntax — the actual colors opencode's desktop editor paints code with.
  -- These match the scope -> `--syntax-*` wiring in
  -- packages/ui/src/context/marked.tsx (Shiki "OpenCode" theme).
  a.comment     = t["syntax-comment"]
  a.keyword     = t["syntax-keyword"]
  a.string      = t["syntax-string"]
  -- `number` / `boolean` / `constant` all resolve to `syntax-constant`
  -- (cyan) per `semanticTokenColors.number` / tmtheme `constant` scope.
  a.number      = t["syntax-constant"]
  a.property    = t["syntax-property"]
  a.type        = t["syntax-type"]
  a.constant    = t["syntax-constant"]
  a.operator    = t["syntax-operator"]
  a.punctuation = t["syntax-punctuation"]
  a.regex       = t["syntax-regexp"]
  -- `entity.name.tag` -> syntax-string per tmtheme scope.
  a.tag         = t["syntax-string"]
  a.variable    = t["syntax-variable"]
  a.object      = t["syntax-object"]
  -- `function` goes to `syntax-primitive` (soft blue) per
  -- `semanticTokenColors.function`.
  a["function"] = t["syntax-primitive"]
  a.method      = t["syntax-primitive"]

  -- Semantic seeds (useful for anything not syntax-ish)
  -- Pulling the underlying seed colors straight from oc-2.json so
  -- green/red/etc are the pure palette values, not scaled ones.
  a.success = "#12c905"
  a.warning = "#fcd53a"
  a.error   = "#fc533a"
  a.info    = isDark and "#edb2f1" or "#a753ae"

  -- Diagnostics — map to semantic tokens the web UI exposes.
  -- `syntax-critical` for errors leans orange in compact dark mode
  -- (opencode style), so route diagnostics through the pure seeds instead
  -- for a more universally recognizable red/yellow/blue/green.
  a.diag_error = isDark and "#fc533a" or "#fc533a"
  a.diag_warn  = isDark and "#fcd53a" or "#ff8c00"
  a.diag_info  = t["syntax-info"]
  a.diag_hint  = t["syntax-keyword"]
  a.diag_ok    = "#12c905"

  -- Named palette. These are the seeds you'd reach for when you want
  -- "the red one" or "the yellow one" — pulled straight from
  -- oc-2.json's palette so they look like what opencode calls them.
  a.primary     = isDark and "#fab283" or "#ff8c00"
  a.orange      = a.primary
  a.yellow      = isDark and "#fcd53a" or "#b0851f"
  a.green       = "#12c905"
  a.red         = "#fc533a"
  a.blue        = isDark and "#8cb0ff" or "#034cff"
  a.pink        = isDark and "#edb2f1" or "#a753ae"
  a.cyan        = isDark and "#93e9f6" or "#007b80"
  a.magenta     = a.pink
  a.hint        = a.pink
  a.interactive = t["icon-interactive-base"]

  -- Diff surfaces + foregrounds
  a.diff_add       = t["surface-diff-add-base"]
  a.diff_add_weak  = t["surface-diff-add-weak"]
  a.diff_add_text  = t["text-diff-add-base"]
  a.diff_delete    = t["surface-diff-delete-base"]
  a.diff_delete_weak = t["surface-diff-delete-weak"]
  a.diff_delete_text = t["text-diff-delete-base"]
  a.diff_delete_fg = t["icon-diff-delete-base"]
  a.diff_change    = t["surface-warning-base"]
  a.diff_change_weak = t["surface-warning-weak"]
  a.diff_text      = t["surface-warning-weak"]

  -- Git signs — use the strongest tone so they read in the gutter.
  a.git_add    = t["icon-diff-add-base"]
  a.git_change = t["icon-diff-modified-base"]
  a.git_delete = t["icon-diff-delete-base"]

  -- Search / selection washes ---------------------------------------------
  --
  -- The Visual selection uses the same color the opencode desktop editor
  -- uses in its diff viewer:
  --     --diffs-bg-selection: rgb(from var(--surface-warning-base) r g b / 0.65);
  --   (packages/ui/src/pierre/index.ts)
  --
  -- surface-inset-base-hover (our previous pick) was only ~7 units of
  -- luminance above the editor background — effectively invisible. The
  -- muted-gold blend below sits around 30-35 units above bg, which reads
  -- clearly without overpowering the selected text.
  local color = require("oc-2.color")
  a.bg_selection = color.blend(t["surface-warning-base"], t["surface-base"], 0.65)
  a.bg_selection_fg = t["text-strong"]

  -- Search uses a slightly stronger tone so multi-match highlighting
  -- stays distinct from the single active Visual selection. 0.85 alpha
  -- of the warning surface over bg gives ≈1.5x the contrast of the
  -- selection wash.
  a.bg_search    = color.blend(t["surface-warning-base"], t["surface-base"], 0.85)
  a.bg_search_fg = t["text-strong"]

  -- MatchParen / braces / bracket-pair — a subtle interactive tint.
  a.bg_match     = t["surface-interactive-weak"]

  -- Terminal ANSI palette -------------------------------------------------
  -- Pulled from the seed palette so `:terminal` reads as a direct ANSI
  -- translation of oc-2's colours (instead of a dimmed derived scale).
  a.terminal = {}
  if isDark then
    a.terminal = {
      black          = t["background-base"],
      red            = "#fc533a",
      green          = "#12c905",
      yellow         = "#fcd53a",
      blue           = "#8cb0ff",
      magenta        = "#edb2f1",
      cyan           = "#93e9f6",
      white          = "#ededed",
      bright_black   = t["text-weaker"],
      bright_red     = "#fc644e",
      bright_green   = "#2ace1e",
      bright_yellow  = "#fcd84a",
      bright_blue    = "#98b8ff",
      bright_magenta = "#eeb8f2",
      bright_cyan    = "#9cebf7",
      bright_white   = "#ffffff",
    }
  else
    a.terminal = {
      black          = "#171311",
      red            = "#fc533a",
      green          = "#12c905",
      yellow         = "#b0851f",
      blue           = "#034cff",
      magenta        = "#a753ae",
      cyan           = "#007b80",
      white          = "#6f6f6f",
      bright_black   = "#c7c7c7",
      bright_red     = "#e84c35",
      bright_green   = "#11b905",
      bright_yellow  = "#8a6f00",
      bright_blue    = "#0346eb",
      bright_magenta = "#9a4ca0",
      bright_cyan    = "#007176",
      bright_white   = "#000000",
    }
  end

  a.none = "NONE"

  return a
end

---Return the full palette for a variant.
---
---The returned table contains:
---   * every resolved opencode token (`["surface-base"]`, `["text-weak"]`,
---     …) for advanced users / `on_highlights` hooks.
---   * convenient aliases (`.bg`, `.fg`, `.keyword`, `.string`, …) for the
---     highlight-group modules.
---   * `.terminal` — 16-color ANSI palette.
---
---@param style? "dark" | "light"
---@return table
function M.get(style)
  style = style or "dark"
  local resolved = load_resolved()
  local variant  = (style == "light") and resolved.light or resolved.dark
  local isDark   = style ~= "light"

  local out = {}
  -- Copy all resolved tokens verbatim.
  for k, v in pairs(variant) do out[k] = v end
  -- Layer aliases on top (these never clash with token names since tokens
  -- use hyphens and aliases use underscores / single words).
  for k, v in pairs(build_aliases(variant, isDark)) do out[k] = v end
  return out
end

---Raw flattened resolved tokens, without aliases. Useful for emitting
---terminal themes and debugging.
---@param style? "dark" | "light"
---@return table<string, string>
function M.tokens(style)
  style = style or "dark"
  local resolved = load_resolved()
  if style == "light" then return vim.deepcopy(resolved.light) end
  return vim.deepcopy(resolved.dark)
end

---Clear the resolver cache. Used by tests / live development.
function M._reset_cache()
  cache = {}
end

return M
