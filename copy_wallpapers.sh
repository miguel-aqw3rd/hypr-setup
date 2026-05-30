#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(dirname "$(realpath "$0")")

# ── helpers ──────────────────────────────────────────────────────────────────

info()    { printf '\e[1;34m::\e[0m %s\n' "$*"; }
success() { printf '\e[1;32m✔\e[0m  %s\n' "$*"; }
die()     { printf '\e[1;31m✘\e[0m  %s\n' "$*" >&2; exit 1; }

# ── wallpapers ────────────────────────────────────────────────────────────────

copy_wallpapers() {
    local src="${SCRIPT_DIR}/wallpapers"
    local dest="${HOME}/.local/share/wallpapers"

    [[ -d "$src" ]] || die "Wallpapers directory not found: ${src}"

    info "Copying wallpapers..."
    mkdir -p "$dest"
    cp -r "${src}/." "$dest"
    success "Wallpapers copied to ${dest}"
}

# ── main ──────────────────────────────────────────────────────────────────────

copy_wallpapers
