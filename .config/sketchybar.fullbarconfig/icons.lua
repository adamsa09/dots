local settings = require("settings")

local icons = {
	sf_symbols = {
		plus = "􀅼",
		loading = "􀖇",
		apple = "􀣺",
		gear = "􀍟",
		cpu = "􀫥",
		clipboard = "􀉄",

		switch = {
			on = "􁏮",
			off = "􁏯",
		},
		battery = {
			_100 = "􀛨",
			_75 = "􀺸",
			_50 = "􀺶",
			_25 = "􀛩",
			_0 = "􀛪",
			charging = "􀢋",
		},
		wifi = {
			upload = "􀄨",
			download = "􀄩",
			connected = "􀙇",
			disconnected = "􀙈",
			router = "􁓤",
			vpn = "󱚿",
			hotspot = "􀉤",
			ethernet = "􀤆",
		},
		bluetooth = {
			on = "󰂯",
			off = "󰂲",
		},
		media = {
			back = "􀊊",
			forward = "􀊌",
			play_pause = "􀊈",
		},
		bell = "󰂚",
	},
	nerdfont = {
		plus = "",
		loading = "",
		apple = "",
		gear = "",
		cpu = "",
		clipboard = "Missing Icon",

		switch = {
			on = "󱨥",
			off = "󱨦",
		},
		battery = {
			_100 = "",
			_75 = "",
			_50 = "",
			_25 = "",
			_0 = "",
			charging = "",
		},
		wifi = {
			upload = "",
			download = "",
			connected = "󰖩",
			disconnected = "󰖪",
			router = "Missing Icon",
			vpn = "󱚿",
			hotspot = "􀉤",
			ethernet = "􀤆",
		},
		bluetooth = {
			on = "󰂯",
			off = "󰂲",
		},
		media = {
			back = "",
			forward = "",
			play_pause = "",
		},
		bell = "󰂚",
	},
}

if settings.icons == "NerdFont" then
	return icons.nerdfont
end

return icons.sf_symbols
