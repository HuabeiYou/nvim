local M = {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
  },
}

local function mark_file()
  require("harpoon"):list():append()
  vim.notify("󱡅  file marked")
end

local function toggle_quick_menu()
  local harpoon = require("harpoon")
  harpoon.ui:toggle_quick_menu(harpoon:list())
end

function M.config()
  require("harpoon"):setup({
    settings = {
      save_on_toggle = true,
      sync_on_ui_close = true,
    },
  })
  local keymap = vim.keymap.set
  local opts = { noremap = true, silent = true }

  keymap("n", "<S-m>", mark_file, opts)
  keymap("n", "<S-l>", "<cmd>lua require('harpoon'):list():next()<cr>", opts)
  keymap("n", "<S-h>", "<cmd>lua require('harpoon'):list():prev()<cr>", opts)
  keymap("n", "<S-TAB>", toggle_quick_menu, opts)
end

return M
