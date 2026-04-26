-- Orchestrates the full highlight table by merging all group modules.
-- The output is a flat `{ [group] = attrs, ... }` table that init.lua feeds
-- into `nvim_set_hl`.

local palette = require("oc-2.palette")

local M = {}

local function merge(target, source)
  for k, v in pairs(source) do target[k] = v end
end

---@param opts OC2Options
function M.build(opts)
  opts = opts or {}
  local c = palette.get(opts.style)
  local hl = {}

  merge(hl, require("oc-2.groups.editor").get(c))
  merge(hl, require("oc-2.groups.syntax").get(c))
  merge(hl, require("oc-2.groups.treesitter").get(c))
  merge(hl, require("oc-2.groups.plugins").get(c))

  -- Style tweaks -----------------------------------------------------------
  if opts.transparent then
    local transparent_groups = {
      "Normal", "NormalNC", "NormalFloat", "SignColumn", "FoldColumn",
      "LineNr", "EndOfBuffer", "StatusLine", "StatusLineNC", "VertSplit",
      "WinSeparator", "WinBar", "WinBarNC",
      "TelescopeNormal", "TelescopeBorder",
      "TelescopeResultsNormal", "TelescopeResultsBorder",
      "TelescopePreviewNormal", "TelescopePreviewBorder",
      "NeoTreeNormal", "NeoTreeNormalNC",
    }
    for _, g in ipairs(transparent_groups) do
      if hl[g] then hl[g].bg = "NONE" end
    end
  end

  if opts.styles then
    if opts.styles.comments and opts.styles.comments.italic == false then
      if hl.Comment then hl.Comment.italic = nil end
    end
    if opts.styles.keywords and opts.styles.keywords.italic then
      if hl["@keyword"] then hl["@keyword"].italic = true end
    end
    if opts.styles.functions and opts.styles.functions.bold then
      if hl["@function"] then hl["@function"].bold = true end
    end
  end

  if type(opts.on_highlights) == "function" then
    opts.on_highlights(hl, c)
  end

  return hl, c
end

---@param opts OC2Options
function M.apply(opts)
  local hl, c = M.build(opts)

  -- Reset any previous scheme.
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true
  vim.g.colors_name = "oc-2"
  vim.o.background = (opts.style == "light") and "light" or "dark"

  for group, attrs in pairs(hl) do
    vim.api.nvim_set_hl(0, group, attrs)
  end

  -- Terminal color slots
  vim.g.terminal_color_0  = c.terminal.black
  vim.g.terminal_color_1  = c.terminal.red
  vim.g.terminal_color_2  = c.terminal.green
  vim.g.terminal_color_3  = c.terminal.yellow
  vim.g.terminal_color_4  = c.terminal.blue
  vim.g.terminal_color_5  = c.terminal.magenta
  vim.g.terminal_color_6  = c.terminal.cyan
  vim.g.terminal_color_7  = c.terminal.white
  vim.g.terminal_color_8  = c.terminal.bright_black
  vim.g.terminal_color_9  = c.terminal.bright_red
  vim.g.terminal_color_10 = c.terminal.bright_green
  vim.g.terminal_color_11 = c.terminal.bright_yellow
  vim.g.terminal_color_12 = c.terminal.bright_blue
  vim.g.terminal_color_13 = c.terminal.bright_magenta
  vim.g.terminal_color_14 = c.terminal.bright_cyan
  vim.g.terminal_color_15 = c.terminal.bright_white
end

return M
