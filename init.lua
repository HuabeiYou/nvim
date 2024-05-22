require("user.options")
require("user.keymaps")
require("user.autocmds")

local plugins_enabled = {
  "colorscheme",
  "treesitter",
  "mason",
  "lspconfig",
  "cmp",
  "conform",
  "telescope",
  "whichkey",
  "autopairs",
  "autotag",
  "harpoon",
  "dial",
  "telescope-extra",
  "rustaceanvim",
  "devicons",
  "oil",
  "toggleterm",
  "gitsigns",
  "tabby",
  "bqf",
  "matchup",
  "indentline",
  "comment",
  "todo-comments",
  "colorizer",
  "eyeliner",
  "dressing",
  "leap",
  "fugitive",
  "trouble",
  "sleuth",
  "orgmode",
  "table-mode",
  "zen-mode",
  "zk-nvim",
  "navic",
  "navbuddy",
  "undotree",
  "cloak",
  "fidget",
  "mini",
  "persistence",
  "neogen",
  "markdown-preview",
  "nvim-surround",
  "neoai",
  "dadbod",
  "tmux",
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
    colorscheme = { "default" },
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
    border = "rounded",
  },
})

vim.lsp.set_log_level("WARN")

-- silent the deprecation warning
vim.deprecate = function() end
