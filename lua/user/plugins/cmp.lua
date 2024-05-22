---@diagnostic disable: missing-fields
local M = {
  "hrsh7th/nvim-cmp",
  lazy = false,
  priority = 100,
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-calc",
    "onsails/lspkind.nvim",
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = "make install_jsregexp",
      dependencies = {
        "rafamadriz/friendly-snippets",
        "molleweide/LuaSnip-snippets.nvim",
      },
    },
    "saadparwaiz1/cmp_luasnip",
  },
}

function M.config()
  local cmp = require("cmp")

  local luasnip = require("luasnip")
  luasnip.filetype_extend("javascript", { "jsdoc" })
  require("luasnip.loaders.from_vscode").lazy_load()

  local lspkind = require("lspkind")
  lspkind.init({})

  cmp.setup({
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" }, -- For luasnip users.
    }, {
      { name = "buffer" },
      { name = "path" },
      { name = "calc" },
    }),
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    mapping = {
      ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-y>"] = cmp.mapping(
        cmp.mapping.confirm({
          behavior = cmp.SelectBehavior.Insert,
          select = true,
        }),
        { "i", "c" }
      ),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      ["<C-k>"] = cmp.mapping(function()
        if not cmp.visible_docs() then
          cmp.open_docs()
        end
        if cmp.visible_docs() then
          cmp.close_docs()
        end
      end, { "i", "c" }),
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
      -- <C-l> will move you to the right of each of the expansion locations.
      -- <C-h> is similar, except moving you backwards.
      ["<C-l>"] = cmp.mapping(function()
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        end
      end, { "i", "s" }),
      ["<C-h>"] = cmp.mapping(function()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        end
      end, { "i", "s" }),
    },
  })

  cmp.setup.filetype({
    "sql",
    "mysql",
  }, {
    sources = cmp.config.sources({
      { name = "vim-dadbod-completion" },
      { name = "buffer" },
    }),
  })
  cmp.setup.filetype({
    "org",
    "markdown",
  }, {
    sources = cmp.config.sources({
      { name = "orgmode" },
      { name = "buffer" },
      { name = "nvim_lsp" },
    }),
  })
end

return M
