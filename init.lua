require("user.options")
require("user.keymaps")
require("user.autocmds")

local colorscheme = "catppuccin"

local plugins_enabled = {
  "colorscheme",
  "treesitter",
  "mason",
  "lspconfig",
  "cmp",
  "none-ls",
  "telescope",
  "whichkey",
  "autopairs",
  "autotag",
  "harpoon",
  "leap",
  "dial",
  "typescript-tools",
  "tsc",
  "rustaceanvim",
  "nvimtree",
  "oil",
  "devicons",
  "gitsigns",
  "alpha",
  "lualine",
  "tabby",
  "bqf",
  "indentline",
  "comment",
  "todo-comments",
  "colorizer",
  "illuminate",
  "eyeliner",
  "dressing",
  "neogit",
  "neoscroll",
  "trouble",
  "sleuth",
  "surround",
  "orgmode",
  "table-mode",
  "zen-mode",
  "zk-nvim",
  "oil",
}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

LAZY_SPEC = {}
for _, value in ipairs(plugins_enabled) do
  table.insert(LAZY_SPEC, { import = "user.plugins." .. value })
end

require("lazy").setup({
  spec = LAZY_SPEC,
  install = {
    -- install missing plugins on startup. This doesn't increase startup time.
    missing = true,
    -- try to load one of these colorschemes when starting an installation during startup
    colorscheme = { "habamax" },
  },
  checker = {
    -- automatically check for plugin updates
    enabled = false,
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  ui = {
    border = "single",
  },
})

local ok, _ = pcall(require, colorscheme)
if not ok then
  vim.cmd([[colorscheme habamax]])
else
  vim.cmd("colorscheme " .. colorscheme)
end
