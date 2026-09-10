return {
	-- The public "SF Pro" webfont (installed under /Library/Fonts) does not
	-- carry the same SF Symbols PUA glyph mapping as the OS's real system
	-- font, so icons drawn with it render as "?" tofu. ".AppleSystemUIFont"
	-- is the actual system font and always matches the running macOS version.
	icons = ".AppleSystemUIFont",
	text = "SF Pro",
	numbers = "SF Pro",
	style_map = {
		["Regular"] = "Regular",
		["Semibold"] = "Semibold",
		["Bold"] = "Bold",
		["Heavy"] = "Heavy",
		["Black"] = "Black",
	},
}
