local M = {
  {
    "folke/tokyonight.nvim",
    opts = function()
      return {
        style = "moon",
        -- transparent = true,
        -- styles = {
        --   sidebars = "transparent",
        --   floats = "transparent",
        -- },
        sidebars = {
          "qf",
          "vista_kind",
          "terminal",
          "spectre_panel",
          "startuptime",
          "Outline",
        },
        on_highlights = function(hl, c)
          -- hl.CursorLineNr = { fg = c.orange, bold = true }
          -- hl.LineNr = { fg = c.orange, bold = true }
          -- hl.LineNrAbove = { fg = c.fg_gutter }
          -- hl.LineNrBelow = { fg = c.fg_gutter }
          -- local prompt = "#2d3149"
          -- hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg_dark }
          -- hl.TelescopeBorder = { bg = c.bg_dark, fg = c.bg_dark }
          -- hl.TelescopePromptNormal = { bg = prompt }
          -- hl.TelescopePromptBorder = { bg = prompt, fg = prompt }
          -- hl.TelescopePromptTitle = { bg = c.fg_gutter, fg = c.orange }
          -- hl.TelescopePreviewTitle = { bg = c.bg_dark, fg = c.bg_dark }
          -- hl.TelescopeResultsTitle = { bg = c.bg_dark, fg = c.bg_dark }
        end,
      }
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false, -- disables setting the background color.
        show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
        term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
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
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        color_overrides = {},
        custom_highlights = {},
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = false,
          leap = true,
        },
      })
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    config = function()
      -- Default options:
      require("kanagawa").setup({
        compile = false, -- enable compiling the colorscheme
        undercurl = true, -- enable undercurls
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false, -- do not set background color
        dimInactive = false, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = { -- add/modify theme and palette colors
          palette = {},
          theme = {
            wave = {},
            lotus = {},
            dragon = {},
            all = {
              ui = {
                bg_gutter = "none",
              },
            },
          },
        },
        overrides = function(colors) -- add/modify highlights
          return {}
        end,
        theme = "wave", -- Load "wave" theme when 'background' option is not set
        background = { -- map the value of 'background' option to a theme
          dark = "wave", -- try "dragon" !
          light = "lotus",
        },
      })
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      local p = require("gruvbox").palette
      require("gruvbox").setup({
        inverse = true, -- invert background for search, diffs, statuslines and errors
        contrast = "hard", -- can be "hard", "soft" or empty string
        -- palette_overrides = {
        --   neutral_red = "#fb4934",
        --   neutral_green = "#b8bb26",
        --   neutral_yellow = "#fabd2f",
        --   neutral_blue = "#83a598",
        --   neutral_purple = "#d3869b",
        --   neutral_aqua = "#8ec07c",
        --   neutral_orange = "#fe8019",
        -- },
        overrides = {
          Function = {
            link = "GruvboxYellowBold",
          },
          Macro = {
            link = "GruvboxRed",
          },
          IndentBlanklineContextChar = { link = "Normal" },
          ["@punctuation.bracket"] = { link = "Normal" },
          ["@punctuation.delimiter"] = { link = "Normal" },
          SignColumn = { link = "Normal" },
          GruvboxGreenSign = { bg = "" },
          GruvboxOrangeSign = { bg = "" },
          GruvboxPurpleSign = { bg = "" },
          GruvboxYellowSign = { bg = "" },
          GruvboxRedSign = { bg = "" },
          GruvboxBlueSign = { bg = "" },
          GruvboxAquaSign = { bg = "" },
          TabLine = { bg = p.dark0, fg = p.gray }, -- tab pages line, not active tab page label
          TabLineFill = { bg = p.dark0 }, -- tab pages line, where there are no labels
          TabLineSel = { fg = p.bright_aqua, bg = p.dark2 }, -- tab pages line, active tab page label
        },
        transparent_mode = false,
      })
    end,
  },
}

return M
