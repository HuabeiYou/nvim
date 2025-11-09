local M = {
  "akinsho/toggleterm.nvim",
  version = "*",
  event = "VeryLazy",
}
function M.config()
  require("toggleterm").setup({
    size = function(term)
      if term.direction == "horizontal" then
        return 25
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = [[<C-`>]],
    hide_numbers = true, -- hide the number column in toggleterm buffers
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = -15,
    start_in_insert = true,
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    persist_size = false,
    direction = "horizontal",
    close_on_exit = true, -- close the terminal window when the process exits
    shell = vim.o.shell,
    float_opts = {
      border = "curved",
      winblend = 3,
    },
    winbar = {
      enabled = true,
      name_formatter = function(term) --  term: Terminal
        return term.name
      end,
    },
  })

  local opts = { noremap = true, silent = true }

  local lazygit = require("toggleterm.terminal").Terminal:new({
    cmd = "lazygit",
    dir = "git_dir",
    direction = "float",
    -- function to run on opening the terminal
    on_open = function(term)
      vim.cmd("startinsert!")
      vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", opts)
    end,
    -- function to run on closing the terminal
    on_close = function(term)
      vim.cmd("startinsert!")
    end,
  })

  function _lazygit_toggle()
    lazygit:toggle()
  end

  vim.api.nvim_set_keymap("n", "<leader>gg", "<cmd>lua _lazygit_toggle()<CR>", opts)
end

return M
