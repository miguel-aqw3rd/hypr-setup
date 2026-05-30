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
#
# Unlike a full DE (GNOME, Plasma), Hyprland is a bare compositor — it provides
# window management and nothing else. Every piece of a working desktop must be
# installed and wired up explicitly. The packages below cover those gaps:
#
# hyprland              — the Wayland compositor itself
# kitty                 — terminal emulator ($terminal in hyprland.conf)
# waybar                — status bar (autostarted by Hyprland via exec-once)
# rofi-wayland          — application launcher ($menu in hyprland.conf); the
#                         -wayland fork speaks the Wayland protocol directly
#                         instead of going through XWayland
# swaync                — notification daemon; must be running or apps that
#                         emit notifications (Discord, etc.) will freeze waiting
#                         for a D-Bus response that never comes
# pipewire              — audio/video server; replaces PulseAudio and is
#                         required for screen sharing under Wayland
# wireplumber           — session & policy manager for PipeWire; without it
#                         PipeWire has no routing logic and produces no audio
# xdg-desktop-portal-hyprland — Hyprland-specific portal backend; enables
#                         screen capture and sharing in browsers and apps
# xdg-desktop-portal-gtk      — GTK portal backend; provides the file picker
#                         and other portal interfaces not covered by the
#                         Hyprland backend (used by Flatpak sandboxed apps)
# qt5-wayland           — Qt5 Wayland platform plugin; without it Qt5 apps
#                         fall back to XWayland instead of running natively
# qt6-wayland           — same as above for Qt6 apps
# lxqt-policykit        — polkit authentication agent; without a running agent
#                         privilege dialogs (mounting drives, package managers)
#                         silently fail — no password prompt ever appears
# brightnessctl         — controls backlight brightness; required by the
#                         XF86MonBrightness keybindings in hyprland.conf
# playerctl             — media player controller; required by the
#                         XF86Audio* media keybindings in hyprland.conf
# nautilus              — file manager ($fileManager in hyprland.conf)

_install_packages_fedora() {
    local version="$1"
    [[ "$version" == "41" ]] || warn "Untested Fedora version: $version — proceeding anyway"

    info "Installing packages via dnf..."
    sudo dnf install -y \
        hyprland \
        kitty \
        waybar \
        rofi-wayland \
        swaync \
        pipewire \
        wireplumber \
        xdg-desktop-portal-hyprland \
        xdg-desktop-portal-gtk \
        qt5-wayland \
        qt6-wayland \
        lxqt-policykit \
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

    if [[ -d "$config_dir" ]]; then
        warn "$(basename "$config_dir") config already exists — skipping"
        return
    fi

    info "Cloning $(basename "$config_dir") config..."
    git clone --depth=1 "$repo" "$clone_dir"

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
