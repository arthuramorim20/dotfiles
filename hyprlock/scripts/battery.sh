#!/usr/bin/env bash
# Print battery level + glyph for the hyprlock label.

set -euo pipefail

readonly BATTERY="/sys/class/power_supply/BAT0"
readonly ICONS=("󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰁹")
readonly CHARGING_ICON="󰂄"

percentage=$(cat "$BATTERY/capacity" 2>/dev/null || echo "")
status=$(cat "$BATTERY/status" 2>/dev/null || echo "")

if [ -z "$percentage" ]; then
    echo "  AC"
    exit 0
fi

if [ "$status" = "Charging" ]; then
    icon="$CHARGING_ICON"
else
    icon="${ICONS[$((percentage / 10))]}"
fi

echo "$percentage% $icon"
