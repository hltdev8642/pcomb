-- PHYSICS COMBINATION MOD - OPTIONS INTERFACE
-- Comprehensive options for Teardown mod manager
-- Uses Teardown's built-in option system

-- Include centralized settings system
#include "pcomb_settings.lua"

function init()
    -- Initialize centralized settings
    PcombSettings.init()
end

function draw()
    -- Title
    UiAlign("center middle")
    UiTranslate(UiCenter(), 30)
    UiFont("bold.ttf", 24)
    UiText("Physics Combination Mod Settings")
    UiTranslate(0, 40)
    -- Tab system with scrolling
    UiAlign("left middle")
    UiTranslate(50, 0)
    UiFont("regular.ttf", 16)

    local currentTab = GetInt("savegame.mod.pcomb.current_tab") or 1
    local tabScroll = GetInt("savegame.mod.pcomb.tab_scroll") or 0
    local visibleTabs = 6 -- Show 6 tabs at a time
    local tabWidth = 120
    local tabSpacing = 10
    local totalTabWidth = tabWidth + tabSpacing

    -- Navigation arrows for scrolling
    UiPush()
    UiColor(0.5, 0.5, 0.5)
    if tabScroll > 0 then
        if UiTextButton("<", 30, 30) then
            tabScroll = tabScroll - 1
            SetInt("savegame.mod.pcomb.tab_scroll", tabScroll)
        end
    else
        UiText(" ") -- Placeholder to maintain spacing
    end
    UiTranslate(40, 0)

    -- Tab buttons (only show visible range)
    local startTab = tabScroll + 1
    local endTab = math.min(#PcombSettings.tabs, tabScroll + visibleTabs)
    
    for i = startTab, endTab do
        UiPush()
        if currentTab == i then
            UiColor(0.3, 0.6, 1.0)
        else
            UiColor(0.4, 0.4, 0.4)
        end

        if UiTextButton(PcombSettings.tabs[i], tabWidth, 30) then
            SetInt("savegame.mod.pcomb.current_tab", i)
            currentTab = i
        end
        UiPop()
        UiTranslate(totalTabWidth, 0)
    end

    -- Right navigation arrow
    if endTab < #PcombSettings.tabs then
        UiTranslate(10, 0)
        if UiTextButton(">", 30, 30) then
            tabScroll = tabScroll + 1
            SetInt("savegame.mod.pcomb.tab_scroll", tabScroll)
        end
    end
    UiPop()

    -- Tab indicator showing current position
    UiTranslate(0, 35)
    UiFont("regular.ttf", 12)
    UiColor(0.7, 0.7, 0.7)
    UiText(string.format("Tab %d of %d (%s)", currentTab, #PcombSettings.tabs, PcombSettings.tabs[currentTab]))
    UiTranslate(0, 15)

    -- Move down for content area but keep horizontal origin unchanged
    UiTranslate(0, 50)
    -- Render selected tab content using centralized functions
    if currentTab == 1 then
        PcombSettings.drawGlobalTab()
    elseif currentTab == 2 then
        PcombSettings.drawPRGDCoreTab()
    elseif currentTab == 3 then
        PcombSettings.drawPRGDAdvancedTab()
    elseif currentTab == 4 then
        PcombSettings.drawIBSITCoreTab()
    elseif currentTab == 5 then
        PcombSettings.drawIBSITAdvancedTab()
    elseif currentTab == 6 then
        PcombSettings.drawMBCSTab()
    elseif currentTab == 7 then
        PcombSettings.drawPerformanceTab()
    elseif currentTab == 8 then
        PcombSettings.drawMaterialsTab()
    end
end