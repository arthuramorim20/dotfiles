#!/usr/bin/env bash

active_class=$(hyprctl activewindow -j 2>/dev/null | jq -r '.initialClass // .class // ""')

case "${active_class,,}" in
    "")                         printf '%s\n' "Desktop" ;;
    brave-browser|brave)         printf '%s\n' "Brave" ;;
    chromium|google-chrome*)     printf '%s\n' "Chrome" ;;
    firefox|org.mozilla.firefox) printf '%s\n' "Firefox" ;;
    kitty)                       printf '%s\n' "Kitty" ;;
    org.kde.dolphin|dolphin)     printf '%s\n' "Dolphin" ;;
    spotify)                     printf '%s\n' "Spotify" ;;
    steam)                       printf '%s\n' "Steam" ;;
    vesktop|discord)             printf '%s\n' "Discord" ;;
    code|code-oss|codium)        printf '%s\n' "Code" ;;
    *)
        app_name=${active_class##*.}
        app_name=${app_name//[-_]/ }
        awk '{ for (i = 1; i <= NF; i++) $i = toupper(substr($i, 1, 1)) substr($i, 2); print }' <<< "$app_name"
        ;;
esac
