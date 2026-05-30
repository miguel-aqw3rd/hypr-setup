#!/usr/bin/env bash
set -euo pipefail

# Run this script manually after rebooting following setup_flathub.sh.

# ── helpers ──────────────────────────────────────────────────────────────────

info()    { printf '\e[1;34m::\e[0m %s\n' "$*"; }
success() { printf '\e[1;32m✔\e[0m  %s\n' "$*"; }
warn()    { printf '\e[1;33m!\e[0m  %s\n' "$*" >&2; }
die()     { printf '\e[1;31m✘\e[0m  %s\n' "$*" >&2; exit 1; }

# ── app list ──────────────────────────────────────────────────────────────────
#
# Add Flatpak application IDs below, one per line.
# Find IDs at https://flathub.org or with: flatpak search <name>
#
# Example:
#   com.spotify.Client        # Spotify
#   com.discordapp.Discord    # Discord
#   org.videolan.VLC          # VLC

FLATPAK_APPS=(
    com.discordapp.Discord
    com.brave.Browser
    # non official client (community package)
    com.valvesoftware.Steam
    # non official client (community package)
    com.spotify.Client
)

# ── install ───────────────────────────────────────────────────────────────────

install_flatpak_apps() {
    command -v flatpak &>/dev/null || die "flatpak not found — run setup_flathub.sh and reboot first"

    if [[ ${#FLATPAK_APPS[@]} -eq 0 ]]; then
        warn "No apps defined — edit FLATPAK_APPS in this script"
        return 0
    fi

    info "Installing Flatpak apps from Flathub..."
    local failed=0
    for app in "${FLATPAK_APPS[@]}"; do
        if flatpak install -y flathub "$app"; then
            success "${app} installed"
        else
            warn "${app} failed — skipping"
            (( failed++ )) || true
        fi
    done
    [[ $failed -eq 0 ]] && success "All Flatpak apps installed" || warn "${failed} app(s) failed to install"
}

install_flatpak_apps
