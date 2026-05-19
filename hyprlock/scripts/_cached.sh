# shellcheck shell=bash
# Helper: print a cached value or refresh it via a fetcher callback.
# Source from another script and call print_cached_or_refresh.

print_cached_or_refresh() {
    local cache_file="$1" ttl="$2" fetcher="$3"
    mkdir -p "$(dirname "$cache_file")"

    if [ -s "$cache_file" ]; then
        local age=$(( $(date +%s) - $(stat -c %Y "$cache_file") ))
        if [ "$age" -lt "$ttl" ]; then
            cat "$cache_file"
            return
        fi
    fi

    local fresh
    fresh=$("$fetcher")
    if [ -n "$fresh" ]; then
        printf '%s\n' "$fresh" | tee "$cache_file"
    elif [ -s "$cache_file" ]; then
        cat "$cache_file"
    fi
}
