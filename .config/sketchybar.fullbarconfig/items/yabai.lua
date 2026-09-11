local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local yabai_bin = settings.binaries.yabai
local app_font = "sketchybar-app-font:Regular:" .. settings.font_sizes.app

local function trim(value)
	return value and value:gsub("^%s*(.-)%s*$", "%1") or value
end

local function yabai_exec(arguments, callback)
	sbar.exec(yabai_bin .. " " .. arguments, callback)
end

sbar.add("event", "yabai_refresh")

-- Fixed pool of space slots. Yabai space indices are assigned in order and
-- shift as spaces are created/destroyed, so this just needs to cover the
-- largest index we're realistically going to see; unused slots stay hidden.
local workspace_order = {}
for i = 1, 20 do
	workspace_order[i] = tostring(i)
end

local workspaces = {}

local function build_workspace(workspace_id)
	local click_script = yabai_bin .. " -m space --focus " .. workspace_id

	local separator = sbar.add("item", "yabai.sep." .. workspace_id, {
		icon = { drawing = false },
		label = {
			string = "›",
			font = { size = 10 },
			color = colors.grey,
			padding_left = 4,
			padding_right = 2,
		},
		padding_left = 0,
		padding_right = 0,
		drawing = false,
	})

	local ws_icon = sbar.add("item", "yabai.ws." .. workspace_id, {
		icon = {
			font = settings.label_font,
			color = colors.grey,
			padding_left = 10,
			padding_right = 0,
		},
		label = { drawing = false },
		padding_left = 1,
		drawing = false,
		click_script = click_script,
	})

	local ws_apps = sbar.add("item", "yabai.apps." .. workspace_id, {
		icon = { drawing = false },
		label = {
			font = app_font,
			color = colors.white,
			padding_right = 10,
			y_offset = -1,
		},
		padding_right = 1,
		drawing = false,
		click_script = click_script,
	})

	local bracket = sbar.add("bracket", "yabai.bracket." .. workspace_id, { ws_icon.name, ws_apps.name }, {
		background = colors.island,
		drawing = false,
	})

	local ws_name = sbar.add("item", "yabai.name." .. workspace_id, {
		icon = { drawing = false },
		label = {
			font = settings.label_font,
			color = colors.white,
		},
		padding_left = 4,
		padding_right = 6,
		drawing = false,
		click_script = click_script,
	})

	workspaces[workspace_id] = {
		separator = separator,
		ws_icon = ws_icon,
		ws_apps = ws_apps,
		bracket = bracket,
		ws_name = ws_name,
	}
end

for _, workspace_id in ipairs(workspace_order) do
	build_workspace(workspace_id)
end

local yabai_anchor = sbar.add("item", "yabai.anchor", {
	icon = { drawing = false },
	label = { drawing = false },
	width = 0,
	padding_left = 0,
	padding_right = 0,
})

local function parse_workspace_apps(all_windows_output)
	local workspace_apps = {}
	local seen = {}

	for line in all_windows_output:gmatch("[^\r\n]+") do
		local workspace_id, app_name = line:match("^([^|]+)|(.+)$")
		if workspace_id then
			workspace_id = trim(workspace_id)
			app_name = trim(app_name)
			workspace_apps[workspace_id] = workspace_apps[workspace_id] or {}
			seen[workspace_id] = seen[workspace_id] or {}
			if app_name ~= "" and not seen[workspace_id][app_name] then
				seen[workspace_id][app_name] = true
				table.insert(workspace_apps[workspace_id], app_name)
			end
		end
	end

	return workspace_apps
end

local function parse_focused_workspace(spaces_output)
	for line in spaces_output:gmatch("[^\r\n]+") do
		local workspace_id, has_focus = line:match("^([^|]+)|(.+)$")
		if workspace_id and trim(has_focus) == "true" then
			return trim(workspace_id)
		end
	end
	return nil
end

local function render_all()
	yabai_exec("-m query --windows | jq -r '.[] | \"\\(.space)|\\(.app)\"'", function(all_windows_output)
		yabai_exec("-m query --spaces | jq -r '.[] | \"\\(.index)|\\(.[\"has-focus\"])\"'", function(spaces_output)
			yabai_exec("-m query --windows --window | jq -r '.app // empty'", function(focused_app_output)
				local focused_workspace = parse_focused_workspace(spaces_output)
				local focused_app = trim(focused_app_output)
				local workspace_apps = parse_workspace_apps(all_windows_output)
				local first_active = true

				for _, workspace_id in ipairs(workspace_order) do
					local ui = workspaces[workspace_id]
					local apps = workspace_apps[workspace_id] or {}
					local is_focused = workspace_id == focused_workspace
					local is_active = #apps > 0 or is_focused

					if not is_active then
						ui.separator:set({ drawing = false })
						ui.bracket:set({ drawing = false })
						ui.ws_icon:set({ drawing = false })
						ui.ws_apps:set({ drawing = false })
						ui.ws_name:set({ drawing = false })
					else
						ui.separator:set({ drawing = not first_active })
						first_active = false

						local glyphs = {}
						for _, app_name in ipairs(apps) do
							table.insert(glyphs, app_icons[app_name] or app_icons.Default or "—")
						end

						ui.ws_icon:set({
							drawing = true,
							icon = {
								string = workspace_id,
								color = is_focused and colors.white or colors.grey,
							},
						})
						ui.ws_apps:set({
							drawing = true,
							label = { string = table.concat(glyphs) },
						})
						ui.bracket:set({
							drawing = true,
							background = is_focused and colors.island_active or colors.island,
						})

						if is_focused then
							ui.ws_name:set({
								drawing = true,
								label = { string = focused_app or "" },
							})
						else
							ui.ws_name:set({ drawing = false })
						end
					end
				end
			end)
		end)
	end)
end

yabai_anchor:subscribe({ "yabai_refresh", "front_app_switched" }, render_all)

render_all()
