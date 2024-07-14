local M = {
  "folke/persistence.nvim",
  event = "BufReadPre",
}

function M.config()
  require("persistence").setup({
    options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
    dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"), -- directory where session files are saved
    pre_save = nil, -- a function to call before saving the session
    save_empty = false, -- don't save if there are no open file buffers
  })
  local wk = require("which-key")
  wk.add({
    { "<leader>Sd", "<cmd>lua require('persistence').stop()<cr>", desc = "Don't Save Current Session" },
    { "<leader>Sl", "<cmd>lua require('persistence').load({ last = true })<cr>", desc = "Restore Last Session" },
    { "<leader>Sr", "<cmd>lua require('persistence').load()<cr>", desc = "Restore Session" },
  })
end

return M
