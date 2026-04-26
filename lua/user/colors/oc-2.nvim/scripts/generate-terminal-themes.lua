-- Regenerate extras/{base16,ghostty,kitty}/*.{yaml,conf} from the resolved
-- oc-2 palette. Run with:
--
--   nvim --headless --clean -u NONE \
--     -c 'set rtp^=/Users/hy/.config/nvim/lua/user/colors/oc-2.nvim' \
--     -l lua/user/colors/oc-2.nvim/scripts/generate-terminal-themes.lua
--
-- Any edits to `lua/oc-2/themes/oc-2.json` or the resolver flow through
-- here, so the six terminal files stay in lock-step with the Neovim
-- colorscheme.

local palette = require("oc-2.palette")

local ROOT = debug.getinfo(1, "S").source:sub(2):match("(.*)/scripts/")
assert(ROOT, "cannot determine plugin root")
local EXTRAS = ROOT .. "/extras"

local function strip_hash(s) return (s or ""):gsub("^#", "") end

local function write(path, content)
  local dir = path:match("(.*)/")
  os.execute("mkdir -p " .. dir)
  local f = assert(io.open(path, "w"))
  f:write(content)
  f:close()
  print("wrote " .. path)
end

-- Build the 16 ANSI colors from the seed palette. We keep this logic here
-- so every terminal format uses the same mapping. The bright variants are
-- lightened by a small delta in OKLCH space (via our color utils) so the
-- difference is visible but restrained.
local color = require("oc-2.color")

local function make_ansi(style)
  local isDark = style ~= "light"
  if isDark then
    return {
      "#171717",                                      -- 0 black
      "#fc533a",                                      -- 1 red
      "#12c905",                                      -- 2 green
      "#fcd53a",                                      -- 3 yellow
      "#8cb0ff",                                      -- 4 blue
      "#edb2f1",                                      -- 5 magenta
      "#93e9f6",                                      -- 6 cyan
      "#ededed",                                      -- 7 white
      "#505050",                                      -- 8 bright black
      color.lighten("#fc533a", 0.05),                 -- 9 bright red
      color.lighten("#12c905", 0.05),                 -- 10 bright green
      color.lighten("#fcd53a", 0.03),                 -- 11 bright yellow
      color.lighten("#8cb0ff", 0.05),                 -- 12 bright blue
      color.lighten("#edb2f1", 0.03),                 -- 13 bright magenta
      color.lighten("#93e9f6", 0.03),                 -- 14 bright cyan
      "#ffffff",                                      -- 15 bright white
    }
  end
  return {
    "#171311",
    "#fc533a",
    "#12c905",
    "#b0851f",
    "#034cff",
    "#a753ae",
    "#007b80",
    "#6f6f6f",
    "#c7c7c7",
    color.darken("#fc533a", 0.05),
    color.darken("#12c905", 0.05),
    "#8a6f00",
    color.darken("#034cff", 0.03),
    color.darken("#a753ae", 0.05),
    color.darken("#007b80", 0.04),
    "#000000",
  }
end

-- ---------------------------------------------------------------------------
-- Emitters

local function emit_base16(style)
  local c = palette.get(style)
  local name = (style == "light") and "OC-2 Light" or "OC-2 Dark"
  local variant = style or "dark"

  -- Base16 semantic slots, derived from opencode's resolved `syntax-*`
  -- tokens so the palette agrees with what the desktop editor paints.
  --
  --   base00-07 = monochrome ramp
  --   base08    = red / variables / deleted            -> error seed
  --   base09    = orange / numbers & booleans          -> syntax-constant (cyan)
  --                 opencode's semanticTokenColors.number is syntax-constant,
  --                 so this slot holds cyan. Base16 templates that paint
  --                 numbers with base09 will render them cyan — matching
  --                 the desktop editor.
  --   base0A    = yellow / classes / types             -> syntax-type
  --   base0B    = green / strings                      -> syntax-string (mint)
  --   base0C    = cyan / constants / escapes           -> syntax-constant
  --   base0D    = blue / functions                     -> syntax-primitive (soft blue)
  --                 Opencode's semanticTokenColors.function/method resolve
  --                 to syntax-primitive, which IS blue. This was previously
  --                 wired to the opencode "primary" (orange); that was
  --                 wrong — primary is a brand/accent color, not the
  --                 function color.
  --   base0E    = magenta / keywords                   -> syntax-keyword (pink)
  --   base0F    = brown / deprecated / accent          -> brand primary (orange)
  --                 No natural opencode mapping for this slot, so we park
  --                 the brand accent here. Templates that reserve base0F
  --                 for deprecated/rare tokens will render them in the
  --                 brand orange, which reads as a distinct highlight.
  local slots
  if style == "light" then
    slots = {
      base00 = c.bg,                       -- surface-base
      base01 = c["surface-raised-base"],
      base02 = c["surface-raised-base-hover"],
      base03 = c.comment,                  -- syntax-comment
      base04 = c.fg_dark,                  -- text-weak
      base05 = c.fg,                       -- text-base
      base06 = c.fg_strong,                -- text-strong
      base07 = "#000000",
      base08 = c.red,
      base09 = c["syntax-constant"],       -- numbers/booleans (cyan)
      base0A = c.type,                     -- syntax-type
      base0B = c.string,                   -- syntax-string
      base0C = c.constant,                 -- syntax-constant
      base0D = c["syntax-primitive"],      -- functions (blue)
      base0E = c.keyword,                  -- syntax-keyword
      base0F = c.primary,                  -- brand accent (orange)
    }
  else
    slots = {
      base00 = c.bg,
      base01 = c.bg_highlight,
      base02 = c["surface-raised-base-hover"],
      base03 = c.comment,
      base04 = c.fg_dark,
      base05 = c.fg,
      base06 = c.fg_strong,
      base07 = "#f7f7f7",
      base08 = c.red,
      base09 = c["syntax-constant"],       -- #93e9f6 cyan
      base0A = c.type,
      base0B = c.string,
      base0C = c.constant,
      base0D = c["syntax-primitive"],      -- #8cb0ff blue
      base0E = c.keyword,
      base0F = c.primary,                  -- #fab283 brand orange
    }
  end

  local lines = {
    'system: "base16"',
    string.format('name: "%s"', name),
    'author: "Port of opencode\'s oc-2 theme"',
    string.format('variant: "%s"', variant),
    '# Source palette:',
    '#   https://github.com/anomalyco/opencode/blob/dev/packages/ui/src/theme/themes/oc-2.json',
    '# Generated from the resolved oc-2 token table via',
    '#   scripts/generate-terminal-themes.lua',
    'palette:',
  }
  local order = { "base00","base01","base02","base03","base04","base05","base06","base07","base08","base09","base0A","base0B","base0C","base0D","base0E","base0F" }
  for _, k in ipairs(order) do
    lines[#lines + 1] = string.format('  %s: "%s"', k, strip_hash(slots[k]))
  end

  write(string.format("%s/base16/oc-2-%s.yaml", EXTRAS, variant), table.concat(lines, "\n") .. "\n")
end

local function emit_ghostty(style)
  local c = palette.get(style)
  local ansi = make_ansi(style)
  local variant = (style == "light") and "light" or "dark"
  local name = (style == "light") and "OC-2 Light" or "OC-2 Dark"

  local lines = {
    string.format("# %s — Ghostty theme", name),
    "# Port of opencode's oc-2 theme:",
    "#   https://github.com/anomalyco/opencode/blob/dev/packages/ui/src/theme/themes/oc-2.json",
    "# Generated by scripts/generate-terminal-themes.lua",
    "",
  }
  for i = 0, 15 do
    lines[#lines + 1] = string.format("palette = %d=%s", i, ansi[i + 1])
  end
  lines[#lines + 1] = ""
  lines[#lines + 1] = string.format("background = %s", strip_hash(c.bg))
  lines[#lines + 1] = string.format("foreground = %s", strip_hash(c.fg))
  lines[#lines + 1] = ""
  lines[#lines + 1] = string.format("cursor-color = %s", strip_hash(c.primary))
  lines[#lines + 1] = string.format("cursor-text = %s", strip_hash(c.bg))
  lines[#lines + 1] = ""
  lines[#lines + 1] = string.format("selection-background = %s", strip_hash(c.bg_selection))
  lines[#lines + 1] = string.format("selection-foreground = %s", strip_hash(c.fg_strong))

  write(string.format("%s/ghostty/oc-2-%s", EXTRAS, variant), table.concat(lines, "\n") .. "\n")
end

local function emit_kitty(style)
  local c = palette.get(style)
  local ansi = make_ansi(style)
  local variant = (style == "light") and "light" or "dark"
  local name = (style == "light") and "OC-2 Light" or "OC-2 Dark"
  local blurb = (style == "light")
    and "Crisp, warm light theme pulled from opencode's default UI"
    or "Warm, high-signal dark theme pulled from opencode's default UI"

  local lines = {
    "# vim:ft=kitty",
    "",
    string.format("## name:     %s", name),
    "## author:   Port of opencode's oc-2 theme",
    "## license:  MIT",
    "## upstream: https://github.com/anomalyco/opencode/blob/dev/packages/ui/src/theme/themes/oc-2.json",
    string.format("## blurb:    %s", blurb),
    "",
    "# Basic colors",
    string.format("foreground              %s", c.fg),
    string.format("background              %s", c.bg),
    string.format("selection_foreground    %s", c.fg_strong),
    string.format("selection_background    %s", c.bg_selection),
    "",
    "# Cursor",
    string.format("cursor                  %s", c.primary),
    string.format("cursor_text_color       %s", c.bg),
    "",
    "# URL / bell",
    string.format("url_color               %s", c.number),
    string.format("bell_border_color       %s", c.yellow),
    "",
    "# Window borders",
    string.format("active_border_color     %s", c.primary),
    string.format("inactive_border_color   %s", c.border),
    "",
    "# Tab bar",
    string.format("active_tab_foreground   %s", c.bg),
    string.format("active_tab_background   %s", c.primary),
    string.format("inactive_tab_foreground %s", c.fg),
    string.format("inactive_tab_background %s", c.bg_highlight),
    string.format("tab_bar_background      %s", c.bg_statusline),
    string.format("tab_bar_margin_color    %s", c.bg_statusline),
    "",
    "# Marks",
    string.format("mark1_foreground %s", c.bg),
    string.format("mark1_background %s", c.primary),
    string.format("mark2_foreground %s", c.bg),
    string.format("mark2_background %s", c.keyword),
    string.format("mark3_foreground %s", c.bg),
    string.format("mark3_background %s", c.cyan),
    "",
    "# The 16 terminal colors",
    "",
    "# black",
    string.format("color0 %s", ansi[1]),
    string.format("color8 %s", ansi[9]),
    "",
    "# red",
    string.format("color1 %s", ansi[2]),
    string.format("color9 %s", ansi[10]),
    "",
    "# green",
    string.format("color2  %s", ansi[3]),
    string.format("color10 %s", ansi[11]),
    "",
    "# yellow",
    string.format("color3  %s", ansi[4]),
    string.format("color11 %s", ansi[12]),
    "",
    "# blue",
    string.format("color4  %s", ansi[5]),
    string.format("color12 %s", ansi[13]),
    "",
    "# magenta",
    string.format("color5  %s", ansi[6]),
    string.format("color13 %s", ansi[14]),
    "",
    "# cyan",
    string.format("color6  %s", ansi[7]),
    string.format("color14 %s", ansi[15]),
    "",
    "# white",
    string.format("color7  %s", ansi[8]),
    string.format("color15 %s", ansi[16]),
  }

  write(string.format("%s/kitty/oc-2-%s.conf", EXTRAS, variant), table.concat(lines, "\n") .. "\n")
end

for _, style in ipairs({ "dark", "light" }) do
  emit_base16(style)
  emit_ghostty(style)
  emit_kitty(style)
end

print("done")
