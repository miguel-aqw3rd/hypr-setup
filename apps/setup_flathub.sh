#!/usr/bin/env bash
set -euo pipefail

# ── helpers ──────────────────────────────────────────────────────────────────

info()    { printf '\e[1;34m::\e[0m %s\n' "$*"; }
success() { printf '\e[1;32m✔\e[0m  %s\n' "$*"; }
warn()    { printf '\e[1;33m!\e[0m  %s\n' "$*" >&2; }
die()     { printf '\e[1;31m✘\e[0m  %s\n' "$*" >&2; exit 1; }

# ── distro-specific flatpak installers ───────────────────────────────────────

_setup_flatpak_fedora() {
    info "Flatpak is pre-installed on Fedora — skipping install"
}

_setup_flatpak_ubuntu() {
    info "Installing flatpak via apt..."
    sudo apt install -y flatpak
    success "flatpak installed"
}

_setup_flatpak_debian() {
    info "Installing flatpak via apt..."
    sudo apt install -y flatpak
    success "flatpak installed"
}

_setup_flatpak_pop() {
    info "Flatpak is built-in on Pop!_OS — skipping install"
}

_setup_flatpak_arch() {
    info "Installing flatpak via pacman..."
    sudo pacman -S --noconfirm flatpak
    success "flatpak installed"
}

_setup_flatpak_nixos() {
    local cfg=/etc/nixos/configuration.nix
    [[ -f "$cfg" ]] || die "NixOS configuration not found: ${cfg}"

    if grep -q 'services\.flatpak\.enable' "$cfg"; then
        info "Flatpak already enabled in NixOS config — skipping"
    else
        info "Enabling flatpak in ${cfg}..."
        # Insert before the closing brace of the top-level attribute set
        sudo sed -i '/^}$/i \ \ services.flatpak.enable = true;' "$cfg"
        info "Rebuilding NixOS configuration..."
        sudo nixos-rebuild switch
        success "NixOS rebuilt with flatpak enabled"
    fi
}

_add_flathub_remote() {
    info "Adding Flathub remote..."
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    success "Flathub remote registered"
}

# ── main ──────────────────────────────────────────────────────────────────────

setup_flathub() {
    [[ -f /etc/os-release ]] || die "Cannot detect distro: /etc/os-release not found"
    # shellcheck source=/dev/null
    . /etc/os-release

    case "$ID" in
        fedora) _setup_flatpak_fedora ;;
        ubuntu) _setup_flatpak_ubuntu ;;
        debian) _setup_flatpak_debian ;;
        pop)    _setup_flatpak_pop    ;;
        arch)   _setup_flatpak_arch   ;;
        nixos)  _setup_flatpak_nixos  ;;
        *)
            warn "Unsupported distro for Flatpak setup: ${ID} — skipping"
            return 0
            ;;
    esac

    _add_flathub_remote
    success "Flathub setup complete — reboot required before installing Flatpak apps"
}

setup_flathub
