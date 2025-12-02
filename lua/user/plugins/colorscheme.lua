local M = {
  -- {
  --   "Mofiqul/vscode.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     local c = require("vscode.colors").get_colors()
  --     require("vscode").setup({
  --       transparent = false,
  --       -- Override colors (see ./lua/vscode/colors.lua)
  --       color_overrides = {},
  --
  --       -- Override highlight groups (see ./lua/vscode/theme.lua)
  --       group_overrides = {
  --         -- this supports the same val table as vim.api.nvim_set_hl
  --         -- use colors from this colorscheme by requiring vscode.colors!
  --         MiniIndentscopeSymbol = { link = "@variable" },
  --         MiniStarterSection = { link = "@keyword" },
  --         MiniStarterItemPrefix = { link = "Error" },
  --         MiniStarterFooter = { link = "Comment" },
  --         NormalFloat = { bg = c.vscContext },
  --         -- StatusLineNC = { bg = c.vscContext },
  --         Pmenu = { bg = c.vscContext, fg = c.vscPopupFront },
  --       },
  --     })
  --     vim.cmd.colorscheme("vscode")
  --   end,
  -- },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        contrast = "hard",
        dim_inactive = false,
        transparent_mode = false,
        bold = false,
        palette_overrides = {
          -- bright_green = "#a9bb26",
        },
        overrides = {
          Function = { link = "GruvboxAqua" },
          Delimiter = { link = "GruvboxFg2" },
          SignColumn = { link = "GruvboxFg0" },
          DiagnosticSignError = { link = "GruvboxRed" },
          DiagnosticSignWarn = { link = "GruvboxYellow" },
          DiagnosticSignOk = { link = "GruvboxGreen" },
          DiagnosticSignInfo = { link = "GruvboxBlue" },
          DiagnosticSignHint = { link = "GruvboxAqua" },
          MiniStarterItemBullet = { link = "GruvboxBlue" },
          MiniStarterSection = { link = "GruvboxBlue" },
        },
      })
      vim.cmd.colorscheme("gruvbox")
    end,
  },
  -- {
  --   "sainnhe/sonokai",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.api.nvim_create_autocmd("ColorScheme", {
  --       group = vim.api.nvim_create_augroup("custom_highlights_sonokai", {}),
  --       pattern = "sonokai",
  --       callback = function()
  --         local config = vim.fn["sonokai#get_configuration"]()
  --         local palette = vim.fn["sonokai#get_palette"](config.style, config.colors_override)
  --         local set_hl = vim.fn["sonokai#highlight"]
  --         set_hl("TodoBgWARN", palette.none, palette.orange)
  --         set_hl("TodoFgWARN", palette.orange, palette.none)
  --         set_hl("TodoBgTODO", palette.none, palette.blue)
  --         set_hl("TodoFgTODO", palette.blue, palette.none)
  --         set_hl("TodoBgNOTE", palette.none, palette.green)
  --         set_hl("TodoFgNOTE", palette.green, palette.none)
  --         set_hl("TodoBgFIX", palette.none, palette.red)
  --         set_hl("TodoFgFIX", palette.red, palette.none)
  --       end,
  --     })
  --     vim.cmd.colorscheme("sonokai")
  --   end,
  -- },
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   config = function()
  --     require("catppuccin").setup({
  --       flavour = "mocha", -- latte, frappe, macchiato, mocha
  --       background = { -- :h background
  --         light = "latte",
  --         dark = "mocha",
  --       },
  --       transparent_background = false, -- disables setting the background color.
  --       show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
  --       term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
  --       dim_inactive = {
  --         enabled = false, -- dims the background color of inactive window
  --         shade = "dark",
  --         percentage = 0.15, -- percentage of the shade to apply to the inactive window
  --       },
  --       no_italic = false, -- Force no italic
  --       no_bold = false, -- Force no bold
  --       no_underline = false, -- Force no underline
  --       styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
  --         comments = { "italic" }, -- Change the style of comments
  --         conditionals = {},
  --         loops = {},
  --         functions = { "bold" },
  --         keywords = {},
  --         strings = {},
  --         variables = {},
  --         numbers = {},
  --         booleans = {},
  --         properties = {},
  --         types = {},
  --         operators = { "bold" },
  --       },
  --       custom_highlights = {
  --         ["@keyword.return"] = { link = "Error" },
  --         ["@keyword.exception"] = { link = "Error" },
  --         -- ["@variable.parameter"] = { link = "@variable" },
  --         -- ["@variable.builtin"] = { link = "Constant" },
  --       },
  --       integrations = {
  --         treesitter = true,
  --         native_lsp = {
  --           enabled = true,
  --           virtual_text = {
  --             errors = { "italic" },
  --             hints = { "italic" },
  --             warnings = { "italic" },
  --             information = { "italic" },
  --           },
  --           underlines = {
  --             errors = { "underline" },
  --             hints = { "underline" },
  --             warnings = { "underline" },
  --             information = { "underline" },
  --           },
  --         },
  --         cmp = true,
  --         gitsigns = true,
  --         fidget = true,
  --         harpoon = true,
  --         leap = true,
  --         -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
  --       },
  --     })
  --     vim.cmd.colorscheme("catppuccin")
  --   end,
  -- },
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false, -- make sure we load this during startup if it is your main colorscheme
  --   priority = 1000, -- make sure to load this before all the other start plugins
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
  --       on_colors = function(colors)
  --         colors.black = "#16161e"
  --         colors.bg = colors.black
  --       end,
  --       on_highlights = function(hl, c)
  --         -- hl.CursorLineNr = { fg = c.orange, bold = true }
  --         -- hl.LineNr = { fg = c.orange, bold = true }
  --         -- hl.LineNrAbove = { fg = c.fg_gutter }
  --         -- hl.LineNrBelow = { fg = c.fg_gutter }
  --         -- local prompt = "#2d3149"
  --         -- hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg_dark }
  --         -- hl.TelescopeBorder = { bg = c.bg_dark, fg = c.bg_dark }
  --         -- hl.TelescopePromptNormal = { bg = prompt }
  --         -- hl.TelescopePromptBorder = { bg = prompt, fg = prompt }
  --         -- hl.TelescopePromptTitle = { bg = c.fg_gutter, fg = c.orange }
  --         -- hl.TelescopePreviewTitle = { bg = c.bg_dark, fg = c.bg_dark }
  --         -- hl.TelescopeResultsTitle = { bg = c.bg_dark, fg = c.bg_dark }
  --       end,
  --     })
  --     vim.cmd.colorscheme("tokyonight")
  --   end,
  -- },
  -- {
  --   "rebelot/kanagawa.nvim",
  --   lazy = false, -- make sure we load this during startup if it is your main colorscheme
  --   priority = 1000, -- make sure to load this before all the other start plugins
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
  --         theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
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
  --
  --     -- setup must be called before loading
  --     vim.cmd("colorscheme kanagawa")
  --   end,
  -- },
}

return M
