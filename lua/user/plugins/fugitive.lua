local M = {
  "tpope/vim-fugitive",
  event = "VeryLazy",
}

function M.config()
  local wk = require("which-key")
  wk.add({
    { "<leader>gf", "<CMD>Git fetch<CR>", desc = "Fetch" },
    { "<leader>gP", "<CMD>Git push<CR>", desc = "Push" },
    { "<leader>gc", "<CMD>Git commit<CR>", desc = "Commit" },
    { "<leader>gp", "<CMD>Git pull<CR>", desc = "Pull" },
  })
end

return M
