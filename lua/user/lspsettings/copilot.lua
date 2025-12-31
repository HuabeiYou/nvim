local node_path = os.getenv("HOME") .. "/Library/Application Support/fnm/node-versions/v22.21.1/installation/bin/node"
local copilot_server_path = vim.fn.stdpath("data")
  .. "/mason/packages/copilot-language-server/node_modules/.bin/copilot-language-server"
return {
  cmd = {
    node_path,
    copilot_server_path,
    "--stdio",
  },
  settings = {
    telemetry = {
      telemetryLevel = "off",
    },
  },
}
