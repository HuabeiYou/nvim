local parsers = {
  "bash",
  "c",
  "cpp",
  "css",
  "diff",
  "go",
  "html",
  "javascript",
  "json",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "rust",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
  "zig",
}

local function should_disable_treesitter(buf)
  local max_filesize = 1024 * 1024 -- 1 MB
  local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
  return ok and stats and stats.size > max_filesize
end

local function start_treesitter(buf)
  if should_disable_treesitter(buf) then
    return
  end

  pcall(vim.treesitter.start, buf)
end

local M = {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        config = function()
          require("nvim-treesitter-textobjects").setup({
            select = {
              lookahead = true,
            },
          })

          local select = require("nvim-treesitter-textobjects.select")
          vim.keymap.set({ "x", "o" }, "aa", function()
            select.select_textobject("@parameter.outer", "textobjects")
          end, { desc = "Select outer parameter" })
          vim.keymap.set({ "x", "o" }, "ia", function()
            select.select_textobject("@parameter.inner", "textobjects")
          end, { desc = "Select inner parameter" })
          vim.keymap.set({ "x", "o" }, "af", function()
            select.select_textobject("@function.outer", "textobjects")
          end, { desc = "Select outer function" })
          vim.keymap.set({ "x", "o" }, "if", function()
            select.select_textobject("@function.inner", "textobjects")
          end, { desc = "Select inner function" })
          vim.keymap.set({ "x", "o" }, "ac", function()
            select.select_textobject("@class.outer", "textobjects")
          end, { desc = "Select outer class" })
          vim.keymap.set({ "x", "o" }, "ic", function()
            select.select_textobject("@class.inner", "textobjects")
          end, { desc = "Select inner class" })
        end,
      },
      {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
          vim.keymap.set("n", "[c", function()
            require("treesitter-context").go_to_context(vim.v.count1)
          end, { silent = true })
        end,
      },
    },
    config = function()
      require("nvim-treesitter").setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter_start", { clear = true }),
        callback = function(args)
          start_treesitter(args.buf)
        end,
      })
    end,
  },
}

return M
