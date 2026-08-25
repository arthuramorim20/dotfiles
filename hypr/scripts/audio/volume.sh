#!/usr/bin/env bash
# Volume & microphone control via wpctl (PipeWire / WirePlumber).

set -euo pipefail

readonly ICONS_DIR="$HOME/dotfiles/swaync/icons"
readonly NOTIF_TAG="string:x-canonical-private-synchronous:volume_notif"
readonly SINK="@DEFAULT_AUDIO_SINK@"
readonly SOURCE="@DEFAULT_AUDIO_SOURCE@"
readonly STEP=1
readonly MAX_VOLUME=150  # percent; wpctl accepts >100 directly

# ---------- helpers ----------

# Returns "<volume_percent> <muted:0|1>"; e.g. "47 0" or "0 1"
_sink_state() {
    wpctl get-volume "$SINK" | awk '
        { vol = int($2 * 100) }
        /MUTED/ { muted = 1 }
        END    { printf "%d %d\n", vol, muted+0 }
    '
}

_source_state() {
    wpctl get-volume "$SOURCE" | awk '
        { vol = int($2 * 100) }
        /MUTED/ { muted = 1 }
        END    { printf "%d %d\n", vol, muted+0 }
    '
}

# ---------- speakers ----------

get_volume() {
    read -r v muted < <(_sink_state)
    [ "$muted" -eq 1 ] && echo "Muted" || echo "$v %"
}

volume_icon() {
    read -r v muted < <(_sink_state)
    if   [ "$muted" -eq 1 ]; then echo "$ICONS_DIR/volume-mute.png"
    elif [ "$v" -le 30 ];    then echo "$ICONS_DIR/volume-low.png"
    elif [ "$v" -le 60 ];    then echo "$ICONS_DIR/volume-mid.png"
    else                          echo "$ICONS_DIR/volume-high.png"
    fi
}

notify_volume() {
    read -r v _ < <(_sink_state)
    notify-send -e -h "int:value:$v" -h "$NOTIF_TAG" \
        -u low -i "$(volume_icon)" " Volume" " $v%"
}

# wpctl accepts X%+ / X%- and clamps at the limiter set below.
inc_volume() {
    read -r _ muted < <(_sink_state)
    [ "$muted" -eq 1 ] && toggle_mute && return
    wpctl set-volume -l "$(awk "BEGIN{print $MAX_VOLUME/100}")" "$SINK" "${STEP}%+"
    notify_volume
}

dec_volume() {
    read -r _ muted < <(_sink_state)
    [ "$muted" -eq 1 ] && toggle_mute && return
    wpctl set-volume "$SINK" "${STEP}%-"
    notify_volume
}

toggle_mute() {
    wpctl set-mute "$SINK" toggle
    read -r _ muted < <(_sink_state)
    if [ "$muted" -eq 1 ]; then
        notify-send -e -u low -i "$ICONS_DIR/volume-mute.png" " Mute"
    else
        notify-send -e -u low -i "$(volume_icon)" " Volume" " Switched ON"
    fi
}

# ---------- microphone ----------

mic_icon() {
    read -r _ muted < <(_source_state)
    [ "$muted" -eq 1 ] \
        && echo "$ICONS_DIR/microphone-mute.png" \
        || echo "$ICONS_DIR/microphone.png"
}

notify_mic() {
    read -r v _ < <(_source_state)
    notify-send -e -h "int:value:$v" -h "$NOTIF_TAG" \
        -u low -i "$(mic_icon)" " Mic Level" " $v%"
}

inc_mic_volume() {
    read -r _ muted < <(_source_state)
    [ "$muted" -eq 1 ] && toggle_mic && return
    wpctl set-volume "$SOURCE" "${STEP}%+"
    notify_mic
}

dec_mic_volume() {
    read -r _ muted < <(_source_state)
    [ "$muted" -eq 1 ] && toggle_mic && return
    wpctl set-volume "$SOURCE" "${STEP}%-"
    notify_mic
}

toggle_mic() {
    wpctl set-mute "$SOURCE" toggle
    read -r _ muted < <(_source_state)
    if [ "$muted" -eq 1 ]; then
        notify-send -e -u low -i "$ICONS_DIR/microphone-mute.png" " Microphone" " Switched OFF"
    else
        notify-send -e -u low -i "$ICONS_DIR/microphone.png" " Microphone" " Switched ON"
    fi
}

# ---------- dispatch ----------

case "${1:---get}" in
    --get)          get_volume      ;;
    --inc)          inc_volume      ;;
    --dec)          dec_volume      ;;
    --toggle)       toggle_mute     ;;
    --toggle-mic)   toggle_mic      ;;
    --get-icon)     volume_icon     ;;
    --get-mic-icon) mic_icon        ;;
    --mic-inc)      inc_mic_volume  ;;
    --mic-dec)      dec_mic_volume  ;;
    *)              get_volume      ;;
esac
