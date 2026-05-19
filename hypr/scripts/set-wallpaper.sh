#!/usr/bin/env bash
# Apply a wallpaper via awww IPC. Called by matugen's [config.wallpaper] hook
# and by the wppicker.sh after a selection.

set -euo pipefail

readonly IMAGE="${1:?usage: $0 <image-path>}"

# Wait briefly for awww-daemon if it just started; tolerate transient errors.
for _ in 1 2 3 4 5; do
  awww query >/dev/null 2>&1 && break
  sleep 0.3
done

awww img --transition-type=fade --transition-duration=0.4 "$IMAGE"
