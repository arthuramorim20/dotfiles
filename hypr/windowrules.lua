-- BLUR / OPACITY
hl.window_rule({ match = { tag = "multimedia_video*" }, no_blur = true, opacity = "1.0" })
hl.window_rule({ match = { tag = "settings*" },         opacity = "0.96 override 0.92 override" })
hl.window_rule({ match = { class = "org.gnome.Nautilus" },                    opacity = "0.96 override 0.92 override" })
hl.window_rule({ match = { class = "gedit|org.gnome.TextEditor|mousepad" },   opacity = "0.97 override 0.94 override" })
hl.window_rule({ match = { class = "org.pulseaudio.pavucontrol" },             opacity = "0.96 override 0.92 override" })
hl.window_rule({ match = { class = "kitty" },                                  opacity = "0.95 override 0.92 override" })
hl.window_rule({ match = { class = "code" },           opacity = "0.97 override 0.93 override" })
hl.window_rule({ match = { class = "[Uu]launcher" },   opacity = "1.0 override", float = true, border_size = 0, no_shadow = true, move = {"33%", "15%"} })
hl.window_rule({ match = { class = "discord|vesktop|org.telegram.desktop" },  opacity = "0.96 override 0.92 override 1 override" })
hl.window_rule({ match = { class = "Spotify" },        opacity = "0.95 override 0.90 override 1 override" })
hl.window_rule({ match = { class = "zen" },            opacity = "0.97 override 0.94 override 1 override" })
hl.window_rule({ match = { class = "rest.insomnia.Insomnia" }, opacity = "0.96 override 0.92 override 1 override" })

-- LAYER RULES
hl.layer_rule({ match = { namespace = "waybar" },                   blur = true, ignore_alpha = 0.15 })
hl.layer_rule({ match = { namespace = "swaync-control-center" },    blur = true, ignore_alpha = 0.15 })
hl.layer_rule({ match = { namespace = "swaync-notification-window" }, blur = true, ignore_alpha = 0.15 })

-- FLOAT
hl.window_rule({ match = { tag = "settings*" },        float = true })
hl.window_rule({ match = { tag = "viewer*" },           float = true })
hl.window_rule({ match = { tag = "multimedia_video*" }, float = true, size = {900, 506} })
hl.window_rule({ match = { class = "org.pulseaudio.pavucontrol" }, float = true, size = {"50%", "60%"} })

-- Ignore maximize requests
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })

-- Fix XWayland dragging
hl.window_rule({ match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false }, no_focus = true })

-- POP UPS / DIALOGUES
hl.window_rule({ match = { title = "Save As|Save a File|Pick Files" }, float = true, size = {"50%", "60%"}, center = true })
hl.window_rule({ match = { initial_title = "Open Files" },              float = true, size = {"70%", "60%"} })
