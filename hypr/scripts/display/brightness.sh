#!/usr/bin/env bash
# Monitor backlight control via brightnessctl with a notification badge.
# Original: https://github.com/JaKooLit

set -euo pipefail

readonly ICONS_DIR="$HOME/dotfiles/swaync/icons"
readonly STEP=10
readonly MIN_BRIGHTNESS=5
readonly MAX_BRIGHTNESS=100
readonly NOTIF_TAG="string:x-canonical-private-synchronous:brightness_notif"

get_backlight() {
    brightnessctl -m | cut -d, -f4 | tr -d '%'
}

backlight_icon() {
    local v="$1"
    if   [ "$v" -le 20 ]; then echo "$ICONS_DIR/brightness-20.png"
    elif [ "$v" -le 40 ]; then echo "$ICONS_DIR/brightness-40.png"
    elif [ "$v" -le 60 ]; then echo "$ICONS_DIR/brightness-60.png"
    elif [ "$v" -le 80 ]; then echo "$ICONS_DIR/brightness-80.png"
    else                       echo "$ICONS_DIR/brightness-100.png"
    fi
}

notify_brightness() {
    local v="$1" icon
    icon=$(backlight_icon "$v")
    notify-send -e -h "$NOTIF_TAG" -h "int:value:$v" \
        -u low -i "$icon" "Screen" "Brightness: $v%"
}

clamp() {
    local v="$1"
    (( v < MIN_BRIGHTNESS )) && v=$MIN_BRIGHTNESS
    (( v > MAX_BRIGHTNESS )) && v=$MAX_BRIGHTNESS
    echo "$v"
}

change_backlight() {
    local delta="$1" new current
    current=$(get_backlight)
    new=$(clamp $((current + delta)))
    brightnessctl set "${new}%"
    notify_brightness "$new"
}

case "${1:---get}" in
    --get)  get_backlight              ;;
    --inc)  change_backlight  "$STEP"  ;;
    --dec)  change_backlight "-$STEP"  ;;
    *)      get_backlight              ;;
esac
