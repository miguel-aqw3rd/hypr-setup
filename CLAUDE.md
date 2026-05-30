# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Hyprland desktop environment setup repo. Its purpose is to provide an `install.sh` script that automates installing packages and symlinking config files to their expected locations. The script is currently a work in progress (`.install.sh.swp` swap file exists but `install.sh` has not been committed yet).

## Repo layout in context

This repo lives alongside sibling config repos under `../`:

| Directory     | Purpose                                      |
|---------------|----------------------------------------------|
| `hyperconf/`  | Hyprland compositor config (`hyprland.conf`) |
| `waybarconf/` | Waybar status bar config + CSS               |
| `rofiwconf/`  | Rofi launcher config                         |
| `hypr-setup/` | This repo — installer script                 |

## Stack / programs configured

- **Compositor**: Hyprland (Wayland)
- **Terminal**: kitty
- **Launcher**: rofi (`-show drun`)
- **File manager**: nautilus
- **Status bar**: Waybar (autostarted by Hyprland; reloaded with `pkill -SIGUSR2 waybar` or `SUPER+SHIFT+B`)
- **Audio**: pipewire/wireplumber (`wpctl`)
- **Brightness**: brightnessctl
- **Media keys**: playerctl

## Applying Hyprland config changes

Reload Hyprland in-place:
```bash
hyprctl reload
```

Waybar reload (no restart needed):
```bash
pkill -SIGUSR2 waybar
```

## Keybinds (from hyprland.conf)

`$mainMod` = SUPER

| Binding | Action |
|---------|--------|
| SUPER+Return | Open kitty |
| SUPER+Space | Open rofi |
| SUPER+C | Close window |
| SUPER+V | Toggle floating |
| SUPER+H/L/J/K | Move focus (vi-style) |
| SUPER+1–0 | Switch workspace |
| SUPER+SHIFT+1–0 | Move window to workspace |
| SUPER+SHIFT+B | Reload Waybar |
