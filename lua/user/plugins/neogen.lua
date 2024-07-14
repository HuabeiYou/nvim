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
    wk.add({
      { "<leader>n", group = "Generate" },
      {
        "<leader>nc",
        ":lua require('neogen').generate({ type = 'class' })<CR>",
        desc = "Class Annotation",
      },
      {
        "<leader>nf",
        ":lua require('neogen').generate({ type = 'func' })<CR>",
        desc = "Func Annotation",
      },
      {
        "<leader>nt",
        ":lua require('neogen').generate({ type = 'type' })<CR>",
        desc = "Type Annotation",
      },
    }, {
      mode = "n",
      prefix = "<leader>",
    })
  end,
}
