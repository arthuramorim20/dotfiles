-- MONITOR
hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "0x0", scale = 1 })

local palette = require("theme")

local function alpha(color, opacity)
	return "rgba(" .. color:gsub("^#", "") .. opacity .. ")"
end

-- AUTOSTART
-- hl.exec_cmd no top-level só dispara em `hyprctl reload`, não no boot inicial.
-- Por isso registramos os daemons em `hyprland.start`, que roda uma vez quando
-- o compositor sobe. O pgrep continua servindo de guarda em reloads (matugen).
local function once(proc, cmd)
	hl.exec_cmd("sh -c 'pgrep -x " .. proc .. " >/dev/null || " .. cmd .. "'")
end

hl.on("hyprland.start", function()
	once("elephant", "elephant") -- walker (wallpaper picker) data backend
	once("nm-applet", "uwsm app -- nm-applet --indicator")
	-- Deixe uma única instância, supervisionada pelo serviço do pacote. Iniciar
	-- também via `uwsm app` causa disputa pelo nome D-Bus e quebra o toggle.
	hl.exec_cmd("systemctl --user start ulauncher.service")
	-- awww (swww fork) — sem splash, IPC confiável.
	once("awww-daemon", "awww-daemon")
	hl.exec_cmd(
		"sh -c 'for i in 1 2 3 4 5; do awww query >/dev/null 2>&1 && break; sleep 0.3; done;"
			.. " awww img "
			.. os.getenv("HOME")
			.. "/dotfiles/wallpapers/current_image'"
	)
	once("blueman-applet", "uwsm app -- blueman-applet")
	once("swaync", "uwsm app -- swaync")
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	once("hypridle", "uwsm app -- hypridle")
	-- prime ~/.cache/kb_layout so waybar's custom/keyboard has a value at boot
	hl.exec_cmd(os.getenv("HOME") .. "/dotfiles/hypr/scripts/display/SwitchKeyboardLayout.sh --refresh")
end)

-- ENV
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- LOOK AND FEEL
hl.config({
	general = {
		gaps_in = 12,
		gaps_out = 18,
		border_size = 1,
		col = {
			active_border = alpha(palette.primary, "b8"),
			inactive_border = alpha(palette.outline_variant, "80"),
		},
		resize_on_border = true,
		allow_tearing = false,
		layout = "dwindle",
	},
	decoration = {
		rounding = 18,
		rounding_power = 3.2,
		active_opacity = 1.0,
		inactive_opacity = 0.94,
		shadow = {
			enabled = true,
			range = 18,
			render_power = 3,
			color = alpha(palette.shadow, "70"),
		},
		blur = {
			enabled = true,
			size = 8,
			passes = 3,
			ignore_opacity = true,
			special = false,
			popups = true,
			xray = false,
			vibrancy = 0.1696,
		},
	},
	dwindle = {
		preserve_split = true,
	},
	master = {
		new_status = "master",
	},
	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
	},
	input = {
		kb_layout = "us,br",
		kb_variant = ",abnt2",
		kb_options = "grp:alt_shift_toggle", -- Alt+Shift cycles layouts
		follow_mouse = 1,
		sensitivity = 0,
		accel_profile = "flat",
		touchpad = {
			natural_scroll = true,
		},
	},
})

-- ANIMATIONS
hl.config({ animations = { enabled = true } })
hl.curve("been", { type = "bezier", points = { { 0.24, 0.9 }, { 0.25, 0.91 } } })
hl.curve("been2", { type = "bezier", points = { { 0, 0.94 }, { 0.5, 0.99 } } })
hl.curve("menu_decel", { type = "bezier", points = { { 0.1, 1 }, { 0, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0.0, 0.0 }, { 1.0, 1.0 } } })
hl.curve("wind", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("winIn", { type = "bezier", points = { { 0.1, 1.1 }, { 0.1, 1.1 } } })
hl.curve("winOut", { type = "bezier", points = { { 0.3, -0.3 }, { 0, 1 } } })
hl.curve("slow", { type = "bezier", points = { { 0, 0.85 }, { 0.3, 1 } } })
hl.curve("overshot", { type = "bezier", points = { { 0.7, 0.6 }, { 0.1, 1.1 } } })
hl.curve("bounce", { type = "bezier", points = { { 1.1, 1.6 }, { 0.1, 0.85 } } })

hl.animation({ leaf = "windowsIn", enabled = true, speed = 5, bezier = "slow", style = "popin" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "been", style = "popin 70%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, bezier = "wind", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "linear" })
hl.animation({ leaf = "fade", enabled = true, speed = 5, bezier = "overshot" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "wind" })
hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "bounce", style = "popin" })

-- TAGS AND WINDOW RULES
require("tags")
require("windowrules")

-- KEYBINDINGS
local mainMod = "SUPER"
local terminal = "kitty"
local fileManager = "dolphin"
local menu = "ulauncher-toggle"

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd(terminal, { float = true, size = { 800, 550 } }))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind("CTRL + ALT + Delete", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen())
hl.bind("Print", hl.dsp.exec_cmd("screenshot"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("screenshot region"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(os.getenv("HOME") .. "/dotfiles/hypr/scripts/wallpaper/wppicker.sh"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind(mainMod .. " + H", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"))
hl.bind(
	mainMod .. " + T",
	hl.dsp.exec_cmd(os.getenv("HOME") .. "/dotfiles/hypr/scripts/display/SwitchKeyboardLayout.sh --toggle")
)

-- Focus
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Move windows
hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.move({ direction = "down" }))

-- Resize
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.resize({ x = -50, y = 0 }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 50, y = 0 }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -50 }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 50 }), { repeating = true })

-- Workspaces
for i = 1, 9 do
	hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Mouse drag/resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media keys
hl.bind(
	"XF86AudioRaiseVolume",
		hl.dsp.exec_cmd(os.getenv("HOME") .. "/dotfiles/hypr/scripts/audio/volume.sh --inc"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
		hl.dsp.exec_cmd(os.getenv("HOME") .. "/dotfiles/hypr/scripts/audio/volume.sh --dec"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
		hl.dsp.exec_cmd(os.getenv("HOME") .. "/dotfiles/hypr/scripts/audio/volume.sh --toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86MonBrightnessUp",
		hl.dsp.exec_cmd(os.getenv("HOME") .. "/dotfiles/hypr/scripts/display/brightness.sh --inc"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86MonBrightnessDown",
		hl.dsp.exec_cmd(os.getenv("HOME") .. "/dotfiles/hypr/scripts/display/brightness.sh --dec"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
