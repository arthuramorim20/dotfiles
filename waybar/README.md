# Waybar

Os arquivos ativos são os symlinks `config -> layouts/top-default` e
`style.css -> styles/islands.css`. Os demais layouts e estilos são alternativas
que aparecem nos menus da própria Waybar.

Os arquivos estão separados por função:

- `layouts/`: `top-default` é o layout ativo; os outros são alternativas.
- `styles/`: temas CSS alternativos.
- `modules/`: módulos base, personalizados, grupos e workspaces.
- `scripts/`: troca de layout/estilo e reinício da Waybar.

As cores em `colors.css` são geradas pelo Matugen; a fonte é
`matugen/templates/colors.css`.

Para trocar o layout, altere o destino do symlink `config` para um arquivo em
`layouts/`. Para criar um módulo, coloque a definição no arquivo de módulos
correspondente e adicione seu nome à lista do layout ativo.
