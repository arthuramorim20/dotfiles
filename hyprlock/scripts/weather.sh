#!/usr/bin/env bash
# Print weather "icon temp" from wttr.in with a 24h on-disk cache.

set -euo pipefail

readonly CACHE_FILE="$HOME/.cache/wttr_cache.txt"
readonly TTL_SECONDS=86400

fetch_weather() {
    curl -fsS "wttr.in?format=%c+%C+%t" 2>/dev/null
}

source "$(dirname "$0")/_cached.sh"
print_cached_or_refresh "$CACHE_FILE" "$TTL_SECONDS" fetch_weather
