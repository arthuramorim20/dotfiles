# dotfiles

Unified configuration for Arch Linux + Hyprland.

The repo contains your personal configuration sources. Applications keep their
runtime data in the normal XDG locations; Ansible creates selective symlinks
from `~/.config/<app>` into this repository. Uses Matugen for color generation
and awww for wallpapers.

## Organização

Cada pasta de aplicativo permanece na raiz porque ela é ligada individualmente
para `~/.config/<app>` pelo Ansible. Isso mantém a estrutura compatível com o
XDG sem misturar caches, perfis e estados de aplicativos no repositório.

- Desktop: `hypr/`, `hyprlock/`, `sddm/`, `waybar/`, `swaync/`, `rofi/`,
  `walker/`, `elephant/` e `matugen/`.
- Terminal/editor: `kitty/`, `tmux/`, `zsh/` e `nvim/`.
- Aparência e aplicativos: `gtk-3.0/`, `gtk-4.0/`, `fastfetch/`, `ulauncher/`
  e `kde/` (Dolphin, KIO e associações de arquivos).
- Dados escolhidos pelo usuário: `wallpapers/` e `icons/`.
- Automação: `ansible/`, `packages/` e `bootstrap.sh`.

`waybar/README.md` e `hypr/README.md` documentam os arquivos ativos e os
symlinks de seleção. Dados gerados e perfis de aplicativos ficam nos diretórios
XDG normais do usuário, fora deste repositório; `wallpapers/current_image`
continua sendo um symlink gerado dentro de `wallpapers/`.

## Install

```sh
./bootstrap.sh            # install Ansible + run the playbook (applies everything)
./bootstrap.sh --check    # install Ansible + dry-run (prints what would change)
```

`bootstrap.sh` only bootstraps Ansible; the actual work lives in
`ansible/playbook.yml`. After the first run you can re-apply directly with
`ansible-playbook ansible/playbook.yml` (add `--check --diff` for a dry-run).

The playbook:
- Removes any old `~/.config/<app>` symlinks pointing into `~/dotfiles`
- Writes `~/.config/environment.d/dotfiles.conf` (systemd user env, picked
  up by uwsm/Hyprland)
- Appends `ZDOTDIR` to `~/.profile` (sddm and
  sh-style logins)
- Symlinks `~/.zshenv -> dotfiles/zsh/.zshenv` (zsh always reads it before
  anything else)
- Symlinks `~/.tmux.conf -> dotfiles/tmux/tmux.conf` so tmux works even when
  launched without XDG set
- Installs the `sddm/` login theme with the same wallpaper, avatar and element
  placement used by `hyprlock/layouts/layout16.conf`

After the first run, log out and back in so systemd/sddm pick up the new env.
The bootstrap file at `~/.config/environment.d/dotfiles.conf` keeps only the
`ZDOTDIR` setting. The standard `~/.config` remains the runtime configuration
root, so browser profiles and application caches stay outside this repository.

Para atualizar somente o tema de login do SDDM, sem executar o restante do
provisionamento:

```sh
ansible-playbook ansible/playbook.yml --ask-become-pass --tags sddm_theme
```
