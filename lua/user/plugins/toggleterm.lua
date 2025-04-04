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
    open_mapping = [[<c-\>]],
    hide_numbers = true, -- hide the number column in toggleterm buffers
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = -15,
    start_in_insert = true,
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    persist_size = false,
    direction = "float",
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
end

return M
