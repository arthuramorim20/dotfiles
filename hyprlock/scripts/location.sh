#!/usr/bin/env bash
# Print "country, city" from ipinfo.io with a 24h on-disk cache.

set -euo pipefail

readonly CACHE_FILE="$HOME/.cache/ip_cache.txt"
readonly TTL_SECONDS=86400

fetch_location() {
    curl -fsS ipinfo.io 2>/dev/null \
        | jq -r '.country + ", " + .city' 2>/dev/null
}

source "$(dirname "$0")/_cached.sh"
print_cached_or_refresh "$CACHE_FILE" "$TTL_SECONDS" fetch_location
