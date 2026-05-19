# dotfiles

Unified configuration for Arch Linux + Hyprland.

The repo IS your `$XDG_CONFIG_HOME`. No `~/.config/<app>` symlinks — apps read
straight from `~/dotfiles/<app>/`. Uses Matugen for color generation and
hyprpaper for wallpapers.

## Layout

```
dotfiles/
├── hypr/        ->  $XDG_CONFIG_HOME/hypr/
├── hyprlock/    ->  $XDG_CONFIG_HOME/hyprlock/
├── kitty/       ->  $XDG_CONFIG_HOME/kitty/
├── waybar/      ->  $XDG_CONFIG_HOME/waybar/
├── rofi/        ->  $XDG_CONFIG_HOME/rofi/
├── swaync/      ->  $XDG_CONFIG_HOME/swaync/
├── wlogout/     ->  $XDG_CONFIG_HOME/wlogout/
├── cava/        ->  $XDG_CONFIG_HOME/cava/
├── fastfetch/   ->  $XDG_CONFIG_HOME/fastfetch/
├── matugen/     ->  $XDG_CONFIG_HOME/matugen/
├── nvim/        ->  $XDG_CONFIG_HOME/nvim/
├── tmux/        ->  $XDG_CONFIG_HOME/tmux/   (and ~/.tmux.conf fallback)
├── zsh/         ->  $ZDOTDIR/                (.zshenv, .zshrc)
├── wallpapers/
└── install.sh   # bootstrap XDG_CONFIG_HOME, no per-app symlinks
```

## Install

```sh
./install.sh              # dry-run (prints what would happen)
./install.sh --apply      # bootstrap XDG_CONFIG_HOME and cleanup
./install.sh --uninstall  # revert the bootstrap
```

The installer:
- Removes any old `~/.config/<app>` symlinks pointing into `~/dotfiles`
- Writes `~/.config/environment.d/dotfiles.conf` (systemd user env, picked
  up by uwsm/Hyprland)
- Appends `XDG_CONFIG_HOME` / `ZDOTDIR` exports to `~/.profile` (sddm and
  sh-style logins)
- Symlinks `~/.zshenv -> dotfiles/zsh/.zshenv` (zsh always reads it before
  anything else)
- Symlinks `~/.tmux.conf -> dotfiles/tmux/tmux.conf` so tmux works even when
  launched without XDG set

After `--apply`, log out and back in so systemd/sddm pick up the new env.
The single bootstrap file at `~/.config/environment.d/dotfiles.conf` is the
only file kept under `~/.config/` — it has to live there because the systemd
user manager reads `$XDG_CONFIG_HOME/environment.d/` and uses the default
location until `XDG_CONFIG_HOME` itself is set.
