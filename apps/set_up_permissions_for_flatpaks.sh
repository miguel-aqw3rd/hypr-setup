#!/usr/bin/env bash
set -euo pipefail

# Run this script manually after rebooting and installing apps via
# install_apps_from_flathub.sh.

# ── helpers ──────────────────────────────────────────────────────────────────

info()    { printf '\e[1;34m::\e[0m %s\n' "$*"; }
success() { printf '\e[1;32m✔\e[0m  %s\n' "$*"; }
warn()    { printf '\e[1;33m!\e[0m  %s\n' "$*" >&2; }
die()     { printf '\e[1;31m✘\e[0m  %s\n' "$*" >&2; exit 1; }

# ── permission overrides ──────────────────────────────────────────────────────
#
# One `flatpak override --user` call per app. Flags stack — list as many as
# needed on a single line or split across continuation lines.
#
# Useful flags:
#   --nofilesystem=home          block all access to $HOME
#   --filesystem=xdg-download    allow only ~/Downloads (use after --nofilesystem=home)
#   --filesystem=xdg-music       allow only ~/Music
#   --nosocket=x11               prevent X11/XWayland access
#   --nosocket=wayland           prevent Wayland access
#   --unshare=network            remove network access
#   --reset                      clear all previous overrides for the app
#
# Find what permissions an app currently has:
#   flatpak info --show-permissions <app-id>
#
# Browse app IDs:
#   flatpak list --app --columns=application

_apply_overrides() {
    # flatpak override --user com.discordapp.Discord \
    #     --nofilesystem=home --filesystem=xdg-download

    # flatpak override --user com.spotify.Client \
    #     --nofilesystem=home --filesystem=xdg-music

    :  # remove this line once overrides are added above
}

# ── main ──────────────────────────────────────────────────────────────────────

apply_permissions() {
    command -v flatpak &>/dev/null || die "flatpak not found — run setup_flathub.sh and reboot first"
    info "Applying Flatpak permission overrides..."
    _apply_overrides
    success "Flatpak permissions applied"
}

apply_permissions
