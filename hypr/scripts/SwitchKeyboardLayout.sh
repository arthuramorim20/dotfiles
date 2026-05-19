#!/usr/bin/env bash
# Cycle xkb layouts across every keyboard at once, publish the active
# short code (`us`, `br`, ...) to ~/.cache/kb_layout so the waybar
# custom/keyboard module can show it, and pop a synchronous notification.

set -euo pipefail

readonly CACHE_FILE="$HOME/.cache/kb_layout"
readonly NOTIF_TAG="string:x-canonical-private-synchronous:kb_layout_notif"
readonly NOTIF_ICON="$HOME/dotfiles/icons/keyboard.svg"

short_label() {
    case "$1" in
        *"English (US)"*)         echo "us"  ;;
        *"Portuguese (Brazil)"*)  echo "br"  ;;
        *"Portuguese"*)           echo "pt"  ;;
        *"Spanish"*)              echo "es"  ;;
        *)                        echo "${1:0:2}" | tr '[:upper:]' '[:lower:]' ;;
    esac
}

active_keymap() {
    hyprctl -j devices \
        | jq -r '([.keyboards[] | select(.main==true)][0] // .keyboards[0]).active_keymap'
}

publish_active_label() {
    short_label "$(active_keymap)" > "$CACHE_FILE"
}

notify_layout() {
    local full short
    full=$(active_keymap)
    short=$(short_label "$full")
    notify-send -e -u low -i "$NOTIF_ICON" -h "$NOTIF_TAG" \
        "Keyboard layout" "$short — $full"
}

case "${1:---toggle}" in
    --toggle|--next)
        hyprctl switchxkblayout all next >/dev/null
        publish_active_label
        notify_layout
        ;;
    --refresh)
        publish_active_label
        ;;
    *)
        echo "usage: $0 [--toggle|--refresh]"; exit 1 ;;
esac
