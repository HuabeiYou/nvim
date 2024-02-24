return {
  "danymat/neogen",
  version = "*",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "L3MON4D3/LuaSnip",
  },
  config = function()
    local neogen = require("neogen")

    neogen.setup({
      snippet_engine = "luasnip",
    })

    local wk = require("which-key")
    wk.register({
      n = {
        name = "Generate",
        f = {
          function()
            neogen.generate({ type = "func" })
          end,
          "Func Annotation",
        },
        t = {
          function()
            neogen.generate({ type = "type" })
          end,
          "Type Annotation",
        },
        c = {
          function()
            neogen.generate({ type = "class" })
          end,
          "Class Annotation",
        },
      },
    }, {
      mode = "n",
      prefix = "<leader>",
    })
  end,
}
