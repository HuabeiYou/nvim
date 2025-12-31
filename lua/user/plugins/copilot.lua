return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter", -- Loads the plugin when entering Insert mode
  keys = {
    { "<C-y>", "<cmd>Copilot suggestion accept<cr>", desc = "Accept Copilot Suggestion", mode = { "i" } },
    { "<C-j>", "<cmd>Copilot suggestion next<cr>", desc = "Next Copilot Suggestion", mode = { "i" } },
    { "<C-k>", "<cmd>Copilot suggestion previous<cr>", desc = "Previous Copilot Suggestion", mode = { "i" } },
    { "<C-c>", "<cmd>Copilot suggestion dismiss<cr>", desc = "Dismiss Copilot Suggestion", mode = { "i" } },
  },
  opts = function(_, opts)
    local node_path = os.getenv("HOME")
      .. "/Library/Application Support/fnm/node-versions/v22.21.1/installation/bin/node"
    local copilot_server_path = vim.fn.stdpath("data")
      .. "/mason/packages/copilot-language-server/node_modules/.bin/copilot-language-server"
    return {
      server_opts_overrides = {
        -- cmd = {
        --   node_path,
        --   copilot_server_path,
        --   "--stdio",
        -- },
        settings = {
          telemetry = {
            telemetryLevel = "off",
          },
        },
      },
      logger = {
        file = vim.fn.stdpath("log") .. "/copilot-lua.log",
        file_log_level = vim.log.levels.TRACE,
        print_log_level = vim.log.levels.WARN,
        trace_lsp = "off", -- "off" | "messages" | "verbose"
        trace_lsp_progress = false,
        log_lsp_messages = false,
      },
      copilot_node_command = node_path,
      server = {
        type = "nodejs",
        custom_server_filepath = copilot_server_path,
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 75,
        trigger_on_accept = true,
      },
    }
  end,
}
