local M = {
  "folke/which-key.nvim",
}

function M.config()
  local mappings = {
    h = { "<cmd>nohlsearch<CR>", "NOHL" },
    [";"] = { "<cmd>ToggleTerm direction=float<CR>", "Terminal" },
    v = { "<cmd>vsplit<CR>", "Split" },
    a = {
      name = "AI",
      a = { "<cmd>NeoAI<CR>", "Toggle Chat Window" },
    },
    b = {
      name = "Buffers",
      d = { "<cmd>bdelete<cr>", "Delete Buffer" },
      l = { "<cmd>Telescope buffers previewer=false only_cwd=true<cr>", "List Buffer" },
      n = { "<cmd>bnext<cr>", "Next Buffer" },
      p = { "<cmd>bprevious<cr>", "Previous Buffer" },
    },
    d = { name = "Debug" },
    f = { name = "Find" },
    g = { name = "Git" },
    l = { name = "LSP" },
    p = { name = "Plugins" },
    P = { "<cmd>lua require('telescope').extensions.projects.projects()<CR>", "Projects" },
    t = {
      name = "Tab",
      a = { "<cmd>$tabnew<cr>", "Add Tab" },
      c = { "<cmd>tabclose<cr>", "Close Tab" },
      o = { "<cmd>tabonly<cr>", "Only" },
      n = { "<cmd>tabn<cr>", "Next Tab" },
      p = { "<cmd>tabp<cr>", "Previous Tab" },
      h = { "<cmd>-tabmove<cr>", "Move Left" },
      l = { "<cmd>+tabmove<cr>", "Move Right" },
    },
    S = { name = "Sessions" },
    T = {
      name = "Test",
      t = { "<cmd>lua require'neotest'.run.run()<cr>", "Test Nearest" },
      f = { "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", "Test File" },
      d = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", "Debug Test" },
      s = { "<cmd>lua require('neotest').run.stop()<cr>", "Test Stop" },
      a = { "<cmd>lua require('neotest').run.attach()<cr>", "Attach Test" },
    },
    Z = { name = "ZK" },
  }

  local which_key = require("which-key")
  which_key.setup({
    plugins = {
      marks = true,
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
    window = {
      border = "rounded",
      position = "bottom",
      padding = { 2, 2, 2, 2 },
    },
    ignore_missing = true,
    show_help = false,
    show_keys = false,
    disable = {
      buftypes = {},
      filetypes = { "TelescopePrompt" },
    },
  })

  local opts = {
    mode = "n", -- NORMAL mode
    prefix = "<leader>",
  }

  which_key.register(mappings, opts)
end

return M
