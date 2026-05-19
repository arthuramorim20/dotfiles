# icons/

Monochrome SVGs used by configs that **can render images** (waybar via
Pango `<img src="..."/>`, GTK CSS via `background-image: url(...)`).

`fill="currentColor"` makes each icon inherit the surrounding text color
so they pick up theme changes from matugen automatically.

## Where each icon is used

| icon                | rendered via              | replaces emoji |
|---------------------|---------------------------|----------------|
| power.svg           | waybar `custom/power`     | ⏻              |
| check.svg           | (terminal — not used)     | ✓              |
| cross.svg           | (terminal — not used)     | ✗              |
| arrow-right.svg     | (terminal — not used)     | ➜              |
| play.svg, pause.svg | (terminal — not used)     | ▶, ⏸           |
| warning.svg         | (terminal — not used)     | ⚠              |
| error.svg           | (terminal — not used)     | ❌              |
| success.svg         | (terminal — not used)     | ✅              |
| rocket.svg          | (terminal — not used)     | 🚀             |
| point-down.svg      | (comment — not used)      | 👇             |

## Why some icons are "not used"

Many emoji locations are in **terminal-rendered contexts** (nvim
notifications, hyprlock label scripts, shell echo). Terminals draw
text via a font; they have no way to embed an `<img>` or load an SVG.
For those locations the substitution had to be a Nerd Font glyph or
plain text — not an image. The SVGs are kept here so the assets are
ready if you later move that UI into a context that does support
images (a GTK widget, a custom waybar module, a notification panel
with HTML, etc).
