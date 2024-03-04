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

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require("mini.surround").setup()

    require("mini.sessions").setup({
      -- Whether to read latest session if Neovim opened without file arguments
      autoread = false,
      -- Whether to write current session before quitting Neovim
      autowrite = true,
      -- Directory where global sessions are stored (use `''` to disable)
      directory = "~/.vim/sessions", --<"session" subdir of user data directory from |stdpath()|>,
      -- File for local session (use `''` to disable)
      file = "", -- 'Session.vim',
    })

    local starter = require("mini.starter")
    starter.setup({
      -- evaluate_single = true,
      items = {
        starter.sections.sessions(77, true),
        starter.sections.builtin_actions(),
      },
      content_hooks = {
        function(content)
          local blank_content_line = { { type = "empty", string = "" } }
          local section_coords = starter.content_coords(content, "section")
          -- Insert backwards to not affect coordinates
          for i = #section_coords, 1, -1 do
            table.insert(content, section_coords[i].line + 1, blank_content_line)
          end
          return content
        end,
        starter.gen_hook.adding_bullet("» "),
        starter.gen_hook.aligning("center", "center"),
      },
      header = table.concat(require("fortune").get_fortune()),
      footer = "",
    })

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require("mini.statusline")
    statusline.setup()

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we disable the section for
    -- cursor information because line numbers are already enabled
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return ""
    end

    local base16 = require("mini.base16")

    local base16_shell = function(env_name)
      if os.getenv(env_name) ~= nil then
        return "#" .. os.getenv(env_name)
      end
      return nil
    end

    -- fallback to everforest
    local palette = {
      base00 = base16_shell("BASE16_COLOR_00_HEX") or "#1e2326",
      base01 = base16_shell("BASE16_COLOR_01_HEX") or "#2e383c",
      base02 = base16_shell("BASE16_COLOR_02_HEX") or "#414b50",
      base03 = base16_shell("BASE16_COLOR_03_HEX") or "#859289",
      base04 = base16_shell("BASE16_COLOR_04_HEX") or "#9da9a0",
      base05 = base16_shell("BASE16_COLOR_05_HEX") or "#d3c6aa",
      base06 = base16_shell("BASE16_COLOR_06_HEX") or "#e4e1cd",
      base07 = base16_shell("BASE16_COLOR_07_HEX") or "#fdf6e3",
      base08 = base16_shell("BASE16_COLOR_08_HEX") or "#e67e80",
      base09 = base16_shell("BASE16_COLOR_09_HEX") or "#e69875",
      base0A = base16_shell("BASE16_COLOR_0A_HEX") or "#dbbc7f",
      base0B = base16_shell("BASE16_COLOR_0B_HEX") or "#a7c080",
      base0C = base16_shell("BASE16_COLOR_0C_HEX") or "#83C092",
      base0D = base16_shell("BASE16_COLOR_0D_HEX") or "#7fbbb3",
      base0E = base16_shell("BASE16_COLOR_0E_HEX") or "#d699b6",
      base0F = base16_shell("BASE16_COLOR_0F_HEX") or "#d3c6aa",
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

    highlight_both("Identifier", { fg = { gui = palette.base06, cterm = cterm_palette.base06 } })
    highlight_both("LineNrAbove", { fg = { gui = palette.base02, cterm = cterm_palette.base02 } })
    highlight_both("CursorLineNr", { fg = { gui = palette.base06, cterm = cterm_palette.base06 } })
    highlight_both("LineNrBelow", { fg = { gui = palette.base02, cterm = cterm_palette.base02 } })
    highlight_both("SignColumn", { fg = { gui = palette.base06, cterm = cterm_palette.base06 } })
    highlight_both("GitSignsAdd", { fg = { gui = palette.base0B, cterm = cterm_palette.base0B } })
    highlight_both("GitSignsUntracked", { fg = { gui = palette.base0D, cterm = cterm_palette.base0D } })
    highlight_both("GitSignsDelete", { fg = { gui = palette.base08, cterm = cterm_palette.base08 } })
    highlight_both("GitSignsChange", { fg = { gui = palette.base0E, cterm = cterm_palette.base0E } })

    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
  end,
}
