local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local bluetooth = sbar.add("item", "widgets.bluetooth", {
	position = "right",
	icon = {
		string = icons.bluetooth.on,
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
	click_script = "open 'x-apple.systempreferences:com.apple.BluetoothSettings'",
})

sbar.add("bracket", "widgets.bluetooth.bracket", {
	bluetooth.name,
}, {
	background = colors.island,
})

sbar.add("item", "widgets.bluetooth.padding", {
	position = "right",
	width = settings.group_padding,
})

local power_script = [[
defaults read /Library/Preferences/com.apple.Bluetooth ControllerPowerState 2>/dev/null
]]

local function update_bluetooth()
	sbar.exec(power_script, function(result)
		result = result:gsub("^%s*(.-)%s*$", "%1")
		local is_on = result ~= "0"
		bluetooth:set({
			icon = {
				string = is_on and icons.bluetooth.on or icons.bluetooth.off,
				color = is_on and colors.white or colors.red,
			},
		})
	end)
end

bluetooth:subscribe({ "system_woke" }, update_bluetooth)
sbar.exec("sleep 0.1", update_bluetooth)
