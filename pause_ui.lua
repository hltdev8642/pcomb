-- Pause-menu integration for Pcomb profiles
-- Adds a PauseMenuButton that toggles an overlay containing the Profiles tab

#include "pcomb_settings.lua"

local showPcombOverlay = false
local pause_selected_tab = 9 -- 9 = Ground Detection, 10 = Profiles
-- Vertical scroll offset (in pixels) for the pause overlay content area
local pause_scroll = 0

-- Registry key used to persist pause overlay scroll
local PAUSE_SCROLL_KEY = "savegame.mod.pcomb.pause_scroll"

function init()
    PcombSettings.init()
    -- Load persisted tab if available
    pause_selected_tab = GetInt("savegame.mod.pcomb.current_tab") or 9
    pause_scroll = GetInt(PAUSE_SCROLL_KEY) or 0
end

function tick()
    -- Keep pause menu button visible
    if PauseMenuButton("Pcomb Settings") then
        showPcombOverlay = not showPcombOverlay
        if showPcombOverlay then
            -- when opening overlay, sync selection with persisted tab
            pause_selected_tab = GetInt("savegame.mod.pcomb.current_tab") or 9
        end
    end

    -- Close overlay automatically if unpaused
    if not IsPaused() then
        showPcombOverlay = false
    end
end

function draw()
    if showPcombOverlay and IsPaused() then
        UiMakeInteractive()

        UiPush()
        UiAlign("center middle")
        UiTranslate(UiCenter(), UiMiddle())
        UiColor(0, 0, 0, 0.7)
        UiRect(1200, 1200)
        UiTranslate(-600, -600)

        -- Header
        UiPush()
        UiFont("bold.ttf", 20)
        UiColor(1,1,1)
        UiAlign("left top")
        UiTranslate(20, 20)
        UiText("Physics Combination Mod")
        UiTranslate(0, 30)

        -- Small tab selector for Ground Detection and Profiles
        UiPush()
        UiTranslate(0, 10)
        UiFont("regular.ttf", 16)
        UiColor(0.4,0.4,0.4)
        if pause_selected_tab == 9 then UiColor(0.25,0.6,1.0) else UiColor(0.4,0.4,0.4) end
        if UiTextButton("Ground Detection", 220, 30) then
            pause_selected_tab = 9
            SetInt("savegame.mod.pcomb.current_tab", 9)
        end
        UiTranslate(230, 0)
        if pause_selected_tab == 10 then UiColor(0.25,0.6,1.0) else UiColor(0.4,0.4,0.4) end
        if UiTextButton("Profiles", 220, 30) then
            pause_selected_tab = 10
            SetInt("savegame.mod.pcomb.current_tab", 10)
        end
        UiPop()

        UiPop()

        UiTranslate(20, 80)
        UiPush()
        UiTranslate(10, 10)
        UiAlign("left top")

        -- Scroll controls (Up/Down) displayed at the top-right of the content area
        UiPush()
        UiAlign("right top")
        UiTranslate(560, 0)
        UiFont("regular.ttf", 14)
        UiColor(0.6, 0.6, 0.6)
        if UiTextButton("▲", 36, 24) then
            pause_scroll = math.max(0, pause_scroll - 60)
            SetInt(PAUSE_SCROLL_KEY, pause_scroll)
        end
        UiTranslate(0, 30)
        if UiTextButton("▼", 36, 24) then
            pause_scroll = pause_scroll + 60
            SetInt(PAUSE_SCROLL_KEY, pause_scroll)
        end
        UiTranslate(0, 30)
        UiText("Scroll: " .. tostring(pause_scroll))
        UiPop()

        -- Apply vertical scroll offset for the content area
        UiTranslate(0, -pause_scroll)

        -- Draw the selected panel's content using centralized tab draw functions
        if pause_selected_tab == 9 then
            PcombSettings.drawGroundTab()
        elseif pause_selected_tab == 10 then
            PcombSettings.drawProfilesTab()
        end
        UiPop()

        UiPop()
    end
end
