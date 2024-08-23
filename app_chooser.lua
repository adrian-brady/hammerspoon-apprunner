local spaces = require("hs.spaces")
local chooser = require("hs.chooser")

local choices = {
	{
		["text"] = "First Choice",
		["subText"] = "This is the subtext",
		["uuid"] = "0001",
	},
	{
		["text"] = "Second Choice",
		["subText"] = "This is the subtext",
		["uuid"] = "0002",
	},
}

local function myFunction(param)
	hs.alert.show("function")
end

local choose_menu = chooser.new(myFunction)
choose_menu:choices(choices)

choose_menu:show()
