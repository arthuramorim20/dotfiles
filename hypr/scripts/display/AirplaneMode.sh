#!/usr/bin/env bash
# Toggle airplane mode by blocking/unblocking the wifi radio.
# Original: https://github.com/JaKooLit

set -euo pipefail

readonly NOTIF_ICON="$HOME/dotfiles/swaync/images/airplane.png"

is_wifi_blocked() {
    rfkill list wifi | grep -q "Soft blocked: yes"
}

if is_wifi_blocked; then
    rfkill unblock wifi
    notify-send -u low -i "$NOTIF_ICON" " Airplane" " mode: OFF"
else
    rfkill block wifi
    notify-send -u low -i "$NOTIF_ICON" " Airplane" " mode: ON"
fi
