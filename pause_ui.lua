-- Pause-menu integration for Pcomb profiles
-- Adds a PauseMenuButton that toggles an overlay containing the Profiles tab

#include "pcomb_settings.lua"

local showProfilesInPause = false

function init()
    PcombSettings.init()
end

function tick()
    -- Must be called every frame so the pause menu button is visible
    if PauseMenuButton("Pcomb Profiles") then
        -- Toggle overlay visibility when the pause-menu button is clicked
        showProfilesInPause = not showProfilesInPause
        -- Ensure the Profiles tab is selected when opening from pause
        SetInt("savegame.mod.pcomb.current_tab", 9)
    end

    -- Close overlay automatically if unpaused
    if not IsPaused() then
        showProfilesInPause = false
    end
end

function draw()
    -- Only draw overlay while paused and when the toggle is active
    if showProfilesInPause and IsPaused() then
        -- Allow UI interaction while paused
        UiMakeInteractive()

        -- Semi-transparent panel centered on screen
        UiPush()
        UiAlign("center middle")
        UiTranslate(UiCenter(), UiMiddle())
        UiColor(0, 0, 0, 0.6)
        UiRect(920, 740)
        UiTranslate(-440, -360)

        -- Draw only the Profiles tab from centralized settings UI
        PcombSettings.drawProfilesTab()
        UiPop()
    end
end
