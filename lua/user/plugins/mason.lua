local M = {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
  },
}

function M.config()
  local servers = {
    "lua_ls",
    "cssls",
    "html",
    "bashls",
    "jsonls",
    "yamlls",
    "marksman",
    "pyright",
  }

  require("mason").setup({
    ui = {
      border = "rounded",
    },
  })

  require("mason-lspconfig").setup({
    ensure_installed = servers,
    automatic_installation = {
      exclude = { "rust_analyzer", "tsserver" },
    },
  })

  local wk = require("which-key")
  wk.register({
    ["<leader>lI"] = { "<cmd>Mason<cr>", "Mason Info" },
  })
end

return M
