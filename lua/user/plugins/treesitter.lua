local M = {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = "all",
        ignore_install = {},
        sync_install = false,
        highlight = {
          enable = true,
          -- disable = { "markdown" },
          additional_vim_regex_highlighting = false,
        },
        auto_install = true,
        modules = {},
        indent = {
          enable = true,
          disable = { "yaml" },
        },
        autopairs = { enable = true },
      })
    end,
  },
  -- {
  --   "nvim-treesitter/nvim-treesitter-textobjects",
  --   config = function()
  --     require("nvim-treesitter.configs").setup({
  --       textobjects = {
  --         select = {
  --           enable = true,
  --           -- Automatically jump forward to textobj, similar to targets.vim
  --           lookahead = true,
  --           keymaps = {
  --             -- You can use the capture groups defined in textobjects.scm
  --             ["af"] = "@function.outer",
  --             ["if"] = "@function.inner",
  --             ["at"] = "@class.outer",
  --             ["it"] = "@class.inner",
  --             ["ac"] = "@call.outer",
  --             ["ic"] = "@call.inner",
  --             ["aa"] = "@parameter.outer",
  --             ["ia"] = "@parameter.inner",
  --             ["al"] = "@loop.outer",
  --             ["il"] = "@loop.inner",
  --             ["ai"] = "@conditional.outer",
  --             ["ii"] = "@conditional.inner",
  --             ["a/"] = "@comment.outer",
  --             ["i/"] = "@comment.inner",
  --             -- ["ab"] = "@block.outer",
  --             -- ["ib"] = "@block.inner",
  --             ["as"] = "@statement.outer",
  --             ["is"] = "@scopename.inner",
  --             ["aA"] = "@attribute.outer",
  --             ["iA"] = "@attribute.inner",
  --             ["aF"] = "@frame.outer",
  --             ["iF"] = "@frame.inner",
  --           },
  --         },
  --       },
  --     })
  --     local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
  --
  --     -- Repeat movement with ; and ,
  --     -- ensure ; goes forward and , goes backward regardless of the last direction
  --     vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
  --     vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
  --   end,
  -- },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
  },
}

return M
