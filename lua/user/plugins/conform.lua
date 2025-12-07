return {
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "goimports", "gofmt" },
        sql = { "sqlfmt" },
        mysql = { "sqlfmt" },
        plsql = { "sqlfmt" },
        python = function(bufnr)
          if require("conform").get_formatter_info("ruff_format", bufnr).available then
            return { "ruff_format" }
          else
            return { "isort", "black" }
          end
        end,
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
        rust = { "rustfmt" },
        lisp = { "cljfmt" },
      },
    })
    vim.keymap.set("", "<M-F>", function()
      require("conform").format({ async = false, timeout_ms = 1000 }, function(err)
        if not err then
          local mode = vim.api.nvim_get_mode().mode
          if vim.startswith(string.lower(mode), "v") then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
          end
        end
      end)
    end, { noremap = true, silent = true, desc = "Format code" })
  end,
}
