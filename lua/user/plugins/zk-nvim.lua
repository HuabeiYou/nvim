return {
  "zk-org/zk-nvim",
  event = "VeryLazy",
  config = function()
    local lspconfig = require("user.plugins.lsp")
    require("zk").setup({
      -- can be "telescope", "fzf" or "select" (`vim.ui.select`)
      -- it's recommended to use "telescope" or "fzf"
      picker = "telescope",
      lsp = {
        -- `config` is passed to `vim.lsp.start_client(config)`
        config = {
          cmd = { "zk", "lsp" },
          name = "zk",
          -- on_attach = ...
          -- etc, see `:h vim.lsp.start_client()`
        },

        -- automatically attach buffers in a zk notebook that match the given filetypes
        auto_attach = {
          enabled = true,
          filetypes = { "markdown" },
        },
      },
    })

    local wk = require("which-key")
    wk.add({
      { "<leader>Za", ":ZkNew { title = vim.fn.input('Title: ') }<CR>", desc = "Create a new note" },
      { "<leader>Zb", ":ZkBacklinks<CR>", desc = "Open notes linking to the current buffer." },
      { "<leader>Zf", ":ZkNotes { sort = { 'modified' }, match = vim.fn.input('Find: ') }<CR>", desc = "Find notes" },
      { "<leader>Zl", ":ZkLinks<CR>", desc = "Open notes linked by the current buffer." },
      { "<leader>Zo", ":ZkNotes { sort = { 'modified' } }<CR>", desc = "Open notes" },
      { "<leader>Zt", ":ZkTags<CR>", desc = "Open notes associated with the selected tags" },
    })
  end,
}
