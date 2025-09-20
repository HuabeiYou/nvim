local M = {
  "ClSlaid/rainbow-delimiters.nvim",
  config = function()
    local rainbow = require("rainbow-delimiters")
    require("rainbow-delimiters.setup").setup({
      strategy = {
        [""] = rainbow.strategy["global"],
        commonlisp = rainbow.strategy["local"],
      },
      query = {
        [""] = "rainbow-delimiters",
        latex = "rainbow-blocks",
      },
      highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
      },
      blacklist = { "c", "cpp" },
    })
  end,
}

return M
