#!/usr/bin/env bash
# Wallpaper picker using walker's files provider for native image preview.
#
# Walker doesn't allow custom shell actions on a provider, so we hijack:
#   - files.Return is configured to "copypath" (in dotfiles/walker/config.toml)
#   - we snapshot the clipboard, open walker, read the new clipboard after
#     it closes, and apply the wallpaper if a wallpaper path was copied
#   - the old clipboard is restored

set -euo pipefail

WALL_DIR="$HOME/dotfiles/wallpapers"
CURRENT_LINK="$WALL_DIR/current_image"
SETSCRIPT="$HOME/dotfiles/hypr/scripts/wallpaper/set-wallpaper.sh"

# Snapshot current clipboard (may be empty/binary; tolerate failure)
old_clip=$(wl-paste --no-newline 2>/dev/null || true)

# Theme "wallpaper" is shipped in dotfiles/walker/themes/wallpaper/
# Files provider's search_dirs is constrained to wallpapers via
# dotfiles/elephant/files.toml, so only wallpapers will show up.
walker -t wallpaper -m files -p "Wallpaper" || true

# Tiny grace period — wl-copy on Return is async
sleep 0.15

new_clip=$(wl-paste --no-newline 2>/dev/null || true)

restore_clip() {
  if [ -n "$old_clip" ]; then
    printf '%s' "$old_clip" | wl-copy
  else
    wl-copy --clear 2>/dev/null || true
  fi
}

# Only act if clipboard changed AND new content is an existing wallpaper
if [ "$new_clip" != "$old_clip" ] \
  && [ -n "$new_clip" ] \
  && [ -f "$new_clip" ] \
  && [[ "$new_clip" == "$WALL_DIR"/* ]]; then

  matugen image --prefer=darkness "$new_clip" >/dev/null 2>&1 || true
  ln -sfn "$new_clip" "$CURRENT_LINK"
  "$SETSCRIPT" "$new_clip"
fi

restore_clip
