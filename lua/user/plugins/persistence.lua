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
  wk.register({
    ["<leader>Sr"] = { "<cmd>lua require('persistence').load()<cr>", "Restore Session" },
    ["<leader>Sl"] = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore Last Session" },
    ["<leader>Sd"] = { "<cmd>lua require('persistence').stop()<cr>", "Don't Save Current Session" },
  })
end

return M
