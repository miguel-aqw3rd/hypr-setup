#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(dirname "$(realpath "$0")")

# ── helpers ──────────────────────────────────────────────────────────────────

info()    { printf '\e[1;34m::\e[0m %s\n' "$*"; }
success() { printf '\e[1;32m✔\e[0m  %s\n' "$*"; }
die()     { printf '\e[1;31m✘\e[0m  %s\n' "$*" >&2; exit 1; }

# ── config deployment ─────────────────────────────────────────────────────────

_deploy_config() {
    local name="$1" src="$2" dest="$3"

    info "Deploying ${name} config..."
    rm -rf "$dest"
    cp -r "$src" "$dest"
    success "${name} config deployed"
}

load_configs() {
    local config_root="${SCRIPT_DIR}/config"

    [[ -d "$config_root" ]] || die "Config directory not found: ${config_root}"

    _deploy_config "hypr"   "${config_root}/hypr"   "${HOME}/.config/hypr"
    _deploy_config "waybar" "${config_root}/waybar" "${HOME}/.config/waybar"
    _deploy_config "rofi"   "${config_root}/rofi"   "${HOME}/.config/rofi"
}

# ── main ──────────────────────────────────────────────────────────────────────

load_configs
