local M = {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    {
      "hrsh7th/cmp-nvim-lsp",
      event = "InsertEnter",
    },
    {
      "hrsh7th/cmp-buffer",
      event = "InsertEnter",
    },
    {
      "hrsh7th/cmp-path",
      event = "InsertEnter",
    },
    {
      "hrsh7th/cmp-cmdline",
      event = "InsertEnter",
    },
    {
      "saadparwaiz1/cmp_luasnip",
      event = "InsertEnter",
    },
    {
      "L3MON4D3/LuaSnip",
      event = "InsertEnter",
      version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
      -- install jsregexp (optional!).
      build = "make install_jsregexp",
      dependencies = {
        "rafamadriz/friendly-snippets",
        "molleweide/LuaSnip-snippets.nvim",
      },
    },
    {
      "hrsh7th/cmp-nvim-lua",
    },
    {
      "onsails/lspkind.nvim",
    },
  },
}

function M.config()
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  require("luasnip.loaders.from_vscode").lazy_load()

  local check_backspace = function()
    local col = vim.fn.col(".") - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
  end

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
      ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
      ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
      ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      ["<C-e>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      -- Accept currently selected item. If none selected, `select` first item.
      -- Set `select` to `false` to only confirm explicitly selected items.
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expandable() then
          luasnip.expand()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif check_backspace() then
          fallback()
          -- require("neotab").tabout()
        else
          fallback()
          -- require("neotab").tabout()
        end
      end, {
        "i",
        "s",
      }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
    }),
    formatting = {
      expandable_indicator = true,
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 30 })(entry, vim_item)
        local strings = vim.split(kind.kind, "%s", { trimempty = true })
        kind.kind = " " .. (strings[1] or "") .. " "
        kind.menu = "    (" .. (strings[2] or "") .. ")"
        return kind
      end,
    },
    sources = {
      {
        name = "nvim_lsp",
        entry_filter = function(entry, ctx)
          local kind = require("cmp.types.lsp").CompletionItemKind[entry:get_kind()]
          if kind == "Snippet" and ctx.prev_context.filetype == "java" then
            return false
          end

          if ctx.prev_context.filetype == "markdown" then
            return true
          end

          if kind == "Text" then
            return false
          end

          return true
        end,
      },
      { name = "luasnip" },
      { name = "nvim_lua" },
      { name = "buffer" },
      { name = "path" },
      { name = "calc" },
      { name = "treesitter" },
      { name = "orgmode" },
      { name = "crates" },
      { name = "tmux" },
    },
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
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
        border = "single",
        -- winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
        -- col_offset = -3,
        side_padding = 0,
        scrollbar = false,
        scrolloff = 8,
      },
      documentation = {
        border = "single",
      },
    },
  })
end

return M
