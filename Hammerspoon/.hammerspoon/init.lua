-- Hammerspoon configuration: pointer jumps and Spectacle-style window placement.
-- Setup: install https://www.hammerspoon.org/ and grant Accessibility access.
-- Save this file as ~/.hammerspoon/init.lua, then choose Reload Config in the
-- Hammerspoon menu. Shortcuts act globally while Hammerspoon is running.
-- Modifier names: alt = Option, cmd = Command, ctrl = Control, shift = Shift.
--
-- Credit: the window actions and key combinations below are inspired by
-- Spectacle, created by Eric Czarny and its contributors:
-- https://github.com/eczarny/spectacle
-- https://github.com/eczarny/spectacle#keyboard-shortcuts
-- This Lua configuration implements the listed actions using Hammerspoon APIs.
-- It does not implement Spectacle's repeated-press thirds or undo/redo history.

-- POINTER SHORTCUTS: Option + Shift + 1 through 9.
-- Credit: display-jumping behavior is inspired by CatchMouse (version 1.2),
-- which lets users move the cursor between displays using keyboard shortcuts.
-- CatchMouse project: https://github.com/round/CatchMouse
-- This implementation uses Hammerspoon to jump directly to a display's center;
-- the numbered shortcuts and laptop-first ordering are customized for this setup.
-- Moving the pointer does not click, move a window, or change keyboard focus.
-- Build the display list on every press so connecting/disconnecting monitors
-- takes effect without reloading. Display 1 is the laptop when detected by name;
-- external displays follow in desktop-coordinate order. With the laptop display
-- disconnected (e.g. lid closed), numbering starts with the external displays.
-- Detection assumes a built-in display name containing "Built-in" or "Color LCD".
local function orderedScreens()
    local screens = hs.screen.allScreens()
    local laptop
    local external = {}

    for _, screen in ipairs(screens) do
        if screen:name():find("Built%-in") or
           screen:name():find("Color LCD") then
            laptop = screen
        else
            table.insert(external, screen)
        end
    end

    -- Sort external displays left to right; ties are sorted top to bottom.
    -- Positions come from the arrangement configured in macOS Display Settings.
    table.sort(external, function(a, b)
        local af, bf = a:fullFrame(), b:fullFrame()
        if af.x == bf.x then return af.y < bf.y end
        return af.x < bf.x
    end)

    local ordered = {}
    if laptop then table.insert(ordered, laptop) end
    for _, screen in ipairs(external) do
        table.insert(ordered, screen)
    end
    return ordered
end

for i = 1, 9 do
    -- Keep a separate display number captured by each shortcut callback.
    local displayNumber = i
    hs.hotkey.bind({"alt", "shift"}, tostring(i), function()
        local screen = orderedScreens()[displayNumber]
        if not screen then
            hs.alert.show("Display " .. displayNumber .. " unavailable")
            return
        end

        -- fullFrame includes the menu bar/Dock area; use desktop coordinates
        -- to place the pointer at the center of the selected display.
        local frame = screen:fullFrame()
        hs.mouse.absolutePosition({
            x = frame.x + frame.w / 2,
            y = frame.y + frame.h / 2
        })
    end)
end


-- WINDOW SHORTCUTS: Spectacle-inspired mappings credited above.
-- Disable movement animations so window placement is immediate.
-- Applications may enforce minimum sizes or refuse window manipulation.
hs.window.animationDuration = 0

-- Apply actions to the focused window; do nothing if no window has focus.
local function withWindow(action)
    local win = hs.window.focusedWindow()
    if win then action(win) end
end

-- Layout values are {x, y, width, height}, expressed as fractions of the
-- current display's usable area (excluding its menu bar and Dock).
-- For example, {0.5, 0, 0.5, 1} occupies the right half of that area.
local function bindLayout(modifiers, key, layout)
    hs.hotkey.bind(modifiers, key, function()
        withWindow(function(win)
            win:moveToUnit(layout)
        end)
    end)
end

-- Option + Command + C: center the window, preserving its size.
hs.hotkey.bind({"alt", "cmd"}, "C", function()
    withWindow(function(win)
        win:centerOnScreen()
    end)
end)

-- Option + Command + F: maximize within the usable screen area.
-- This does not enter macOS fullscreen mode or create a separate Space.
hs.hotkey.bind({"alt", "cmd"}, "F", function()
    withWindow(function(win)
        win:maximize()
    end)
end)

-- Option + Command + arrow: left, right, top, or bottom half.
bindLayout({"alt", "cmd"}, "Left",  {0,   0,   0.5, 1})
bindLayout({"alt", "cmd"}, "Right", {0.5, 0,   0.5, 1})
bindLayout({"alt", "cmd"}, "Up",    {0,   0,   1,   0.5})
bindLayout({"alt", "cmd"}, "Down",  {0,   0.5, 1,   0.5})

-- Control + Command + Left/Right: upper left/right quarter.
-- Add Shift for the lower left/right quarter.
bindLayout({"ctrl", "cmd"}, "Left",  {0,   0,   0.5, 0.5})
bindLayout({"ctrl", "cmd"}, "Right", {0.5, 0,   0.5, 0.5})
bindLayout({"ctrl", "shift", "cmd"}, "Left",  {0,   0.5, 0.5, 0.5})
bindLayout({"ctrl", "shift", "cmd"}, "Right", {0.5, 0.5, 0.5, 0.5})

-- Control + Option + Command + Right/Left: next/previous display.
-- These move the window using Hammerspoon's display order, which may differ
-- from the laptop-first order used by the pointer shortcuts above.
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "Right", function()
    withWindow(function(win)
        win:moveToScreen(win:screen():next())
    end)
end)

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "Left", function()
    withWindow(function(win)
        win:moveToScreen(win:screen():previous())
    end)
end)