local M = {
  {
    "rebelot/kanagawa.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
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
        transparent = true, -- do not set background color
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
      vim.cmd([[colorscheme kanagawa]])
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    -- lazy = false, -- make sure we load this during startup if it is your main colorscheme
    -- priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("gruvbox").setup({
        inverse = true, -- invert background for search, diffs, statuslines and errors
        contrast = "hard", -- can be "hard", "soft" or empty string
        palette_overrides = {
          neutral_red = "#fb4934",
          neutral_green = "#b8bb26",
          neutral_yellow = "#fabd2f",
          neutral_blue = "#83a598",
          neutral_purple = "#d3869b",
          neutral_aqua = "#8ec07c",
          neutral_orange = "#fe8019",
        },
        overrides = {
          Function = {
            link = "GruvboxYellowBold",
          },
          Macro = {
            link = "GruvboxRed",
          },
          IndentBlanklineContextChar = { link = "Normal" },
          ["@variable.builtin"] = { link = "GruvboxPurple" },
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
        },
        transparent_mode = true,
      })
      -- vim.cmd([[colorscheme gruvbox]])
    end,
  },
  {
    "folke/tokyonight.nvim",
    config = function()
      require("tokyonight").setup({
        style = "moon",
        transparent = true,
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
        sidebars = {
          "qf",
          "vista_kind",
          "terminal",
          "spectre_panel",
          "startuptime",
          "Outline",
        },
        on_colors = function(c)
          -- local hsluv = require("tokyonight.hsluv")
          -- local function randomColor(color)
          --   if color ~= "NONE" then
          --     local hsl = hsluv.hex_to_hsluv(color)
          --     hsl[1] = math.random(0, 360)
          --     return hsluv.hsluv_to_hex(hsl)
          --   end
          --   return color
          -- end
          -- local function set(colors)
          --   if type(colors) == "table" then
          --     for k, v in pairs(colors) do
          --       if type(v) == "string" then
          --         colors[k] = randomColor(v)
          --       elseif type(v) == "table" then
          --         set(v)
          --       end
          --     end
          --   end
          -- end
          -- set(c)
        end,
        on_highlights = function(hl, c)
          hl.CursorLineNr = { fg = c.orange, bold = true }
          -- hl.LineNr = { fg = c.orange, bold = true }
          hl.LineNrAbove = { fg = c.fg_gutter }
          hl.LineNrBelow = { fg = c.fg_gutter }
          local prompt = "#2d3149"
          hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg_dark }
          hl.TelescopeBorder = { bg = c.bg_dark, fg = c.bg_dark }
          hl.TelescopePromptNormal = { bg = prompt }
          hl.TelescopePromptBorder = { bg = prompt, fg = prompt }
          hl.TelescopePromptTitle = { bg = c.fg_gutter, fg = c.orange }
          hl.TelescopePreviewTitle = { bg = c.bg_dark, fg = c.bg_dark }
          hl.TelescopeResultsTitle = { bg = c.bg_dark, fg = c.bg_dark }
        end,
      })
    end,
  },
  {
    "LunarVim/darkplus.nvim",
  },
}

return M
