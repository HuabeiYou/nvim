local M = {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    plugins = {
      -- marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      presets = {
        operators = false,
        motions = false,
        text_objects = false,
        windows = false,
        nav = false,
        z = false,
        g = false,
      },
    },
    -- motions = {
    --   count = true,
    -- },
    window = {
      border = "shadow", -- none, single, double, shadow
      position = "bottom", -- bottom, top
      margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
      padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
      winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
      zindex = 1000, -- positive value to position WhichKey above other floating windows.
    },
    ignore_missing = false,
    show_help = false,
    show_keys = false,
    disable = {
      buftypes = {},
      filetypes = { "TelescopePrompt" },
    },
  },
}

function M.config()
  local mappings = {
    { "<leader>P", "<cmd>lua require('telescope').extensions.projects.projects()<CR>", desc = "Projects" },
    { "<leader>S", group = "Sessions" },
    { "<leader>T", group = "Test" },
    { "<leader>Ta", "<cmd>lua require('neotest').run.attach()<cr>", desc = "Attach Test" },
    { "<leader>Td", "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", desc = "Debug Test" },
    { "<leader>Tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "Test File" },
    { "<leader>Ts", "<cmd>lua require('neotest').run.stop()<cr>", desc = "Test Stop" },
    { "<leader>Tt", "<cmd>lua require'neotest'.run.run()<cr>", desc = "Test Nearest" },
    { "<leader>Z", group = "ZK" },
    { "<leader>b", group = "Buffers" },
    { "<leader>bb", "<cmd>Telescope buffers previewer=false only_cwd=true<cr>", desc = "List Buffers" },
    { "<leader>bd", "<cmd>bdelete<cr>", desc = "Delete Buffer" },
    { "<leader>bn", "<cmd>bnext<cr>", desc = "Next Buffer" },
    { "<leader>bp", "<cmd>bprevious<cr>", desc = "Previous Buffer" },
    { "<leader>d", group = "Debug" },
    { "<leader>f", group = "Find" },
    { "<leader>g", group = "Git" },
    { "<leader>h", "<cmd>nohlsearch<CR>", desc = "NOHL" },
    { "<leader>l", group = "LSP" },
    { "<leader>p", group = "Plugins" },
    { "<leader>t", group = "Tab" },
    { "<leader>ta", "<cmd>$tabnew<cr>", desc = "Add Tab" },
    { "<leader>tc", "<cmd>tabclose<cr>", desc = "Close Tab" },
    { "<leader>th", "<cmd>-tabmove<cr>", desc = "Move Left" },
    { "<leader>tl", "<cmd>+tabmove<cr>", desc = "Move Right" },
    { "<leader>tn", "<cmd>tabn<cr>", desc = "Next Tab" },
    { "<leader>to", "<cmd>tabonly<cr>", desc = "Only" },
    { "<leader>tp", "<cmd>tabp<cr>", desc = "Previous Tab" },
    { "<leader>v", "<cmd>vsplit<CR>", desc = "Split" },
    { "<leader>x", group = "Trouble" },
  }

  local which_key = require("which-key")
  local opts = {
    mode = "n", -- NORMAL mode
    prefix = "<leader>",
  }

  which_key.add(mappings, opts)
end

return M
