return {
  "echasnovski/mini.base16",
  version = "*",
  config = function()
    require("mini.base16").setup({
      -- Table with names from `base00` to `base0F` and values being strings of
      -- HEX colors with format "#RRGGBB". NOTE: this should be explicitly
      -- supplied in `setup()`.
      palette = {
        base00 = "#1d2021",
        base01 = "#3c3836",
        base02 = "#504945",
        base03 = "#665c54",
        base04 = "#bdae93",
        base05 = "#d5c4a1",
        base06 = "#ebdbb2",
        base07 = "#fbf1c7",
        base08 = "#fb4934",
        base09 = "#fe8019",
        base0A = "#fabd2f",
        base0B = "#b8bb26",
        base0C = "#8ec07c",
        base0D = "#83a598",
        base0E = "#d3869b",
        base0F = "#d65d0e",
      },

      -- Whether to support cterm colors. Can be boolean, `nil` (same as
      -- `false`), or table with cterm colors. See `setup()` documentation for
      -- more information.
      use_cterm = nil,

      -- Plugin integrations. Use `default = false` to disable all integrations.
      -- Also can be set per plugin (see |MiniBase16.config|).
      plugins = { default = true },
    })
  end,
}
