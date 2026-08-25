# Hyprland

Arquivos ativos:

- `hyprland.lua`: entrada principal, autostart e atalhos.
- `hyprlock.conf` e `hypridle.conf`: bloqueio e gerenciamento de inatividade.
- `theme.lua`: paleta da decoração das janelas gerada pelo Matugen; não editar
  manualmente.
- `scripts/audio/`: volume e controles de áudio.
- `scripts/display/`: brilho, teclado e modo avião.
- `scripts/session/`: bloqueio e menu de saída.
- `scripts/wallpaper/`: seleção e aplicação de wallpapers.

Para alterar atalhos ou autostart, comece por `hyprland.lua`. Para ações
reutilizáveis, adicione ou altere um script na categoria correspondente e
referencie-o por caminho absoluto baseado em `$HOME/dotfiles`.

O padrão visual das janelas fica em `hyprland.lua`: gaps amplos, borda fina,
cantos em formato de squircle, sombra suave e blur. As superfícies internas de
aplicativos GTK são complementadas por `gtk-3.0/gtk.css` e `gtk-4.0/gtk.css`.
