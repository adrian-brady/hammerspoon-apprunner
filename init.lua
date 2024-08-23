local spaces = require("hs.spaces") -- https://github.com/asmagill/hs._asm.spaces

local windows = dofile("bind_windows.lua")
-- dofile("app_chooser.lua")

local function app_bind(windowTable)
	hs.hotkey.bind(windowTable["modifier"], windowTable["key"], function() -- hotkey config
		local BUNDLE_ID = windowTable["bundle_ID"] -- more accurate to avoid mismatching on browser titles

		function getMainWindow(app)
			-- get main window from app
			local win = nil
			while win == nil do
				win = app:mainWindow()
			end
			return win
		end

		function moveWindow(title, space, mainScreen)
			-- move to main space
			local win = getMainWindow(title)
			if win:isFullScreen() then
				hs.eventtap.keyStroke("fn", "f", 0, title)
			end
			winFrame = win:frame()
			scrFrame = mainScreen:fullFrame()
			if windowTable["manage_size"] then
				print("TRUTH")
				winFrame.w = windowTable["frame_properties"]["width"]
				winFrame.h = windowTable["frame_properties"]["height"]
				winFrame.x = windowTable["frame_properties"]["xPos"]
				winFrame.y = windowTable["frame_properties"]["yPos"]
			end
			win:setFrame(winFrame, 0)
			spaces.moveWindowToSpace(win, space)
			if win:isFullScreen() then
				hs.eventtap.keyStroke("fn", "f", 0, title)
			end
			win:focus()
		end

		local title = hs.application.get(BUNDLE_ID)
		if title ~= nil and title:isFrontmost() then
			title:hide()
		else
			local space = spaces.activeSpaceOnScreen()
			local mainScreen = hs.screen.mainScreen()
			if title == nil and hs.application.launchOrFocusByBundleID(BUNDLE_ID) then
				local appWatcher = nil
				appWatcher = hs.application.watcher.new(function(name, event, app)
					if event == hs.application.watcher.launched and app:bundleID() == BUNDLE_ID then
						getMainWindow(app):move(hs.geometry({ x = 0, y = 0, w = 1, h = 0.4 }))
						app:hide()
						moveWindow(app, space, mainScreen)
						appWatcher:stop()
					end
				end)
				appWatcher:start()
			end
			if title ~= nil then
				moveWindow(title, space, mainScreen)
			end
		end
	end)
end

for k, v in pairs(windows) do
	app_bind(v)
end

-- Switch kitty

--hs.hotkey.bind({'option'}, 'return', function ()  -- hotkey config
--  local BUNDLE_ID = 'net.kovidgoyal.kitty' -- more accurate to avoid mismatching on browser titles
--
--  function getMainWindow(app)
--    -- get main window from app
--    local win = nil
--    while win == nil do
--      win = app:mainWindow()
--    end
--    return win
--  end
--
--  function moveWindow(kitty, space, mainScreen)
--    -- move to main space
--    local win = getMainWindow(kitty)
--    if win:isFullScreen() then
--      hs.eventtap.keyStroke('fn', 'f', 0, kitty)
--    end
--    winFrame = win:frame()
--    scrFrame = mainScreen:fullFrame()
--    winFrame.w = scrFrame.w
--    winFrame.y = scrFrame.y
--    winFrame.x = scrFrame.x
--    win:setFrame(winFrame, 0)
--    spaces.moveWindowToSpace(win, space)
--    if win:isFullScreen() then
--      hs.eventtap.keyStroke('fn', 'f', 0, kitty)
--    end
--    win:focus()
--  end
--
--  local kitty = hs.application.get(BUNDLE_ID)
--  if kitty ~= nil and kitty:isFrontmost() then
--    kitty:hide()
--  else
--    local space = spaces.activeSpaceOnScreen()
--    local mainScreen = hs.screen.mainScreen()
--    if kitty == nil and hs.application.launchOrFocusByBundleID(BUNDLE_ID) then
--      local appWatcher = nil
--      appWatcher = hs.application.watcher.new(function(name, event, app)
--        if event == hs.application.watcher.launched and app:bundleID() == BUNDLE_ID then
--          getMainWindow(app):move(hs.geometry({x=0,y=0,w=1,h=0.4}))
--          app:hide()
--          moveWindow(app, space, mainScreen)
--          appWatcher:stop()
--        end
--      end)
--      appWatcher:start()
--    end
--    if kitty ~= nil then
--      moveWindow(kitty, space, mainScreen)
--    end
--  end
--end)

--hs.hotkey.bind({'option'}, 'm', function ()  -- hotkey config
--  local BUNDLE_ID = 'com.apple.MobileSMS' -- more accurate to avoid mismatching on browser titles
--
--  function getMainWindow(app)
--    -- get main window from app
--    local win = nil
--    while win == nil do
--      win = app:mainWindow()
--    end
--    return win
--  end
--
--  function moveWindow(Messages, space, mainScreen)
--    -- move to main space
--    local win = getMainWindow(Messages)
--    if win:isFullScreen() then
--      hs.eventtap.keyStroke('fn', 'f', 0, Messages)
--    end
--    winFrame = win:frame()
--    scrFrame = mainScreen:fullFrame()
--    win:setFrame(winFrame, 0)
--    spaces.moveWindowToSpace(win, space)
--    if win:isFullScreen() then
--      hs.eventtap.keyStroke('fn', 'f', 0, Messages)
--    end
--    win:focus()
--  end
--
--  local Messages = hs.application.get(BUNDLE_ID)
--  if Messages ~= nil and Messages:isFrontmost() then
--    Messages:hide()
--  else
--    local space = spaces.activeSpaceOnScreen()
--    local mainScreen = hs.screen.mainScreen()
--    if Messages == nil and hs.application.launchOrFocusByBundleID(BUNDLE_ID) then
--      local appWatcher = nil
--      appWatcher = hs.application.watcher.new(function(name, event, app)
--        if event == hs.application.watcher.launched and app:bundleID() == BUNDLE_ID then
--          getMainWindow(app):move(hs.geometry({x=0,y=0,w=1,h=0.4}))
--          app:hide()
--          moveWindow(app, space, mainScreen)
--          appWatcher:stop()
--        end
--      end)
--      appWatcher:start()
--    end
--    if Messages ~= nil then
--      moveWindow(Messages, space, mainScreen)
--    end
--  end
--end)

local function reloadConfig(files)
	local doReload = false
	for _, file in pairs(files) do
		if file:sub(-4) == ".lua" then
			doReload = true
		end
	end
	if doReload then
		hs.reload()
	end
end

myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
-- hs.alert.show("Config Loaded", { atScreenEdge = 1 })
