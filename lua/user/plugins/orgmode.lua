return {
  "nvim-orgmode/orgmode",
  event = "VeryLazy",
  config = function()
    local orgmode = require("orgmode")
    orgmode.setup({
      org_agenda_files = { "~/org/**/*" },
      org_default_notes_file = "~/org/refile.org",
      org_todo_keywords = { "TODO", "WAITING", "|", "DONE", "DELEGATED" },
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
              headline = "recurring",
            },
            o = {
              description = "one-time",
              template = "** %?\n %T",
              target = "~/org/calendar.org",
              headline = "one-time",
            },
          },
        },
      },
    })
  end,
}
