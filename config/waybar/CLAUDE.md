# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Waybar configuration for a Hyprland (Wayland compositor) desktop. The bar sits at the top of the screen and is 28px tall.

## Applying changes

Reload Waybar after editing any file:

```bash
killall waybar && waybar &
```

Or send a reload signal:

```bash
pkill -SIGUSR2 waybar
```

## File roles

- `config` — JSON module layout and per-module settings. Controls which modules appear (left/center/right), their format strings, and behavior.
- `style.css` — GTK CSS for visual styling. Currently empty; all styling comes from the Waybar default theme.

## Config structure

The `config` file follows Waybar's JSON schema:

- **Top-level keys**: `layer`, `position`, `height`, `modules-left`, `modules-center`, `modules-right` — define bar placement and module slots.
- **Module config blocks**: keyed by module name (e.g. `"hyprland/workspaces"`, `"clock"`, `"battery"`). Each block is only active if its module name appears in one of the module slots.

Current modules:
- `hyprland/workspaces` (left) — workspace switcher with nerd-font icons per workspace index
- `clock` (center) — HH:MM display, full date on hover
- `network`, `battery`, `tray` (right)

## Nerd Fonts dependency

The workspace `format-icons` use Nerd Font codepoints. The system must have a Nerd Font installed and configured in Waybar's CSS `font-family` for icons to render correctly.
