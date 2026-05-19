#!/usr/bin/env bash
# Pick a random wallpaper and apply it via awww.

set -euo pipefail

WALL_DIR="$HOME/dotfiles/wallpapers"
SETSCRIPT="$HOME/dotfiles/hypr/scripts/set-wallpaper.sh"

wall=$(find "$WALL_DIR" -maxdepth 1 -type f \
    \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' \) \
    | shuf -n 1)

[ -f "$wall" ] || exit 1

ln -sfn "$wall" "$WALL_DIR/current_image"
"$SETSCRIPT" "$wall"
