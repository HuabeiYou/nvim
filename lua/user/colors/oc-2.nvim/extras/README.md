# oc-2 terminal themes

Terminal-side theme files that match the `oc-2.nvim` Neovim colorscheme so
the 16 ANSI colors in your terminal agree with the ones Neovim assigns to
`:terminal`, shell output, LazyGit, etc.

All files are **generated** from the fully resolved oc-2 palette — the
same ~248 tokens opencode's web UI ships, produced by a Lua port of
[`resolve.ts`][resolve-ts]. Rerun after any theme change:

```sh
nvim --headless --clean -u NONE \
  -c 'set rtp^=~/.config/nvim/lua/user/colors/oc-2.nvim' \
  -l lua/user/colors/oc-2.nvim/scripts/generate-terminal-themes.lua
```

Canonical theme source:
<https://github.com/anomalyco/opencode/blob/dev/packages/ui/src/theme/themes/oc-2.json>

[resolve-ts]: https://github.com/anomalyco/opencode/blob/dev/packages/ui/src/theme/resolve.ts

| File                        | Target                                     |
| --------------------------- | ------------------------------------------ |
| `base16/oc-2-dark.yaml`     | [tinted-theming] (base16 scheme)           |
| `base16/oc-2-light.yaml`    | [tinted-theming] (base16 scheme)           |
| `ghostty/oc-2-dark`         | [Ghostty] theme file                       |
| `ghostty/oc-2-light`        | [Ghostty] theme file                       |
| `kitty/oc-2-dark.conf`      | [Kitty] theme file                         |
| `kitty/oc-2-light.conf`     | [Kitty] theme file                         |

[tinted-theming]: https://github.com/tinted-theming/tinted-shell
[Ghostty]: https://ghostty.org
[Kitty]: https://sw.kovidgoyal.net/kitty/

## Install

Replace `<plugin>` with the absolute path to this plugin, e.g.
`~/.config/nvim/lua/user/colors/oc-2.nvim`.

### Ghostty

Drop the file into Ghostty's theme directory and reference it in your config:

```sh
mkdir -p ~/.config/ghostty/themes
cp <plugin>/extras/ghostty/oc-2-dark ~/.config/ghostty/themes/oc-2-dark
cp <plugin>/extras/ghostty/oc-2-light ~/.config/ghostty/themes/oc-2-light
```

Then in `~/.config/ghostty/config`:

```
theme = oc-2-dark
# or, for auto light/dark switching:
# theme = light:oc-2-light,dark:oc-2-dark
```

Reload with `ctrl+shift+,` or restart Ghostty.

### Kitty

```sh
mkdir -p ~/.config/kitty/themes
cp <plugin>/extras/kitty/oc-2-dark.conf ~/.config/kitty/themes/
cp <plugin>/extras/kitty/oc-2-light.conf ~/.config/kitty/themes/
```

Add to `~/.config/kitty/kitty.conf`:

```
include themes/oc-2-dark.conf
```

Reload with `ctrl+shift+f5` or restart Kitty. You can also switch at
runtime with `kitten themes oc-2-dark` (after placing the files in
`~/.config/kitty/themes`).

### tinted-theming (base16 shell script)

The YAML files follow the [base16 scheme spec][spec] and work with
[`tinted-shell`][tinted-shell] or any base16 template. To use `tinted-shell`:

```sh
# 1. Install tinted-shell (once):
git clone https://github.com/tinted-theming/tinted-shell \
  ~/.config/tinted-theming/tinted-shell

# 2. Drop the schemes where tinted-shell can find them:
mkdir -p ~/.config/tinted-theming/schemes/base16
cp <plugin>/extras/base16/oc-2-dark.yaml \
   ~/.config/tinted-theming/schemes/base16/
cp <plugin>/extras/base16/oc-2-light.yaml \
   ~/.config/tinted-theming/schemes/base16/

# 3. Generate and source the shell script:
~/.config/tinted-theming/tinted-shell/scripts/base16-oc-2-dark.sh
```

If you already use [`tinty`][tinty] as a base16 manager, add the scheme
directory:

```sh
tinty install   # after adding the schemes dir to your tinty config
tinty apply base16-oc-2-dark
```

The first Neovim plugin (`base16.nvim` via `mini.base16`) in this config
also consumed `BASE16_COLOR_*_HEX` env vars emitted by tinted-shell, so the
two stay interchangeable if you roll back.

[spec]: https://github.com/tinted-theming/home/blob/main/styling.md
[tinted-shell]: https://github.com/tinted-theming/tinted-shell
[tinty]: https://github.com/tinted-theming/tinty

## Base16 slot mapping

The yaml palette follows base16's semantic slots so it works with any
existing base16 template (tmux, fzf, bat, delta, etc.) — values come
directly from opencode's resolved `--syntax-*` tokens, so a base16-
aware template will render source code the same way the opencode
desktop editor does.

| slot   | role                             | sourced from                  | dark       | light      |
| ------ | -------------------------------- | ----------------------------- | ---------- | ---------- |
| base00 | default background               | `surface-base`                | `#1C1C1C`  | `#F8F8F8`  |
| base01 | lighter background (statusline)  | `surface-raised-base`         | `#232323`  | `#F3F3F3`  |
| base02 | selection background             | `surface-raised-base-hover`   | `#282828`  | `#EDEDED`  |
| base03 | comments, invisibles             | `syntax-comment`              | `#8f8f8f`  | `#7a7a7a`  |
| base04 | dark foreground (gutter)         | `text-weak`                   | `#707070`  | `#8F8F8F`  |
| base05 | default foreground               | `text-base`                   | `#A0A0A0`  | `#6F6F6F`  |
| base06 | light foreground                 | `text-strong`                 | `#EDEDED`  | `#171717`  |
| base07 | light background                 | hardcoded                     | `#f7f7f7`  | `#000000`  |
| base08 | red / variables / deleted        | error seed                    | `#fc533a`  | `#fc533a`  |
| base09 | orange / numbers & booleans      | `syntax-constant` (cyan)      | `#93e9f6`  | `#007b80`  |
| base0A | yellow / types / classes         | `syntax-type`                 | `#fcd53a`  | `#8a6f00`  |
| base0B | green / strings                  | `syntax-string` (mint)        | `#00ceb9`  | `#00ceb9`  |
| base0C | cyan / constants / escapes       | `syntax-constant`             | `#93e9f6`  | `#007b80`  |
| base0D | blue / functions & methods       | `syntax-primitive`            | `#8cb0ff`  | `#034cff`  |
| base0E | magenta / keywords               | `syntax-keyword`              | `#edb2f1`  | `#a753ae`  |
| base0F | brown / deprecated / accent      | brand primary (orange)        | `#fab283`  | `#ff8c00`  |

Two slots diverge from the plain base16 convention to match the
desktop editor:

- **`base09`** holds the *number / boolean* color, which opencode
  routes through `syntax-constant` (cyan) via its
  `semanticTokenColors.number` mapping. In classic base16 this slot is
  orange; here it is cyan, and `base0C` shares the same cyan value so
  templates that reach for either slot for "numbers" get the same
  desktop-accurate result.
- **`base0F`** holds the brand orange (`syntax-property` /
  `oc-2.json`'s `primary` seed). Opencode has no "brown / deprecated"
  role, so we park the accent here; templates that style deprecated
  tokens with `base0F` will render them in the brand orange, which
  reads as a deliberate highlight rather than a muted tone.
