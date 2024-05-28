return {
  "echasnovski/mini.nvim",
  version = "*",
  dependencies = {
    {
      "rubiin/fortune.nvim",
      version = "*",
      config = function()
        require("fortune").setup({
          max_width = 40,
          content_type = "quotes",
        })
      end,
    },
  },
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote
    require("mini.ai").setup({ n_lines = 500 })

    -- Start up screen
    local new_section = function(name, action, section)
      return { name = name, action = action, section = section }
    end
    local starter = require("mini.starter")
    starter.setup({
      evaluate_single = true,
      footer = table.concat(require("fortune").get_fortune()),
      header = "",
      items = {
        new_section("Find file", "Telescope find_files", "Telescope"),
        new_section("Projects", "Telescope projects", "Telescope"),
        new_section("Recent files", "Telescope oldfiles", "Telescope"),
        new_section("New file", "ene | startinsert", "Built-in"),
        new_section("Quit", "qa", "Built-in"),
        new_section("Session restore", [[lua require("persistence").load()]], "Session"),
      },
    })

    -- local statusline = require("mini.statusline")
    -- statusline.setup()
    -- ---@diagnostic disable-next-line: duplicate-set-field
    -- statusline.section_location = function()
    --   return ""
    -- end

    local base16 = require("mini.base16")
    local base16_shell = function(env_name)
      if os.getenv(env_name) ~= nil then
        return "#" .. os.getenv(env_name)
      end
      return nil
    end
    local function addOneToHexColor(hexColor)
      -- Remove the '#' prefix and convert the hex to a numeric value
      local numericValue = tonumber(hexColor:sub(2), 16)
      -- Increment the numeric value
      numericValue = numericValue + 1
      -- Convert back to hex, ensuring the string is 6 characters long with leading zeros
      local incrementedHex = string.format("#%06x", numericValue)
      return incrementedHex
    end
    local palette = {
      base00 = addOneToHexColor(base16_shell("BASE16_COLOR_00_HEX") or "#1d2021"),
      base01 = base16_shell("BASE16_COLOR_01_HEX") or "#3c3836",
      base02 = base16_shell("BASE16_COLOR_02_HEX") or "#504945",
      base03 = base16_shell("BASE16_COLOR_03_HEX") or "#665c54",
      base04 = base16_shell("BASE16_COLOR_04_HEX") or "#a89984",
      base05 = base16_shell("BASE16_COLOR_05_HEX") or "#d5c4a1",
      base06 = base16_shell("BASE16_COLOR_06_HEX") or "#ebdbb2",
      base07 = base16_shell("BASE16_COLOR_07_HEX") or "#fbf1c7",
      base08 = base16_shell("BASE16_COLOR_08_HEX") or "#fb4934",
      base09 = base16_shell("BASE16_COLOR_09_HEX") or "#fe8019",
      base0A = base16_shell("BASE16_COLOR_0A_HEX") or "#fabd2f",
      base0B = base16_shell("BASE16_COLOR_0B_HEX") or "#b8bb26",
      base0C = base16_shell("BASE16_COLOR_0C_HEX") or "#8ec07c",
      base0D = base16_shell("BASE16_COLOR_0D_HEX") or "#83a598",
      base0E = base16_shell("BASE16_COLOR_0E_HEX") or "#d3869b",
      base0F = base16_shell("BASE16_COLOR_0F_HEX") or "#d65d0e",
    }
    local cterm_palette = base16.rgb_palette_to_cterm_palette(palette)
    base16.setup({
      -- Table with names from `base00` to `base0F` and values being strings of
      -- HEX colors with format "#RRGGBB". NOTE: this should be explicitly
      -- supplied in `setup()`.
      palette = palette,

      -- Whether to support cterm colors. Can be boolean, `nil` (same as
      -- `false`), or table with cterm colors. See `setup()` documentation for
      -- more information.
      use_cterm = cterm_palette,

      -- Plugin integrations. Use `default = false` to disable all integrations.
      -- Also can be set per plugin (see |MiniBase16.config|).
      plugins = { default = true },
    })
    local highlight_both = function(group, args)
      local command
      if args.link ~= nil then
        command = string.format("highlight! link %s %s", group, args.link)
      else
        command = string.format(
          "highlight %s guifg=%s ctermfg=%s guibg=%s ctermbg=%s gui=%s cterm=%s guisp=%s",
          group,
          args.fg and args.fg.gui or "NONE",
          args.fg and args.fg.cterm or "NONE",
          args.bg and args.bg.gui or "NONE",
          args.bg and args.bg.cterm or "NONE",
          args.attr or "NONE",
          args.attr or "NONE",
          args.sp and args.sp.gui or "NONE"
        )
      end
      vim.cmd(command)
    end

    highlight_both("Comment", { fg = { gui = palette.base03, cterm = cterm_palette.base03 }, attr = "italic" })
    highlight_both("Operator", { link = "Boolean" })
    highlight_both("Identifier", { link = "@variable" })
    highlight_both("@variable.parameter", { link = "Type" })
    highlight_both("Function", { fg = { gui = palette.base0D, cterm = cterm_palette.base0D }, attr = "bold" })
    highlight_both("Delimiter", { fg = { gui = palette.base04, cterm = cterm_palette.base04 } })
    highlight_both("Tag", { fg = { gui = palette.base0C, cterm = cterm_palette.base0C } })
    highlight_both(
      "TreesitterContextLineNumberBottom",
      { fg = { gui = palette.base03, cterm = cterm_palette.base03 }, attr = "underline" }
    )
    highlight_both("LineNrAbove", { fg = { gui = palette.base02, cterm = cterm_palette.base02 } })
    highlight_both("CursorLineNr", { fg = { gui = palette.base0A, cterm = cterm_palette.base0A } })
    highlight_both("CursorLineSign", {})
    highlight_both("LineNrBelow", { fg = { gui = palette.base02, cterm = cterm_palette.base02 } })
    highlight_both("SignColumn", { fg = { gui = palette.base06, cterm = cterm_palette.base06 } })
    highlight_both("GitSignsAdd", { fg = { gui = palette.base0B, cterm = cterm_palette.base0B } })
    highlight_both("GitSignsUntracked", { fg = { gui = palette.base0D, cterm = cterm_palette.base0D } })
    highlight_both("GitSignsDelete", { fg = { gui = palette.base08, cterm = cterm_palette.base08 } })
    highlight_both("GitSignsChange", { fg = { gui = palette.base0E, cterm = cterm_palette.base0E } })
    highlight_both("DiagnosticFloatingError", { fg = { gui = palette.base08, cterm = cterm_palette.base08 } })
    highlight_both("DiagnosticFloatingWarn", { fg = { gui = palette.base0E, cterm = cterm_palette.base0E } })
    highlight_both("DiagnosticFloatingOk", { fg = { gui = palette.base0B, cterm = cterm_palette.base0B } })
    highlight_both("DiagnosticFloatingInfo", { fg = { gui = palette.base0C, cterm = cterm_palette.base0C } })
    highlight_both("DiagnosticFloatingHint", { fg = { gui = palette.base0D, cterm = cterm_palette.base0D } })
    highlight_both("TelescopeBorder", { fg = { gui = palette.base05, cterm = cterm_palette.base05 } })
    highlight_both("MiniStatuslineModeNormal", {
      fg = { gui = palette.base00, cterm = cterm_palette.base00 },
      bg = { gui = palette.base04, cterm = cterm_palette.base04 },
      attr = "bold",
    })
    highlight_both("MiniStatuslineModeOther", {
      fg = { gui = palette.base00, cterm = cterm_palette.base00 },
      bg = { gui = palette.base0C, cterm = cterm_palette.base0C },
      attr = "bold",
    })
    highlight_both("TroublePreview", { link = "Selection" })
  end,
}
