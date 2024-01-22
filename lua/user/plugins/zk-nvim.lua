return {
  "mickael-menu/zk-nvim",
  event = "VeryLazy",
  config = function()
    local lspconfig = require("user.plugins.lspconfig")
    require("zk").setup({
      -- can be "telescope", "fzf" or "select" (`vim.ui.select`)
      -- it's recommended to use "telescope" or "fzf"
      picker = "fzf",
      lsp = {
        -- `config` is passed to `vim.lsp.start_client(config)`
        config = {
          cmd = { "zk", "lsp" },
          name = "zk",
          capabilities = lspconfig.common_capabilities(),
          on_attach = function(client, bufnr)
            lspconfig.on_attach(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
        },
        -- automatically attach buffers in a zk notebook that match the given filetypes
        auto_attach = {
          enabled = true,
          filetypes = { "markdown" },
        },
      },
    })

    local wk = require("which-key")
    wk.register({
      ["z"] = {
        name = "zk",
        c = { ":ZkNew { title = vim.fn.input('Title: ') }<CR>", "Create a new note after asking for its title" },
        o = { ":ZkNotes { sort = { 'modified' } }<CR>", "Open notes" },
        s = { ":ZkNotes { sort = { 'modified' }, match = vim.fn.input('Search: ') }<CR>", "Search notes" },
        t = { ":ZkTags<CR>", "Open notes associated with the selected tags" },
        b = { ":ZkBacklinks<CR>", "Open notes linking to the current buffer." },
        l = { ":ZkLinks<CR>", "Open notes linked by the current buffer." },
      },
    })
  end,
}
