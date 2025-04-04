local M = {
  "nvim-telescope/telescope.nvim",
  lazy = false,
  priority = 1000,
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      lazy = true,
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    -- { "nvim-telescope/telescope-ui-select.nvim" },
  },
}

function M.config()
  -- Telescope live_grep in git root
  -- Function to find the git root directory based on the current buffer's path
  local function find_git_root()
    -- Use the current buffer's path as the starting point for the git search
    local current_file = vim.api.nvim_buf_get_name(0)
    local current_dir
    local cwd = vim.fn.getcwd()
    -- If the buffer is not associated with a file, return nil
    if current_file == "" then
      current_dir = cwd
    else
      -- Extract the directory from the current file's path
      current_dir = vim.fn.fnamemodify(current_file, ":h")
    end

    -- Find the Git root directory from the current file's path
    local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
    if vim.v.shell_error ~= 0 then
      print("Not a git repository. Searching on current working directory")
      return cwd
    end
    return git_root
  end

  -- Custom live_grep function to search in git root
  local function live_grep_git_root()
    local git_root = find_git_root()
    if git_root then
      require("telescope.builtin").live_grep({
        search_dirs = { git_root },
      })
    end
  end
  vim.api.nvim_create_user_command("LiveGrepGitRoot", live_grep_git_root, {})

  local function find_file_git_root()
    local git_root = find_git_root()
    if git_root then
      require("telescope.builtin").find_files({
        search_dirs = { git_root },
      })
    end
  end
  vim.api.nvim_create_user_command("FindFileGitRoot", find_file_git_root, {})

  local wk = require("which-key")
  wk.add({
    -- { "<leader>ff", "<cmd>FindFileGitRoot<cr>", desc = "Find files" },
    -- {
    --   "<leader>ff",
    --   function()
    --     return require("telescope.builtin").git_files({ cwd = vim.fn.expand("%:h") })
    --   end,
    --   desc = "Find git files",
    -- },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>fb", "<cmd>Telescope buffers previewer=false only_cwd=true<cr>", desc = "Find buffers" },
    { "<leader>fc", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
    { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Find keymaps" },
    { "<leader>fl", "<cmd>Telescope resume<cr>", desc = "Last Search" },
    { "<leader>fp", "<cmd>lua require('telescope').extensions.projects.projects()<cr>", desc = "Projects" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent File" },
    { "<leader>fs", "<cmd>Telescope grep_string<cr>", desc = "Find the string under cursor" },
    { "<leader>fw", "<cmd>LiveGrepGitRoot<cr>", desc = "Find Words" },
  })
  wk.add({
    { "<leader>fs", "<cmd>Telescope grep_string<cr>", desc = "Find the visual selection", mode = "v" },
  })

  local icons = require("user.icons")
  local actions = require("telescope.actions")
  local data = assert(vim.fn.stdpath("data")) --[[@as string]]

  local open_with_trouble = require("trouble.sources.telescope").open
  -- Use this to add more results without clearing the trouble list
  local add_to_trouble = require("trouble.sources.telescope").add

  require("telescope").setup({
    defaults = {
      file_ignore_patterns = { "yarn.lock", "package-lock.json", "*.csv" },
      prompt_prefix = icons.ui.Telescope .. " ",
      selection_caret = icons.ui.Forward .. " ",
      entry_prefix = "   ",
      initial_mode = "insert",
      selection_strategy = "reset",
      path_display = { "smart" },
      color_devicons = true,
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
        "--glob=!.git/",
      },

      mappings = {
        i = {
          ["<C-n>"] = actions.move_selection_next,
          ["<C-p>"] = actions.move_selection_previous,
          ["<C-j>"] = actions.cycle_history_next,
          ["<C-k>"] = actions.cycle_history_prev,
          ["<C-t>"] = open_with_trouble,
          ["<C-T>"] = add_to_trouble,
        },
        n = {
          ["<esc>"] = actions.close,
          ["j"] = actions.move_selection_next,
          ["k"] = actions.move_selection_previous,
          ["q"] = actions.close,
          ["<C-t>"] = open_with_trouble,
          ["<C-T>"] = add_to_trouble,
        },
      },
    },
    pickers = {
      help_tags = {
        theme = "ivy",
      },

      live_grep = {
        theme = "ivy",
      },

      grep_string = {
        theme = "ivy",
        initial_mode = "normal",
      },

      find_files = {
        theme = "dropdown",
        previewer = false,
      },

      git_files = {
        theme = "dropdown",
        previewer = false,
      },

      buffers = {
        theme = "dropdown",
        previewer = false,
        initial_mode = "normal",
        mappings = {
          i = {
            ["<C-d>"] = actions.delete_buffer,
          },
          n = {
            ["dd"] = actions.delete_buffer,
          },
        },
      },

      planets = {
        show_pluto = true,
        show_moon = true,
      },

      colorscheme = {
        enable_preview = true,
      },

      lsp_references = {
        theme = "ivy",
        initial_mode = "normal",
      },

      lsp_definitions = {
        theme = "ivy",
        initial_mode = "normal",
      },

      lsp_declarations = {
        theme = "ivy",
        initial_mode = "normal",
      },

      lsp_implementations = {
        theme = "ivy",
        initial_mode = "normal",
      },
    },
    extensions = {
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      },
      history = {
        path = vim.fs.joinpath(data, "telescope_history.sqlite3"),
        limit = 100,
      },
      ["ui-select"] = {
        require("telescope.themes").get_dropdown({}),
      },
    },
  })
  pcall(require("telescope").load_extension, "fzf")
  pcall(require("telescope").load_extension, "smart_history")
  pcall(require("telescope").load_extension, "ui-select")
end

return M
