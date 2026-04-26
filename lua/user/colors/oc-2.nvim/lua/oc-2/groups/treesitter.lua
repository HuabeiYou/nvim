-- Treesitter `@` captures + `@lsp.*` semantic tokens.
--
-- Mirrors opencode's Shiki "OpenCode" theme registered in
-- packages/ui/src/context/marked.tsx, which is what the desktop app's
-- code viewer actually uses. Every group here maps to a single
-- `syntax-*` resolved token from resolve.ts so the colors agree
-- byte-for-byte with the web UI.
--
-- Quick role map (dark values shown; light values are the same tokens):
--   syntax-comment     muted gray      (#8f8f8f)
--   syntax-string      mint            (#00ceb9)
--   syntax-constant    cyan            (#93e9f6)   numbers, booleans, constants
--   syntax-primitive   soft blue       (#8cb0ff)   functions, methods, enum members
--   syntax-property    orange          (#fab283)   attributes, properties
--   syntax-type        yellow          (#fcd53a)   classes, namespaces, type refs
--   syntax-keyword     pink            (#edb2f1)   `if`/`return`/`storage`
--   syntax-variable    strong fg       (#ededed)   identifiers, parameters
--   syntax-operator    muted weak fg   (#707070)
--   syntax-punctuation muted weak fg   (#707070)
--   syntax-regexp      text-base       (#a0a0a0)
--   syntax-critical    error-ish       (#f54f36)
--
-- The two notable surprises relative to "typical" nvim themes:
--
--   * `function` / `method` are **blue** (syntax-primitive), not the
--     "primary accent" orange. Opencode treats the function name as a
--     primitive token.
--   * `number` / `boolean` / `constant` are **cyan** (syntax-constant).
--     In many themes these are orange/red; opencode routes them through
--     the constant slot via its `semanticTokenColors.number` mapping.

local M = {}

function M.get(c)
  -- shorthand so the table below is readable
  local t = {
    comment     = c["syntax-comment"],
    string      = c["syntax-string"],
    regexp      = c["syntax-regexp"],
    constant    = c["syntax-constant"],
    primitive   = c["syntax-primitive"],
    property    = c["syntax-property"],
    type        = c["syntax-type"],
    keyword     = c["syntax-keyword"],
    variable    = c["syntax-variable"],
    object      = c["syntax-object"],
    operator    = c["syntax-operator"],
    punctuation = c["syntax-punctuation"],
    success     = c["syntax-success"],
    warning     = c["syntax-warning"],
    critical    = c["syntax-critical"],
    info        = c["syntax-info"],
    diff_add    = c["syntax-diff-add"],
    diff_delete = c["syntax-diff-delete"],
  }

  return {
    -- Comments ----------------------------------------------------------
    ["@comment"]               = { fg = t.comment, italic = true },
    ["@comment.documentation"] = { fg = t.comment, italic = true },
    ["@comment.error"]         = { fg = t.critical, bold = true },
    ["@comment.warning"]       = { fg = t.warning, bold = true },
    ["@comment.todo"]          = { fg = c.bg, bg = t.warning, bold = true },
    ["@comment.note"]          = { fg = c.bg, bg = t.info, bold = true },
    ["@comment.hint"]          = { fg = c.bg, bg = t.keyword, bold = true },

    -- Numeric / boolean literals. Opencode routes these through the
    -- `constant` slot via `semanticTokenColors.number`.
    ["@number"]        = { fg = t.constant },
    ["@number.float"]  = { fg = t.constant },
    ["@boolean"]       = { fg = t.constant, italic = true },

    -- Constants
    ["@constant"]         = { fg = t.constant },
    ["@constant.builtin"] = { fg = t.constant, italic = true },
    ["@constant.macro"]   = { fg = t.primitive },

    -- Strings (tmtheme: scope `string` → syntax-string)
    ["@string"]               = { fg = t.string },
    ["@string.documentation"] = { fg = t.string, italic = true },
    ["@string.regexp"]        = { fg = t.regexp },
    ["@string.escape"]        = { fg = t.keyword },
    ["@string.special"]       = { fg = t.keyword },
    ["@string.special.symbol"] = { fg = t.constant },
    ["@string.special.url"]   = { fg = t.info, underline = true },
    ["@character"]            = { fg = t.string },
    ["@character.special"]    = { fg = t.keyword },

    -- Functions & methods — syntax-primitive (soft blue) per desktop
    ["@function"]             = { fg = t.primitive },
    ["@function.builtin"]     = { fg = t.primitive, italic = true },
    ["@function.call"]        = { fg = t.primitive },
    ["@function.macro"]       = { fg = t.primitive },
    ["@function.method"]      = { fg = t.primitive },
    ["@function.method.call"] = { fg = t.primitive },
    ["@constructor"]          = { fg = t.type },

    -- Variables / identifiers / parameters — strong fg
    ["@variable"]           = { fg = t.variable },
    ["@variable.builtin"]   = { fg = t.constant, italic = true },
    ["@variable.parameter"] = { fg = t.variable },
    ["@variable.parameter.builtin"] = { fg = t.variable, italic = true },
    -- `@variable.member` covers both member access (`obj.foo`) and class
    -- fields. Opencode's tmtheme paints both as `syntax-primitive`
    -- (blue) via `meta.object.member`. The editor you see agrees:
    -- member access reads blue, not orange.
    ["@variable.member"]    = { fg = t.primitive },
    ["@field"]              = { fg = t.primitive },  -- older name for @variable.member

    -- Keywords — pink
    ["@keyword"]             = { fg = t.keyword },
    ["@keyword.coroutine"]   = { fg = t.keyword },
    ["@keyword.function"]    = { fg = t.keyword },
    ["@keyword.operator"]    = { fg = t.keyword },
    -- tmtheme scope "storage.modifier.import" explicitly maps to primitive
    ["@keyword.import"]      = { fg = t.primitive },
    ["@keyword.export"]      = { fg = t.primitive },
    ["@keyword.repeat"]      = { fg = t.keyword },
    ["@keyword.return"]      = { fg = t.keyword },
    ["@keyword.debug"]       = { fg = t.critical },
    ["@keyword.exception"]   = { fg = t.critical },
    ["@keyword.conditional"] = { fg = t.keyword },
    ["@keyword.directive"]   = { fg = t.keyword },
    ["@keyword.storage"]     = { fg = t.keyword },

    -- Types / classes / namespaces — yellow
    ["@type"]             = { fg = t.type },
    ["@type.builtin"]     = { fg = t.type, italic = true },
    ["@type.definition"]  = { fg = t.type },
    ["@type.qualifier"]   = { fg = t.keyword },

    -- Properties / attributes.
    --
    -- Opencode's tmtheme has a split: `meta.property-name` (object
    -- literal keys) and `entity.other.attribute-name` (HTML/JSX attrs,
    -- decorators) are orange, while `meta.object.member` (member
    -- access) is blue. Treesitter's `@property` conflates both cases;
    -- in practice member access is the dominant occurrence, so we
    -- route `@property` to blue to match how the desktop editor
    -- actually reads.
    ["@property"]          = { fg = t.primitive },
    -- Attributes stay orange (HTML/JSX attr, Python/Rust decorators,
    -- which do come through `@attribute`).
    ["@attribute"]         = { fg = t.property },
    ["@attribute.builtin"] = { fg = t.property },

    -- Modules / namespaces — opencode uses `--syntax-type` (yellow) for
    -- `entity.name` and the `namespace` semantic token.
    ["@module"]         = { fg = t.type },
    ["@module.builtin"] = { fg = t.constant, italic = true },
    ["@namespace"]      = { fg = t.type },

    -- Labels / operators / punctuation
    ["@label"]                 = { fg = t.keyword },
    ["@operator"]              = { fg = t.operator },
    ["@punctuation.delimiter"] = { fg = t.punctuation },
    ["@punctuation.bracket"]   = { fg = t.punctuation },
    ["@punctuation.special"]   = { fg = t.keyword },

    -- Tags (HTML/JSX/XML). tmtheme scope `entity.name.tag` -> syntax-string.
    -- HTML/JSX attribute names (`href=`, `class=`) are orange.
    ["@tag"]           = { fg = t.string },
    ["@tag.attribute"] = { fg = t.property },
    ["@tag.delimiter"] = { fg = t.punctuation },
    ["@tag.builtin"]   = { fg = t.string },

    -- Markdown -- follow opencode's dedicated `markdown-*` tokens when
    -- possible; these come from resolve.ts as concrete hex values.
    ["@markup.heading"]        = { fg = c["markdown-heading"], bold = true },
    ["@markup.heading.1"]      = { fg = c["markdown-heading"], bold = true },
    ["@markup.heading.2"]      = { fg = c["markdown-heading"], bold = true },
    ["@markup.heading.3"]      = { fg = c["markdown-heading"], bold = true },
    ["@markup.heading.4"]      = { fg = c["markdown-heading"], bold = true },
    ["@markup.heading.5"]      = { fg = c["markdown-heading"], bold = true },
    ["@markup.heading.6"]      = { fg = c["markdown-heading"], bold = true },
    ["@markup.strong"]         = { fg = c["markdown-strong"], bold = true },
    ["@markup.italic"]         = { fg = c["markdown-emph"], italic = true },
    ["@markup.strikethrough"]  = { fg = c.fg_dark, strikethrough = true },
    ["@markup.underline"]      = { underline = true },
    ["@markup.quote"]          = { fg = c["markdown-block-quote"], italic = true },
    ["@markup.math"]           = { fg = t.constant },
    ["@markup.link"]           = { fg = c["markdown-link"] },
    ["@markup.link.label"]     = { fg = c["markdown-link-text"] },
    ["@markup.link.url"]       = { fg = c["markdown-link"], underline = true },
    ["@markup.raw"]            = { fg = c["markdown-code"] },
    ["@markup.raw.block"]      = { fg = c["markdown-code-block"] },
    ["@markup.list"]           = { fg = c["markdown-list-item"] },
    ["@markup.list.checked"]   = { fg = c["syntax-success"] },
    ["@markup.list.unchecked"] = { fg = c.fg_dark },

    -- Diff (treesitter diff queries)
    ["@diff.plus"]  = { fg = t.diff_add, bg = c["surface-diff-add-weak"] },
    ["@diff.minus"] = { fg = t.diff_delete, bg = c["surface-diff-delete-weak"] },
    ["@diff.delta"] = { fg = c["icon-diff-modified-base"], bg = c["surface-warning-weak"] },

    -- ------------------------------------------------------------------
    -- LSP semantic tokens.
    --
    -- These are authoritative when an LSP server provides them, which
    -- overrides the treesitter captures above. Mapping mirrors
    -- `semanticTokenColors` in opencode's "OpenCode" Shiki theme.
    -- ------------------------------------------------------------------

    ["@lsp.type.comment"]       = { link = "@comment" },
    ["@lsp.type.string"]        = { link = "@string" },
    ["@lsp.type.number"]        = { fg = t.constant },              -- cyan (desktop)
    ["@lsp.type.regexp"]        = { fg = t.regexp },
    ["@lsp.type.operator"]      = { fg = t.operator },
    ["@lsp.type.keyword"]       = { fg = t.keyword },

    -- namespaces/classes/types -> yellow
    ["@lsp.type.namespace"]     = { fg = t.type },
    ["@lsp.type.class"]         = { fg = t.type },
    ["@lsp.type.enum"]          = { fg = t.type },
    ["@lsp.type.interface"]     = { fg = t.type },
    ["@lsp.type.struct"]        = { fg = t.type },
    ["@lsp.type.type"]          = { fg = t.type },
    ["@lsp.type.typeParameter"] = { fg = t.type },

    -- functions/methods/enum members -> soft blue (syntax-primitive)
    ["@lsp.type.function"]      = { fg = t.primitive },
    ["@lsp.type.method"]        = { fg = t.primitive },
    ["@lsp.type.macro"]         = { fg = t.primitive },
    ["@lsp.type.enumMember"]    = { fg = t.primitive },
    ["@lsp.type.event"]         = { fg = t.primitive },

    -- Property / decorator.
    --
    -- Opencode's `semanticTokenColors.property` is orange
    -- (`--syntax-property`), but the desktop editor renders property
    -- access through Shiki tmGrammar (`meta.object.member`) as blue.
    -- Nvim only ever has one mapping active per buffer, so we pick the
    -- one that matches what the user actually sees in the desktop app:
    -- blue for properties, orange only for decorators.
    ["@lsp.type.property"]    = { fg = t.primitive },
    ["@lsp.type.decorator"]   = { fg = t.property },

    -- variables / parameters -> strong fg
    ["@lsp.type.variable"]    = { fg = t.variable },
    ["@lsp.type.parameter"]   = { fg = t.variable },

    -- modifier (const/static/readonly) -- piggyback on keyword slot
    ["@lsp.type.modifier"]    = { fg = t.keyword },

    -- Token modifiers: readonly / const → cyan constant
    ["@lsp.typemod.variable.readonly"]       = { fg = t.constant },
    ["@lsp.typemod.variable.constant"]       = { fg = t.constant },
    ["@lsp.typemod.parameter.readonly"]      = { fg = t.constant },
    ["@lsp.typemod.property.readonly"]       = { fg = t.property },
    ["@lsp.typemod.string.readonly"]         = { link = "@string" },
    ["@lsp.typemod.function.defaultLibrary"] = { fg = t.primitive, italic = true },
    ["@lsp.typemod.method.defaultLibrary"]   = { fg = t.primitive, italic = true },
    ["@lsp.typemod.type.defaultLibrary"]     = { fg = t.type, italic = true },
    ["@lsp.typemod.variable.defaultLibrary"] = { fg = t.constant, italic = true },
    ["@lsp.typemod.parameter.defaultLibrary"] = { fg = t.variable, italic = true },
    ["@lsp.typemod.keyword.async"]           = { link = "@keyword" },

    -- Treesitter semantic flags some servers emit
    ["@lsp.mod.readonly"]   = { fg = t.constant },
    ["@lsp.mod.deprecated"] = { strikethrough = true },
  }
end

return M
