local M = {
  "tpope/vim-fugitive",
  event = "VeryLazy",
}

function M.config()
  local wk = require("which-key")
  wk.register({
    ["<leader>gc"] = { "<CMD>Git commit<CR>", "Commit" },
    ["<leader>gp"] = { "<CMD>Git pull<CR>", "Pull" },
    ["<leader>gP"] = { "<CMD>Git push<CR>", "Push" },
  })
end

return M
