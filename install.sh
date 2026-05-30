#!/usr/bin/env bash
set -euo pipefail

# ── helpers ──────────────────────────────────────────────────────────────────

info()    { printf '\e[1;34m::\e[0m %s\n' "$*"; }
success() { printf '\e[1;32m✔\e[0m  %s\n' "$*"; }
warn()    { printf '\e[1;33m!\e[0m  %s\n' "$*" >&2; }
die()     { printf '\e[1;31m✘\e[0m  %s\n' "$*" >&2; exit 1; }

require() {
    for cmd in "$@"; do
        command -v "$cmd" &>/dev/null || die "Required command not found: $cmd"
    done
}

# ── fonts ─────────────────────────────────────────────────────────────────────

install_jetbrainsmono_nerd_font() {
    local font_dir="${HOME}/.local/share/fonts/JetBrainsMonoNF"
    local zip_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    local tmp_dir
    tmp_dir=$(mktemp -d)

    require curl unzip fc-cache

    if fc-list | grep -qi "JetBrainsMono Nerd Font"; then
        warn "JetBrainsMono Nerd Font already installed — skipping"
        rm -rf "$tmp_dir"
        return
    fi

    info "Downloading JetBrainsMono Nerd Font..."
    curl -fsSL --progress-bar "$zip_url" -o "${tmp_dir}/JetBrainsMono.zip"

    info "Installing to ${font_dir}..."
    mkdir -p "$font_dir"
    unzip -q "${tmp_dir}/JetBrainsMono.zip" "*.ttf" -d "$font_dir"

    info "Refreshing font cache..."
    fc-cache -f "$font_dir"

    rm -rf "$tmp_dir"
    success "JetBrainsMono Nerd Font installed"
}

# ── main ──────────────────────────────────────────────────────────────────────

main() {
    install_jetbrainsmono_nerd_font
}

main "$@"
