local M = {
  "is0n/jaq-nvim",
  event = "VeryLazy",
}

function M.config()
  require("jaq-nvim").setup({
    -- Commands used with 'Jaq'
    cmds = {
      -- Uses external commands such as 'g++' and 'cargo'
      external = {
        typescript = "ts-node %",
        javascript = "node %",
        -- markdown = "glow %",
        python = "python %",
        -- rust = "rustc % && ./$fileBase && rm $fileBase",
        rust = "cargo run",
        cpp = "gcc % -o $fileBase && ./$fileBase",
        go = "go run %",
        sh = "sh %",
      },

      -- Uses internal commands such as 'source' and 'luafile'
      internal = {
        lua = "luafile %",
        vim = "source %",
      },
    },

    behavior = {
      -- Default type
      default = "float",

      -- Start in insert mode
      startinsert = false,

      -- Use `wincmd p` on startup
      wincmd = false,

      -- Auto-save files
      autosave = false,
    },

    ui = {
      float = {
        -- See ':h nvim_open_win'
        border = "rounded",

        -- See ':h winhl'
        winhl = "Normal",
        borderhl = "FloatBorder",

        -- See ':h winblend'
        winblend = 0,

        -- Num from `0-1` for measurements
        height = 0.8,
        width = 0.8,
        x = 0.5,
        y = 0.5,

        -- Highlight group for floating window/border (see ':h winhl')
        border_hl = "FloatBorder",
        float_hl = "Normal",

        -- Floating Window Transparency (see ':h winblend')
        blend = 0,
      },

      terminal = {
        -- Window position
        position = "vert",

        -- Window size
        size = 10,

        -- Size of terminal
        line_no = 50,
      },

      quickfix = {
        -- Window position
        position = "bot",

        -- Window size
        size = 30,
      },
    },
  })

  local opts = { noremap = true, silent = true }
  local keymap = vim.api.nvim_set_keymap

  keymap("n", "<m-r>", ":silent only | Jaq<cr>", opts)

  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "Jaq" },
    callback = function()
      vim.cmd([[
      nnoremap <silent> <buffer> <m-r> :close<CR>
      " nnoremap <silent> <buffer> <m-r> <NOP>
      set nobuflisted
    ]])
    end,
  })
end

local a = 1 + 1

return M
