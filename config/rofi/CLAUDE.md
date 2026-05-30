# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Rofi configuration for a Hyprland (Wayland) desktop setup. Uses `.rasi` (Rofi Advanced Style Information) — a CSS-like syntax.

## Testing changes

Apply and preview the theme live:

```bash
rofi -show drun -theme themes/mytheme.rasi
```

Apply the full config (theme + behaviour):

```bash
rofi -show drun -config config.rasi -theme themes/mytheme.rasi
```

Dump the current active theme to inspect defaults:

```bash
rofi -dump-theme
```

Validate a `.rasi` file for syntax errors (rofi exits non-zero on bad syntax):

```bash
rofi -config config.rasi -theme themes/mytheme.rasi -show drun -no-show
```

## Architecture

| File | Purpose |
|------|---------|
| `config.rasi` | Behavioural settings (modes, keybindings, filebrowser, timeout). All options are commented out to document defaults; only `timeout` and `filebrowser` blocks are active. |
| `themes/mytheme.rasi` | Visual theme — generated via `rofi -dump-theme` and customised. Uses the **Solarized Light** palette. |

**Colour palette** (`themes/mytheme.rasi` `*` block):

- `background`: `rgba(253, 246, 227)` — Solarized base3
- `foreground`: `rgba(0, 43, 54)` — Solarized base03
- `lightbg`: `rgba(238, 232, 213)` — Solarized base2
- `lightfg`: `rgba(88, 104, 117)` — Solarized base01
- `blue`: `rgba(38, 139, 210)` — Solarized blue (active/selected-active)
- `red`: `rgba(220, 50, 47)` — Solarized red (urgent)

Element states follow the rofi model: `normal | urgent | active` × `normal | selected | alternate`.

## `.rasi` syntax notes

- `var(name)` references a variable defined in the `*` (global) block.
- Dimensions accept CSS-like units: `px`, `em`, or bare numbers (pixels).
- `background-color: transparent` inherits from the parent widget.
- Comments use `/* ... */` (C-style); `//` is not valid.
