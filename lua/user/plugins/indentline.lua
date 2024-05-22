return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {
    indent = {
      char = "▏", -- This is a slightly thinner char than the default one, check :help ibl.config.indent.char
    },
    scope = {
      show_start = false,
      show_end = false,
      highlight = {
        "rainbow2",
        "rainbow3",
        "rainbow4",
        "rainbow5",
        "rainbow6",
      },
    },
  },
}
