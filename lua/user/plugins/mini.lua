return {
  "echasnovski/mini.nvim",
  version = "*",
  dependencies = {
    {
      "rubiin/fortune.nvim",
      version = "*",
      config = function()
        require("fortune").setup({
          max_width = 40,
          content_type = "quotes",
        })
      end,
    },
  },
  config = function()
    -- require("mini.statusline").setup()
    -- Better Around/Inside textobjects
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote
    require("mini.ai").setup({ n_lines = 500 })

    require("mini.indentscope").setup({
      draw = {
        delay = 100,
        animation = require("mini.indentscope").gen_animation.none(),
        predicate = function(scope)
          return not scope.body.is_incomplete
        end,
      },
      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        -- Textobjects
        object_scope = "ii",
        object_scope_with_border = "ai",

        -- Motions (jump to respective border line; if not present - body line)
        goto_top = "[i",
        goto_bottom = "]i",
      },

      -- Options which control scope computation
      options = {
        -- Type of scope's border: which line(s) with smaller indent to
        -- categorize as border. Can be one of: 'both', 'top', 'bottom', 'none'.
        border = "both",

        -- Whether to use cursor column when computing reference indent.
        -- Useful to see incremental scopes with horizontal cursor movements.
        indent_at_cursor = true,

        -- Whether to first check input line to be a border of adjacent scope.
        -- Use it if you want to place cursor on function header to get scope of
        -- its body.
        try_as_border = false,
      },

      -- Which character to use for drawing scope indicator
      symbol = "▏",
    })

    -- Start up screen
    local new_section = function(name, action, section)
      return { name = name, action = action, section = section }
    end
    local starter = require("mini.starter")
    starter.setup({
      silent = true,
      evaluate_single = true,
      footer = table.concat(require("fortune").get_fortune()),
      header = "",
      items = {
        new_section("Files", "Telescope find_files", "Telescope"),
        new_section("Words", "Telescope live_grep", "Telescope"),
        new_section("Projects", "Telescope projects", "Telescope"),
        new_section("Recent files", "Telescope oldfiles", "Telescope"),
        new_section("New file", "ene | startinsert", "Built-in"),
        new_section("Quit", "qa", "Built-in"),
        new_section("Session restore", [[lua require("persistence").load()]], "Session"),
      },
    })
  end,
}
