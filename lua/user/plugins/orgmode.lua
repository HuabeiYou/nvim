return {
  "nvim-orgmode/orgmode",
  event = "VeryLazy",
  ft = { "org" },
  config = function()
    local orgmode = require("orgmode")
    orgmode.setup({
      org_agenda_files = { "~/org/**/*" },
      org_default_notes_file = "~/org/refile.org",
      org_todo_keywords = { "TODO", "WAITING", "|", "DONE", "DELEGATED" },
      org_todo_keyword_faces = {
        WAITING = ":foreground blue :weight bold",
        DELEGATED = ":background #FFFFFF :slant italic :underline on",
        TODO = ":background #000000 :foreground red", -- overrides builtin color for `TODO` keyword
      },
      org_capture_templates = {
        t = {
          description = "Todo",
          template = "* TODO %?\n %u",
          target = "~/org/todo.org",
        },
        e = {
          description = "Event",
          subtemplates = {
            r = {
              description = "recurring",
              template = "** %?\n %T",
              target = "~/org/calendar.org",
            },
            o = {
              description = "one-time",
              template = "** %?\n %T",
              target = "~/org/calendar.org",
            },
          },
        },
      },
    })
  end,
}
