#!/usr/bin/env bash
# Pick a waybar style (CSS) via rofi and apply it by swapping the symlink.
# Original: https://github.com/JaKooLit

set -euo pipefail

readonly STYLES_DIR="$HOME/dotfiles/waybar/styles"
readonly ACTIVE_LINK="$HOME/dotfiles/waybar/style.css"
readonly ROFI_CONFIG="$HOME/dotfiles/rofi/config.rasi"
readonly RESTART="$HOME/dotfiles/waybar/scripts/wbrestart.sh"

pgrep -x rofi >/dev/null && pkill rofi

choice=$(
    find -L "$STYLES_DIR" -maxdepth 1 -type f -name '*.css' -printf '%f\n' \
        | sed 's/\.css$//' \
        | sort \
        | rofi -i -dmenu -config "$ROFI_CONFIG" -mesg ' Choose Waybar Style '
) || exit 0
[ -n "$choice" ] || exit 0

ln -sf "$STYLES_DIR/$choice.css" "$ACTIVE_LINK"
"$RESTART" &
