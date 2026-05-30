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

    if fc-list | grep -qi "JetBrainsMono Nerd Font"; then
        warn "JetBrainsMono Nerd Font already installed — skipping"
        return
    fi

    require curl unzip fc-cache

    local tmp_dir
    tmp_dir=$(mktemp -d)
    trap 'rm -rf "$tmp_dir"' RETURN

    info "Downloading JetBrainsMono Nerd Font..."
    curl -fsSL --progress-bar "$zip_url" -o "${tmp_dir}/JetBrainsMono.zip"

    info "Installing to ${font_dir}..."
    mkdir -p "$font_dir"
    unzip -q "${tmp_dir}/JetBrainsMono.zip" "*.ttf" -d "$font_dir"

    info "Refreshing font cache..."
    fc-cache -f "$font_dir"

    success "JetBrainsMono Nerd Font installed"
}

# ── packages ──────────────────────────────────────────────────────────────────

_install_packages_fedora() {
    local version="$1"
    [[ "$version" == "41" ]] || warn "Untested Fedora version: $version — proceeding anyway"

    info "Installing packages via dnf..."
    sudo dnf install -y \
        hyprland \
        kitty \
        waybar \
        rofi-wayland \
        brightnessctl \
        playerctl \
        nautilus
    success "Packages installed"
}

# _install_packages_arch() { ... }    # TODO
# _install_packages_ubuntu() { ... }  # TODO

install_packages() {
    [[ -f /etc/os-release ]] || die "Cannot detect distro: /etc/os-release not found"
    # shellcheck source=/dev/null
    . /etc/os-release

    case "$ID" in
        fedora) _install_packages_fedora "$VERSION_ID" ;;
        # arch)   _install_packages_arch ;;
        # ubuntu) _install_packages_ubuntu ;;
        *) die "Unsupported distro: $ID" ;;
    esac
}

# ── dotfiles ──────────────────────────────────────────────────────────────────

_deploy_dotfiles_repo() {
    local repo="$1" clone_dir="$2" config_dir="$3"

    info "Cloning $(basename "$config_dir") config..."
    git clone --depth=1 "$repo" "$clone_dir"

    [[ -d "$config_dir" ]] && rm -rf "$config_dir"

    cp -r "$clone_dir" "$config_dir"
    rm -rf "$config_dir/.git"

    success "$(basename "$config_dir") config installed"
}

install_dotfiles() {
    local HYPRLAND_REPO="PLACEHOLDER_HYPRLAND_REPO_URL"
    local WAYBAR_REPO="PLACEHOLDER_WAYBAR_REPO_URL"
    local ROFI_REPO="PLACEHOLDER_ROFI_REPO_URL"

    require git

    local tmp_dir
    tmp_dir=$(mktemp -d)
    trap 'rm -rf "$tmp_dir"' RETURN

    _deploy_dotfiles_repo "$HYPRLAND_REPO" "$tmp_dir/hypr"   "$HOME/.config/hypr"
    _deploy_dotfiles_repo "$WAYBAR_REPO"   "$tmp_dir/waybar" "$HOME/.config/waybar"
    _deploy_dotfiles_repo "$ROFI_REPO"     "$tmp_dir/rofi"   "$HOME/.config/rofi"
}

# ── main ──────────────────────────────────────────────────────────────────────

main() {
    install_packages
    install_jetbrainsmono_nerd_font
    install_dotfiles
}

main "$@"
