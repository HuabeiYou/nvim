local M = {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" } },
}

function M.config()
  local wk = require("which-key")
  wk.register({
    ["<leader>Sr"] = { "<cmd>lua require('persistence').load()<cr>", "Restore Session" },
    ["<leader>Sl"] = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore Last Session" },
    ["<leader>Sd"] = { "<cmd>lua require('persistence').stop()<cr>", "Don't Save Current Session" },
  })
end

return M
