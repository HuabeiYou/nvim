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
  local harpoon = require("harpoon")
  harpoon:setup({
    settings = {
      save_on_toggle = false,
      sync_on_ui_close = true,
    },
  })
  require("which-key").add({
    { "<S-m>", mark_file, { desc = "Harpoon: Mark file" } },
    { "<S-l>", "<cmd>lua require('harpoon'):list():next()<cr>", { desc = "Harpoon: Go to previous file" } },
    { "<S-h>", "<cmd>lua require('harpoon'):list():prev()<cr>", { desc = "Harpoon: Go to next file" } },
    {
      "<S-TAB>",
      function()
        toggle_quick_menu()
      end,
      { desc = "Open harpoon list" },
    },
  })
end

return M
