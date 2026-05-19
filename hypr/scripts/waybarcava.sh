#!/usr/bin/env bash
# Drive a waybar custom module with bar-style cava output (low CPU).
# Original: https://github.com/JaKooLit (community contribution)

set -euo pipefail

readonly BARS="▁▂▃▄▅▆▇█"
readonly CONFIG_FILE="/tmp/bar_cava_config"

# Build sed substitution: cava emits digits 0..7; map each to the matching bar glyph.
build_substitution() {
    local subst="s/;//g"
    for ((i = 0; i < ${#BARS}; i++)); do
        subst+=";s/$i/${BARS:$i:1}/g"
    done
    echo "$subst"
}

write_cava_config() {
    cat > "$CONFIG_FILE" <<'EOF'
[general]
framerate = 30
bars = 10

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF
}

write_cava_config
pkill -f "cava -p $CONFIG_FILE" 2>/dev/null || true
exec cava -p "$CONFIG_FILE" | sed -u "$(build_substitution)"
