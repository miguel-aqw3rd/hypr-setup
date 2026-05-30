#!/usr/bin/env bash
set -euo pipefail

pkill -x swaybg 2>/dev/null || true
swaybg -i "$HOME/.local/share/wallpapers/bamboo-forest.jpg" -m fill &
