local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

config.color_scheme = 'Atelier Dune (base16)'
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.9
config.font = wezterm.font("Miracode", {})
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
config.use_dead_keys = false

config.leader = { key = " ", mods = "CTRL" , timeout_milliseconds = 1000 }
config.keys = {
	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "c", mods = "LEADER|CTRL", action = act.SpawnTab("DefaultDomain") },
	{ key = " ", mods = "LEADER", action = act.ShowLauncher },
	{ key = " ", mods = "LEADER|CTRL", action = act.ShowLauncher },
	{ key = "d", mods = "LEADER", action = act.ClearScrollback("ScrollbackOnly") },
	{ key = "d", mods = "LEADER|CTRL", action = act.ClearScrollback("ScrollbackAndViewport") },
	{ key = "l", mods = "LEADER", action = act.ClearScrollback("ScrollbackAndViewport") },
}

return config
