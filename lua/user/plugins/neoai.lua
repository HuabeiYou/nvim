local M = {
  "Bryley/neoai.nvim",
  cmd = {
    "NeoAI",
    "NeoAIOpen",
    "NeoAIClose",
    "NeoAIToggle",
    "NeoAIContext",
    "NeoAIContextOpen",
    "NeoAIContextClose",
    "NeoAIInject",
    "NeoAIInjectCode",
    "NeoAIInjectContext",
    "NeoAIInjectContextCode",
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>aw", desc = "rewrite text" },
    { "<leader>ac", desc = "generate comments" },
    { "<leader>ag", desc = "generate git message" },
  },
}

function M.config()
  require("neoai").setup({
    -- Below are the default options, feel free to override what you would like changed
    ui = {
      output_popup_text = "LLM",
      input_popup_text = "Prompt",
      width = 30, -- As percentage eg. 30%
      output_popup_height = 80, -- As percentage eg. 80%
      submit = "<Enter>", -- Key binding to submit the prompt
    },
    models = {
      {
        name = "openai",
        model = "gpt-3.5-turbo",
        params = nil,
      },
    },
    register_output = {
      ["g"] = function(output)
        return output
      end,
      ["c"] = require("neoai.utils").extract_code_snippets,
    },
    inject = {
      cutoff_width = 75,
    },
    prompts = {
      context_prompt = function(context)
        return "Hey, I'd like to provide some context for future "
          .. "messages. Here is the code/text that I want to refer "
          .. "to in our upcoming conversations:\n\n"
          .. context
      end,
    },
    mappings = {
      ["select_up"] = "<C-p>",
      ["select_down"] = "<C-n>",
    },
    open_ai = {
      api_key = {
        env = "OPENAI_API_KEY",
        value = nil,
        get = function()
          return os.getenv("OPENAI_API_KEY") or ""
        end,
      },
    },
    shortcuts = {
      {
        name = "rewrite",
        key = "<leader>aw",
        desc = "fix text with AI",
        use_context = true,
        prompt = [[
                Please rewrite the text to make it more readable, clear,
                concise, and fix any grammatical, punctuation, or spelling
                errors
            ]],
        modes = { "v" },
        strip_function = nil,
      },
      {
        name = "comment",
        key = "<leader>ac",
        desc = "generate comments",
        use_context = true,
        prompt = function()
          return [[
            Please write clear and concise comments that are easy to understand for both
             humans and language servers.
          ]]
        end,
        modes = { "v" },
        strip_function = nil,
      },
      {
        name = "gitcommit",
        key = "<leader>ag",
        desc = "generate git commit message",
        use_context = false,
        prompt = function()
          return [[
                    Using the following git diff generate a consise and
                    clear git commit message, with a short title summary
                    that is 75 characters or less:
                ]] .. vim.fn.system("git diff --cached")
        end,
        modes = { "n" },
        strip_function = nil,
      },
    },
  })
end

return M
