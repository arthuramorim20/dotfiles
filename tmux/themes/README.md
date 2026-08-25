# tmux themes

O tema ativo é o symlink `../theme.conf`.

Para trocar o tema, crie ou copie um arquivo nesta pasta contendo somente
opções visuais do tmux (`status-*`, `window-status-*`, bordas e mensagens) e
aponte o symlink para ele:

```sh
ln -sfn themes/meu-tema.conf ~/dotfiles/tmux/theme.conf
tmux source-file ~/.tmux.conf
```

Plugins, shell, atalhos e comportamento pertencem ao `tmux.conf` e não devem
ser colocados nos temas.
