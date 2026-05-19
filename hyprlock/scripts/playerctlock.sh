#!/usr/bin/env bash
# Spotify metadata bridge for hyprlock: prints a single field, also
# refreshes the lock-screen background art when the track changes.

set -euo pipefail

readonly PLAYER="spotify"
readonly THUMB=/tmp/hyde-mpris
readonly THUMB_BLURRED=/tmp/hyde-mpris-blurred
readonly TITLE_MAX=15
readonly ARTIST_MAX=20

usage() {
    echo "Usage: $0 --title|--arturl|--artist|--position|--length|--album|--source|--status"
    exit 1
}

[ $# -gt 0 ] || usage

# ---------- metadata helpers ----------

metadata() {
    playerctl -p "$PLAYER" metadata --format "{{ $1 }}" 2>/dev/null || true
}

format_us_as_min_sec() {
    local us="$1"
    local total_s=$(( us / 1000000 ))
    printf '%d:%02d min' $(( total_s / 60 )) $(( total_s % 60 ))
}

format_seconds() {
    local sec="${1%.*}"
    printf '%d:%02d' $(( sec / 60 )) $(( sec % 60 ))
}

# ---------- art / background ----------

refresh_artwork() {
    local art_url
    art_url=$(metadata "mpris:artUrl")
    [ -n "$art_url" ] || return 0

    [ -f "${THUMB}.inf" ] && [ "$art_url" = "$(cat "${THUMB}.inf")" ] && return 0

    printf '%s\n' "$art_url" > "${THUMB}.inf"
    curl -fsSo "${THUMB}.png" "$art_url" || return 1
    magick "${THUMB}.png" -quality 50 "${THUMB}.png"
    magick "${THUMB}.png" -blur 200x7 -resize 1920x^ \
        -gravity center -extent '1920x1080!' "${THUMB_BLURRED}.png"
    pkill -USR2 hyprlock || true
}

require_spotify() {
    playerctl -l 2>/dev/null | grep -qx "$PLAYER" \
        || { echo "Not playing on $PLAYER"; exit 1; }
}

require_spotify
( refresh_artwork || rm -f "${THUMB}".* ) &

# ---------- field dispatch ----------

case "$1" in
    --title)
        title=$(metadata "xesam:title")
        [ -z "$title" ] && echo "" || echo "${title:0:$TITLE_MAX}..."
        ;;
    --artist)
        artist=$(metadata "xesam:artist")
        [ -z "$artist" ] && echo "" || echo "${artist:0:$ARTIST_MAX}"
        ;;
    --album)
        album=$(metadata "xesam:album")
        if [ -n "$album" ]; then
            echo "$album"
        else
            [ -n "$(playerctl status 2>/dev/null || true)" ] \
                && echo "Not album" || echo ""
        fi
        ;;
    --position)
        pos=$(playerctl position 2>/dev/null || true)
        len=$(metadata "mpris:length")
        if [ -n "$pos" ] && [ -n "$len" ]; then
            echo "$(format_seconds "$pos")/$(format_us_as_min_sec "$len")"
        else
            echo ""
        fi
        ;;
    --length)
        len=$(metadata "mpris:length")
        [ -z "$len" ] && echo "" || format_us_as_min_sec "$len"
        ;;
    --status)
        # Nerd Font glyphs: hyprlock renders the label via font, no images.
        case "$(playerctl status 2>/dev/null || true)" in
            Playing) echo "" ;;
            Paused)  echo "" ;;
            *)       echo "" ;;
        esac
        ;;
    --arturl)
        metadata "mpris:artUrl"
        ;;
    --source)
        trackid=$(metadata "mpris:trackid")
        [[ "$trackid" == *"$PLAYER"* ]] && echo -e "Spotify " || echo ""
        ;;
    *)
        usage
        ;;
esac
