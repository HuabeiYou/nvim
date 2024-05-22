local M = {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "folke/neodev.nvim",
    "b0o/schemastore.nvim",
    { "j-hui/fidget.nvim", opts = {} },
    {
      "stevearc/conform.nvim",
      config = function()
        require("conform").setup({
          formatters_by_ft = {
            lua = { "stylua" },
            go = { "goimports", "gofmt" },
            python = { "isort", "black" },
            sh = { "shfmt" },
            bash = { "shfmt" },
            zsh = { "shfmt" },
            html = { "prettierd" },
            css = { "prettierd" },
            javascript = { "prettierd" },
            typescript = { "prettierd" },
            typescriptreact = { "prettierd" },
            javascriptreact = { "prettierd" },
            handlebars = { "prettierd" },
          },
        })
      end,
    },
  },
}

function M.common_capabilities()
  local cmp_lsp = require("cmp_nvim_lsp")
  local capabilities =
    vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())
  return capabilities
end

function M.config()
  require("mason").setup({})
  require("mason-lspconfig").setup({
    ensure_installed = {
      "lua_ls",
      "cssls",
      "clangd",
      "html",
      "bashls",
      "lemminx",
      "jsonls",
      "yamlls",
      "marksman",
      "gopls",
      "pyright",
      "tsserver",
    },
    automatic_installation = {
      exclude = { "rust_analyzer" },
    },
    handlers = {
      function(server_name) -- default handler (optional)
        local opt = {
          capabilities = M.common_capabilities(),
        }
        local require_ok, settings = pcall(require, "user.lspsettings." .. server_name)
        if require_ok then
          opt = vim.tbl_deep_extend("force", opt, settings)
        end

        if server_name == "lua_ls" then
          require("neodev").setup({})
        end

        require("lspconfig")[server_name].setup(opt)
      end,
    },
  })
  vim.keymap.set("n", "gl", vim.diagnostic.open_float)
  vim.keymap.set("n", "[d", function()
    vim.diagnostic.goto_prev()
    vim.cmd("normal! zz")
  end)
  vim.keymap.set("n", "]d", function()
    vim.diagnostic.goto_next()
    vim.cmd("normal! zz")
  end)
  vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

  -- Use LspAttach autocommand to only map the following keys
  -- after the language server attaches to the current buffer
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
    callback = function(ev)
      -- Enable completion triggered by <c-x><c-o>
      vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

      -- Buffer local mappings.
      local map = function(mode, keys, func, desc)
        vim.keymap.set(mode, keys, func, {
          buffer = ev.buf,
          noremap = true,
          silent = true,
          desc = "LSP: " .. desc,
        })
      end
      -- Jump to the definition of the word under your cursor.
      --  This is where a variable was first declared, or where a function is defined, etc.
      --  To jump back, press <C-T>.
      map("n", "gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

      -- Find references for the word under your cursor.
      map("n", "gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

      -- Jump to the implementation of the word under your cursor.
      --  Useful when your language has ways of declaring types without an actual implementation.
      map("n", "gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

      -- Jump to the type of the word under your cursor.
      --  Useful when you're not sure what type a variable is and you want to see
      --  the definition of its *type*, not where it was *defined*.
      map("n", "<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

      -- Fuzzy find all the symbols in your current document.
      --  Symbols are things like variables, functions, types, etc.
      map("n", "<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

      -- Fuzzy find all the symbols in your current workspace
      --  Similar to document symbols, except searches over your whole project.
      map("n", "<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
      map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd")
      map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove")
      map("n", "<leader>wl", vim.lsp.buf.list_workspace_folders, "[W]orkspace [L]ist")

      -- Rename the variable under your cursor
      --  Most Language Servers support renaming across files, etc.
      map("n", "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

      -- Execute a code action, usually your cursor needs to be on top of an error
      -- or a suggestion from your LSP for this to activate.
      map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

      -- Opens a popup that displays documentation about the word under your cursor
      --  See `:help K` for why this keymap
      map("n", "K", vim.lsp.buf.hover, "Hover Documentation")

      -- WARN: This is not Goto Definition, this is Goto Declaration.
      --  For example, in C this would take you to the header
      map("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

      -- Shift + Alt + f, same as VSCode
      map("n", "<M-F>", function()
        require("conform").format({
          async = false, -- If the buffer is modified before the formatter completes, the formatting will be discarded.
          timeout_ms = 1000,
          lsp_fallback = true,
          bufnr = ev.buf,
        })
      end, "Format")

      -- The following two autocommands are used to highlight references of the
      -- word under your cursor when your cursor rests there for a little while.
      --    See `:help CursorHold` for information about when this is executed
      --
      -- When you move your cursor, the highlights will be cleared (the second autocommand).
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if client and client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = ev.buf,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = ev.buf,
          callback = vim.lsp.buf.clear_references,
        })
      end
    end,
  })

  local icons = require("user.icons")
  local diagnostic_sign_values = {
    { name = "DiagnosticSignError", text = icons.diagnostics.Error },
    { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
    { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
    { name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
  }
  vim.diagnostic.config({
    signs = {
      active = true,
      values = diagnostic_sign_values,
    },
    virtual_text = false,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      source = "if_many",
      border = "rounded",
      header = "",
      prefix = "",
    },
  })

  for _, sign in ipairs(diagnostic_sign_values) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
  require("lspconfig.ui.windows").default_options.border = "rounded"
end

return M
