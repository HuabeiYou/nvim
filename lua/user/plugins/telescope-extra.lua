local M = {
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      require("project_nvim").setup({
        active = true,
        on_config_done = nil,
        manual_mode = false,
        detection_methods = { "pattern" },
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "pom.xml" },
        ignore_lsp = {},
        exclude_dirs = { ".*/crypto/.*" },
        show_hidden = false,
        silent_chdir = true,
        scope_chdir = "global",
      })
    end,
  },
  {
    "LukasPietzschmann/telescope-tabs",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.register({
        ["<leader>ft"] = {
          "<cmd>lua require('telescope').extensions['telescope-tabs'].list_tabs(require('telescope.themes').get_dropdown{previewer = false, initial_mode='normal', prompt_title='Tabs'})<cr>",
          "Find Tabs",
        },
      })
      require("telescope-tabs").setup({
        show_preview = false,
        close_tab_shortcut_i = "<C-d>", -- if you're in insert mode
        close_tab_shortcut_n = "dd", -- if you're in normal mode
        entry_formatter = function(tab_id, buffer_ids, file_names, file_paths, is_current)
          local entry_string = table.concat(file_names, ", ")
          return string.format("%d: %s%s", tab_id, entry_string, is_current and " " or "")
        end,
      })
    end,
  },
}
return M
