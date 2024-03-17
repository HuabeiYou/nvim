local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<Space>", "", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

keymap("i", "jk", "<Esc>", opts)

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<S-TAB>", "<C-6>", opts)

keymap("n", "n", "nzz", opts)
keymap("n", "N", "Nzz", opts)
keymap("n", "*", "*zz", opts)
keymap("n", "#", "#zz", opts)
keymap("n", "g*", "g*zz", opts)
keymap("n", "g#", "g#zz", opts)

keymap("n", "[d", function()
  vim.diagnostic.goto_prev()
  vim.cmd("normal! zz")
end, opts)
keymap("n", "]d", function()
  vim.diagnostic.goto_next()
  vim.cmd("normal! zz")
end, opts)

keymap("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

keymap("x", "p", [["_dP]])

-- Delete without copying to the system clipboard
keymap({ "n", "v" }, "<leader>d", [["_d]])

-- Emacs-style insert mode
keymap({ "i" }, "<C-f>", "<Right>", opts)
keymap({ "i" }, "<C-b>", "<Left>", opts)
