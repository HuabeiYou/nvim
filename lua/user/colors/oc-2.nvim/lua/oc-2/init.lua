-- oc-2.nvim
--
-- A port of opencode's `oc-2` theme (the default "OC-2" appearance of the
-- opencode web/desktop UI) to Neovim. Source palette:
--   https://github.com/anomalyco/opencode/blob/dev/packages/ui/src/theme/themes/oc-2.json
--
-- Plugin structure is inspired by folke/tokyonight.nvim and catppuccin/nvim:
-- there's a top-level `setup({...})` that stores options, a `load()` that
-- applies the scheme, and a `colors/oc-2.lua` entry point so the standard
-- `:colorscheme oc-2` command works.
--
-- Usage:
--   require("oc-2").setup({ style = "dark" })
--   vim.cmd.colorscheme("oc-2")

local M = {}

---@class OC2Options
---@field style? "dark" | "light"
---@field transparent? boolean
---@field styles? { comments?: table, keywords?: table, functions?: table }
---@field on_highlights? fun(hl: table<string, table>, c: OC2Palette)

---@type OC2Options
local defaults = {
  style = "dark",
  transparent = false,
  styles = {
    comments  = { italic = true },
    keywords  = { italic = false },
    functions = { bold = false },
  },
  on_highlights = nil,
}

M.options = vim.deepcopy(defaults)

---@param opts? OC2Options
function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts or {})
end

---@param opts? OC2Options
function M.load(opts)
  local merged = vim.tbl_deep_extend("force", vim.deepcopy(M.options), opts or {})
  require("oc-2.theme").apply(merged)
end

---Return the palette for inspection (useful in `on_highlights`).
---@param style? "dark" | "light"
---@return OC2Palette
function M.colors(style)
  return require("oc-2.palette").get(style or M.options.style)
end

return M
