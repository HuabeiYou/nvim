-- Classic (pre-treesitter) :syntax groups.
--
-- Mirrors the scope -> `--syntax-*` mapping in opencode's Shiki "OpenCode"
-- theme (packages/ui/src/context/marked.tsx). Where a classic Vim group
-- aligns with a tmtheme scope we use the same semantic token; otherwise we
-- pick the closest match.
--
--   comment     -> syntax-comment    (muted gray)
--   string      -> syntax-string     (mint #00ceb9)
--   number/bool -> syntax-constant   (cyan #93e9f6) -- per semanticTokenColors
--   constant    -> syntax-constant   (cyan)
--   keyword     -> syntax-keyword    (pink #edb2f1)
--   type/class  -> syntax-type       (yellow #fcd53a)
--   function    -> syntax-primitive  (soft blue #8cb0ff) -- per semanticTokenColors
--   property    -> syntax-property   (orange #fab283)
--   operator    -> syntax-operator   (muted)
--   punctuation -> syntax-punctuation (muted)

local M = {}

function M.get(c)
  return {
    -- Comments
    Comment = { fg = c["syntax-comment"], italic = true },

    -- Literals
    -- Vim treats `String`, `Character`, `Number`, `Float`, `Boolean` and
    -- `Constant` all as literals. Opencode routes all of those through
    -- `--syntax-constant` via the semantic `number` / `constant` roles,
    -- EXCEPT `String` itself which has a dedicated color.
    String    = { fg = c["syntax-string"] },
    Character = { fg = c["syntax-string"] },
    Number    = { fg = c["syntax-constant"] },
    Float     = { fg = c["syntax-constant"] },
    Boolean   = { fg = c["syntax-constant"] },
    Constant  = { fg = c["syntax-constant"] },

    -- Identifiers
    -- `Function` in opencode is `--syntax-primitive` (soft blue). The
    -- plain `Identifier` keeps the default variable color.
    Identifier = { fg = c["syntax-variable"] },
    Function   = { fg = c["syntax-primitive"] },

    -- Keywords / statements
    Statement   = { fg = c["syntax-keyword"] },
    Conditional = { fg = c["syntax-keyword"] },
    Repeat      = { fg = c["syntax-keyword"] },
    Label       = { fg = c["syntax-keyword"] },
    Operator    = { fg = c["syntax-operator"] },
    Keyword     = { fg = c["syntax-keyword"] },
    Exception   = { fg = c["syntax-critical"] },

    -- Preprocessor / includes -- tmtheme "storage.modifier.import"
    -- explicitly maps to `syntax-primitive` (blue).
    PreProc   = { fg = c["syntax-primitive"] },
    Include   = { fg = c["syntax-primitive"] },
    Define    = { fg = c["syntax-keyword"] },
    Macro     = { fg = c["syntax-primitive"] },
    PreCondit = { fg = c["syntax-keyword"] },

    -- Types (tmtheme `storage.type` -> keyword; `entity.name.type` -> type)
    Type         = { fg = c["syntax-type"] },
    StorageClass = { fg = c["syntax-keyword"] },
    Structure    = { fg = c["syntax-type"] },
    Typedef      = { fg = c["syntax-type"] },

    -- Special
    Special        = { fg = c["syntax-keyword"] },
    SpecialChar    = { fg = c["syntax-keyword"] },
    Tag            = { fg = c["syntax-string"] },   -- entity.name.tag -> string
    Delimiter      = { fg = c["syntax-punctuation"] },
    SpecialComment = { fg = c["syntax-info"], italic = true },
    Debug          = { fg = c["syntax-critical"] },

    -- Underlined / other
    Underlined = { fg = c["syntax-info"], underline = true },
    Bold       = { bold = true },
    Italic     = { italic = true },
    Ignore     = { fg = c.fg_gutter },
    Error      = { fg = c["syntax-critical"] },
    Todo       = { fg = c.bg, bg = c["syntax-warning"], bold = true },
  }
end

return M
