#!/usr/bin/env bash
# Restart waybar and swaync after a layout/style switch.

set -euo pipefail

pkill -x waybar 2>/dev/null || true
pkill -x swaync 2>/dev/null || true

swaync &
waybar &
