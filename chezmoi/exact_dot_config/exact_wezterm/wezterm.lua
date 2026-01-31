local wezterm = require("wezterm")

local config = {
	color_scheme = "Tokyo Night",
	font_size = 16.0,
	window_background_opacity = 1.0, -- 0.85,
	font = wezterm.font_with_fallback({
		"Fira Code",
		"HackGen Console",
	}),
	use_ime = true,
	audible_bell = "Disabled",
	visual_bell = {
		fade_in_function = "EaseIn",
		fade_in_duration_ms = 150,
		fade_out_function = "EaseOut",
		fade_out_duration_ms = 150,
	},
	colors = {
		visual_bell = "#505050",
	},
	enable_scroll_bar = true,
	window_decorations = "RESIZE",

	-- tab settings
	hide_tab_bar_if_only_one_tab = true, -- １つの時にタブバーを非表示
	window_background_gradient = {
		colors = { "#1a1b26" },
	},
	show_new_tab_button_in_tab_bar = false,
	window_frame = {
		inactive_titlebar_bg = "none",
		active_titlebar_bg = "none",
	},
}

-- key bindings
local keybinds = require("keybinds")
config.keys = keybinds.keys
config.key_tables = keybinds.key_tables

return config
