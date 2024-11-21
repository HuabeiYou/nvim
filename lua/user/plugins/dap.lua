local M = {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim",
      "mxsdev/nvim-dap-vscode-js",
      "nvim-neotest/nvim-nio",
    },
  },
  keys = {
    {
      "<leader>dt",
      function()
        require("dap").toggle_breakpoint()
      end,
      "Toggle Breakpoint",
    },
    {
      "<leader>db",
      function()
        require("dap").step_back()
      end,
      "Step Back",
    },
    {
      "<leader>dc",
      function()
        require("dap").continue()
      end,
      "Continue",
    },
    {
      "<leader>dC",
      function()
        require("dap").run_to_cursor()
      end,
      "Run To Cursor",
    },
    {
      "<leader>dd",
      function()
        require("dap").disconnect()
      end,
      "Disconnect",
    },
    {
      "<leader>dg",
      function()
        require("dap").session()
      end,
      "Get Session",
    },
    {
      "<leader>di",
      function()
        require("dap").step_into()
      end,
      "Step Into",
    },
    {
      "<leader>do",
      function()
        require("dap").step_over()
      end,
      "Step Over",
    },
    {
      "<leader>du",
      function()
        require("dap").step_out()
      end,
      "Step Out",
    },
    {
      "<leader>dp",
      function()
        require("dap").pause()
      end,
      "Pause",
    },
    {
      "<leader>dr",
      function()
        require("dap").repl.toggle()
      end,
      "Toggle Repl",
    },
    {
      "<leader>ds",
      function()
        require("dap").continue()
      end,
      "Start",
    },
    {
      "<leader>dq",
      function()
        require("dap").close()
      end,
      "Quit",
    },
    {
      "<leader>dU",
      function()
        require("dapui").toggle({ reset = true })
      end,
      "Toggle UI",
    },
  },
}
function M.config()
  local dap, dapui = require("dap"), require("dapui")
  dapui.setup()
  dap.listeners.before.attach.dapui_config = function()
    dapui.open()
  end
  dap.listeners.before.launch.dapui_config = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
  end
  dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
  end
  require("dap-vscode-js").setup({
    debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
    adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
  })

  for _, language in ipairs({ "typescript", "javascript", "svelte" }) do
    require("dap").configurations[language] = {
      -- attach to a node process that has been started with
      -- `--inspect` for longrunning tasks or `--inspect-brk` for short tasks
      -- npm script -> `node --inspect-brk ./node_modules/.bin/vite dev`
      {
        -- use nvim-dap-vscode-js's pwa-node debug adapter
        type = "pwa-node",
        -- attach to an already running node process with --inspect flag
        -- default port: 9222
        request = "attach",
        -- allows us to pick the process using a picker
        processId = require("dap.utils").pick_process,
        -- name of the debug action you have to select for this config
        name = "Attach debugger to existing `node --inspect` process",
        -- for compiled languages like TypeScript or Svelte.js
        sourceMaps = true,
        -- resolve source maps in nested locations while ignoring node_modules
        resolveSourceMapLocations = {
          "${workspaceFolder}/**",
          "!**/node_modules/**",
        },
        -- path to src in vite based projects (and most other projects as well)
        cwd = "${workspaceFolder}/src",
        -- we don't want to debug code inside node_modules, so skip it!
        skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
      },
      {
        type = "pwa-chrome",
        name = "Launch Chrome to debug client",
        request = "launch",
        url = "http://localhost:5173",
        sourceMaps = true,
        protocol = "inspector",
        port = 9222,
        webRoot = "${workspaceFolder}/src",
        -- skip files from vite's hmr
        skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" },
      },
      -- only if language is javascript, offer this debug action
      language == "javascript"
          and {
            -- use nvim-dap-vscode-js's pwa-node debug adapter
            type = "pwa-node",
            -- launch a new process to attach the debugger to
            request = "launch",
            -- name of the debug action you have to select for this config
            name = "Launch file in new node process",
            -- launch current file
            program = "${file}",
            cwd = "${workspaceFolder}",
          }
        or nil,
    }
  end
end

return M
