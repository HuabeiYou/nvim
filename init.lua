if vim.env.VSCODE then
  vim.g.vscode = true
end

if vim.loader then
  vim.loader.enable()
end

require("user.options")
require("user.keymaps")
require("user.autocmds")

local plugins_enabled = {
  "colorscheme",
  "treesitter",
  "conform",
  "lsp",
  "cmp",
  "copilot",
  "sidekick",
  "telescope",
  "whichkey",
  "autopairs",
  "autotag",
  "harpoon",
  "lualine",
  "dial",
  "telescope-extra",
  -- "rustaceanvim",
  "devicons",
  "oil",
  "toggleterm",
  "gitsigns",
  "tabby",
  "quickfix",
  "matchup",
  "comment",
  "todo-comments",
  "colorizer",
  "dressing",
  "eyeliner",
  "flash",
  "fugitive",
  "trouble",
  "sleuth",
  "orgmode",
  "table-mode",
  "zen-mode",
  "zk-nvim",
  "navic",
  "undotree",
  "cloak",
  "mini",
  "persistence",
  "neogen",
  "markdown-preview",
  "nvim-surround",
  "dadbod",
  "tmux",
  "rainbow-delimiters",
  "lazydev",
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
