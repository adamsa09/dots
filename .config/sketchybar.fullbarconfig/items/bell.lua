local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local bell = sbar.add("item", "bell", {
	position = "right",
	icon = {
		string = icons.bell,
		color = colors.white,
		font = {
			family = "Hack Nerd Font",
			style = settings.font.style_map["Bold"],
			size = settings.font_sizes.icon_medium,
		},
		padding_left = 8,
		padding_right = 8,
	},
	label = { drawing = false },
	click_script = "osascript -e 'tell application \"System Events\" to tell process \"ControlCenter\" to click (first menu bar item of menu bar 1 whose description is \"Clock\")'",
})

sbar.add("bracket", "bell.bracket", {
	bell.name,
}, {
	background = colors.island,
})

sbar.add("item", "bell.padding", {
	position = "right",
	width = settings.group_padding,
})
