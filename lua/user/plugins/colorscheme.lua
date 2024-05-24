local M = {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false, -- disables setting the background color.
        show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
        term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
          enabled = false, -- dims the background color of inactive window
          shade = "dark",
          percentage = 0.15, -- percentage of the shade to apply to the inactive window
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        no_underline = false, -- Force no underline
        styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
          comments = { "italic" }, -- Change the style of comments
          conditionals = {},
          loops = {},
          functions = { "bold" },
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = { "bold" },
        },
        color_overrides = {
          mocha = {
            base = "#161616",
            mantle = "#212121",
          },
        },
        custom_highlights = {
          TreesitterContextBottom = { style = { "bold" } },
          ["@keyword.return"] = { link = "Error" },
          ["@keyword.exception"] = { link = "Error" },
          ["@variable.parameter"] = { link = "@variable" },
        },
        integrations = {
          treesitter = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
          },
          cmp = true,
          gitsigns = true,
          fidget = true,
          harpoon = true,
          leap = true,
          -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        },
      })
      -- setup must be called before loading
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  -- {
  --   "folke/tokyonight.nvim",
  --   -- lazy = false, -- make sure we load this during startup if it is your main colorscheme
  --   -- priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     require("tokyonight").setup({
  --       style = "moon",
  --       -- transparent = true,
  --       -- styles = {
  --       --   sidebars = "transparent",
  --       --   floats = "transparent",
  --       -- },
  --       sidebars = {
  --         "qf",
  --         "vista_kind",
  --         "terminal",
  --         "spectre_panel",
  --         "startuptime",
  --         "Outline",
  --       },
  --       on_highlights = function(hl, c)
  --         -- hl.CursorLineNr = { fg = c.orange, bold = true }
  --         -- hl.LineNr = { fg = c.orange, bold = true }
  --         -- hl.LineNrAbove = { fg = c.fg_gutter }
  --         -- hl.LineNrBelow = { fg = c.fg_gutter }
  --         local prompt = "#2d3149"
  --         hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg_dark }
  --         hl.TelescopeBorder = { bg = c.bg_dark, fg = c.bg_dark }
  --         hl.TelescopePromptNormal = { bg = prompt }
  --         hl.TelescopePromptBorder = { bg = prompt, fg = prompt }
  --         hl.TelescopePromptTitle = { bg = c.fg_gutter, fg = c.orange }
  --         hl.TelescopePreviewTitle = { bg = c.bg_dark, fg = c.bg_dark }
  --         hl.TelescopeResultsTitle = { bg = c.bg_dark, fg = c.bg_dark }
  --       end,
  --     })
  --     vim.cmd.colorscheme("tokyonight-night")
  --   end,
  -- },
  -- {
  --   "rebelot/kanagawa.nvim",
  --   -- lazy = false, -- make sure we load this during startup if it is your main colorscheme
  --   -- priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     -- Default options:
  --     require("kanagawa").setup({
  --       compile = false, -- enable compiling the colorscheme
  --       undercurl = true, -- enable undercurls
  --       commentStyle = { italic = true },
  --       functionStyle = {},
  --       keywordStyle = { italic = true },
  --       statementStyle = { bold = true },
  --       typeStyle = {},
  --       transparent = false, -- do not set background color
  --       dimInactive = false, -- dim inactive window `:h hl-NormalNC`
  --       terminalColors = true, -- define vim.g.terminal_color_{0,17}
  --       colors = { -- add/modify theme and palette colors
  --         palette = {},
  --         theme = {
  --           wave = {},
  --           lotus = {},
  --           dragon = {},
  --           all = {
  --             ui = {
  --               bg_gutter = "none",
  --             },
  --           },
  --         },
  --       },
  --       overrides = function(colors) -- add/modify highlights
  --         return {}
  --       end,
  --       theme = "wave", -- Load "wave" theme when 'background' option is not set
  --       background = { -- map the value of 'background' option to a theme
  --         dark = "wave", -- try "dragon" !
  --         light = "lotus",
  --       },
  --     })
  --     -- vim.cmd.colorscheme("kanagawa")
  --   end,
  -- },
}

return M
