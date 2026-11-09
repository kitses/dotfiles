local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

config.disable_default_key_bindings = false
config.keys = {
	{ key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
	{ key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
}

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false

config.font = wezterm.font("Iosevka")
config.font_rules = {
	{
		intensity = "Half",
		italic = false,
		font = wezterm.font("Iosevka", { weight = "Regular" }),
	},
	{
		intensity = "Half",
		italic = true,
		font = wezterm.font("Iosevka", {
			weight = "Regular",
			italic = true,
		}),
	},
}
config.font_size = 10.0
config.initial_cols = 120
config.initial_rows = 30
config.kde_window_background_blur = true
config.window_background_opacity = 0.85
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.window_frame = {
	border_left_width = "0px",
	border_right_width = "0px",
	border_top_height = "0px",
	border_bottom_height = "0px",
}
config.window_content_alignment = {
	horizontal = 'Center',
	vertical = 'Center',
}
config.hide_tab_bar_if_only_one_tab = true
config.pane_focus_follows_mouse = true
config.default_cursor_style = "SteadyBar"
config.audible_bell = "Disabled"
config.visual_bell = {
	fade_out_duration_ms = 200,
}
config.colors = {
	foreground = "#ffffff",
	background = "#222222",
	cursor_bg = "#ffffff",
	cursor_border = "#ffffff",
	visual_bell = "#ed1f67",
	ansi = {
		"#353535",
		"#e64569",
		"#89d287",
		"#dab752",
		"#439ecf",
		"#d961dc",
		"#64aaaf",
		"#ffffff",
	},
	brights = {
		"#535353",
		"#e4859a",
		"#a2cca1",
		"#e1e387",
		"#6fbbe2",
		"#e586e7",
		"#96dcda",
		"#ffffff",
	},
	tab_bar = {
		background = "#222222",
		inactive_tab_edge = "#3A3A3A",
		active_tab = {
			bg_color = "#D27B9B",
			fg_color = "#222222",
			intensity = "Bold",
		},
		inactive_tab = {
			bg_color = "#2B2B2B",
			fg_color = "#808080",
		},
		inactive_tab_hover = {
			bg_color = "#333333",
			fg_color = "#DDDDDD",
		},
		new_tab = {
			bg_color = "#222222",
			fg_color = "#626262",
		},
		new_tab_hover = {
			bg_color = "#3C3035",
			fg_color = "#E8A0B8",
		},
	},
}

return config
