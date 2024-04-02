return {
  "zk-org/zk-nvim",
  event = "VeryLazy",
  config = function()
    local lspconfig = require("user.plugins.lspconfig")
    require("zk").setup({
      -- can be "telescope", "fzf" or "select" (`vim.ui.select`)
      -- it's recommended to use "telescope" or "fzf"
      picker = "telescope",
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
      ["<leader>Za"] = {
        ":ZkNew { title = vim.fn.input('Title: ') }<CR>",
        "Create a new note",
      },
      ["<leader>Zo"] = { ":ZkNotes { sort = { 'modified' } }<CR>", "Open notes" },
      ["<leader>Zf"] = { ":ZkNotes { sort = { 'modified' }, match = vim.fn.input('Find: ') }<CR>", "Find notes" },
      ["<leader>Zt"] = { ":ZkTags<CR>", "Open notes associated with the selected tags" },
      ["<leader>Zb"] = { ":ZkBacklinks<CR>", "Open notes linking to the current buffer." },
      ["<leader>Zl"] = { ":ZkLinks<CR>", "Open notes linked by the current buffer." },
    })
  end,
}
