-- osascript -e 'id of app "App Name"'
local windows = {
	arc = {
		modifier = "option",
		key = "a",
		bundle_ID = "",
		title = "arc",
		manage_size = false,
		frame_properties = {},
	},

	kitty = {
		modifier = "option",
		key = "return",
		bundle_ID = "",
		title = "wezterm",
		manage_size = false,
		frame_properties = {},
	},

	messages = {
		modifier = "option",
		key = "m",
		bundle_ID = "",
		title = "messages",
		manage_size = false,
		frame_properties = {},
	},

	obsidian = {
		modifier = "option",
		key = "o",
		bundle_ID = "",
		title = "obsidian",
		manage_size = false,
		frame_properties = {},
	},

	ulysses = {
		modifier = "option",
		key = "u",
		bundle_ID = "",
		title = "UlyssesMac",
		manage_size = false,
		frame_properties = {},
	},

	things3 = {
		modifier = "option",
		key = "t",
		bundle_ID = "",
		title = "Things3",
		manage_size = false,
		frame_properties = {},
	},

	zed = {
		modifier = "option",
		key = "z",
		bundle_ID = "",
		title = "Zed",
		manage_size = false,
		frame_properties = {},
	},

	gitbutler = {
		modifier = "option",
		key = "g",
		bundle_ID = "",
		title = "Gitbutler",
		manage_size = false,
		frame_properties = {},
	},
}

for k, v in pairs(windows) do
	local command = "osascript -e 'id of app \"" .. v["title"] .. "\"'"
	local file = io.popen(command, "r")
	local output = file:read("*a"):gsub("\n", "")
	file:close()
	v["bundle_ID"] = output
	print("Registered app: " .. v["title"])
	print("  === On keys: " .. v["modifier"] .. " + " .. v["key"])
	print("  === On bundleID: " .. v["bundle_ID"])
	print("  === Managed Size: " .. tostring(v["manage_size"]))
	print()
end

return windows
