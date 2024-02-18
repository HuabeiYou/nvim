local M = {
  "folke/trouble.nvim",
  lazy = false,
  config = function()
    -- vim.keymap.set("n", "]d", function()
    --   require("trouble").next({ skip_groups = true, jump = true })
    -- end)
    -- vim.keymap.set("n", "[d", function()
    --   require("trouble").previous({ skip_groups = true, jump = true })
    -- end)
    local wk = require("which-key")
    wk.register({
      ["<leader>ld"] = { "<cmd>Trouble<cr>", "Diagnostics" },
      ["<leader>lt"] = { "<cmd>TodoTrouble<cr>", "TODO" },
    })
  end,
}

return M
