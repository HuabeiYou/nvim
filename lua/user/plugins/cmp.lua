---@diagnostic disable: missing-fields
local M = {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
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
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-calc",
    "hrsh7th/cmp-nvim-lua",
    "onsails/lspkind.nvim",
  },
}

function M.config()
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  luasnip.filetype_extend("javascript", { "jsdoc" })
  require("luasnip.loaders.from_vscode").lazy_load()
  cmp.setup({
    mapping = {
      ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      -- ["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = true }), { "i", "c" }),
      -- Accept ([y]es) the completion.
      --  This will auto-import if your LSP supports it.
      --  This will expand snippets if the LSP sent a snippet.
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
    -- formatting = {
    --   expandable_indicator = true,
    --   -- fields = { "abbr", "kind", "menu" },
    --   format = require("lspkind").cmp_format({
    --     mode = "symbol_text",
    --     maxwidth = 60, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
    --     -- can also be a function to dynamically calculate max width such as
    --     -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
    --     ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
    --     show_labelDetails = true, -- show labelDetails in menu. Disabled by default
    --   }),
    -- },
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "path" },
      { name = "calc" },
    }),
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    view = {
      entries = {
        name = "custom",
        selection_order = "top_down",
      },
      docs = {
        auto_open = false,
      },
    },
    window = {
      completion = {
        border = "rounded",
        -- winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
        -- col_offset = -3,
        side_padding = 0,
        scrollbar = false,
        scrolloff = 8,
      },
      documentation = {
        border = "rounded",
      },
    },
  })
  cmp.setup.filetype({
    "sql",
    "mysql",
  }, {
    sources = cmp.config.sources({
      { name = "vim-dadbod-completion" },
    }, {
      { name = "buffer" },
    }, {
      { name = "nvim_lsp" },
      { name = "luasnip" },
    }),
  })
  -- cmp.setup.filetype({
  --   "org",
  -- }, {
  --   sources = {
  --     { name = "buffer" },
  --     { name = "orgmode" },
  --     { name = "path" },
  --     { name = "calc" },
  --   },
  -- })
  -- cmp.setup.filetype({
  --   "markdown",
  -- }, {
  --   sources = {
  --     { name = "buffer" },
  --     { name = "orgmode" },
  --     { name = "nvim_lsp" },
  --     { name = "path" },
  --     { name = "calc" },
  --   },
  -- })
end

return M
