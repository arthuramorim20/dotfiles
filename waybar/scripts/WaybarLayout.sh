#!/usr/bin/env bash
# Pick a waybar layout via rofi and apply it by swapping the symlink.
# Original: https://github.com/JaKooLit

set -euo pipefail

readonly LAYOUTS_DIR="$HOME/dotfiles/waybar/layouts"
readonly ACTIVE_LINK="$HOME/dotfiles/waybar/config"
readonly ROFI_CONFIG="$HOME/dotfiles/rofi/config.rasi"
readonly RESTART="$HOME/dotfiles/waybar/scripts/wbrestart.sh"

# Avoid stacking rofi windows.
pgrep -x rofi >/dev/null && pkill rofi

choice=$(
    find -L "$LAYOUTS_DIR" -maxdepth 1 -type f -printf '%f\n' \
        | sort \
        | rofi -i -dmenu -config "$ROFI_CONFIG" -mesg ' Choose Waybar Layout '
) || exit 0
[ -n "$choice" ] || exit 0

case "$choice" in
    "no panel") pkill -x waybar 2>/dev/null || true ;;
    *)          ln -sf "$LAYOUTS_DIR/$choice" "$ACTIVE_LINK"
                "$RESTART" & ;;
esac
