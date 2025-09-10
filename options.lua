-- PHYSICS COMBINATION MOD - OPTIONS INTERFACE
-- Simple options for Teardown mod manager
-- Uses Teardown's built-in option system

function init()
    -- Initialize default values if they don't exist
    if not HasKey("savegame.mod.pcomb.global.enabled") then
        SetBool("savegame.mod.pcomb.global.enabled", true)
    end
    if not HasKey("savegame.mod.pcomb.global.debug") then
        SetBool("savegame.mod.pcomb.global.debug", false)
    end
    if not HasKey("savegame.mod.pcomb.global.priority") then
        SetInt("savegame.mod.pcomb.global.priority", 2)
    end
    if not HasKey("savegame.mod.pcomb.prgd.enabled") then
        SetBool("savegame.mod.pcomb.prgd.enabled", true)
    end
    if not HasKey("savegame.mod.pcomb.prgd.dust") then
        SetBool("savegame.mod.pcomb.prgd.dust", true)
    end
    if not HasKey("savegame.mod.pcomb.prgd.dust_amount") then
        SetInt("savegame.mod.pcomb.prgd.dust_amount", 25)
    end
    if not HasKey("savegame.mod.pcomb.ibsit.enabled") then
        SetBool("savegame.mod.pcomb.ibsit.enabled", true)
    end
    if not HasKey("savegame.mod.pcomb.ibsit.particles") then
        SetBool("savegame.mod.pcomb.ibsit.particles", true)
    end
    if not HasKey("savegame.mod.pcomb.ibsit.sounds") then
        SetBool("savegame.mod.pcomb.ibsit.sounds", true)
    end
    if not HasKey("savegame.mod.pcomb.mbcs.enabled") then
        SetBool("savegame.mod.pcomb.mbcs.enabled", true)
    end
    if not HasKey("savegame.mod.pcomb.mbcs.mass_threshold") then
        SetInt("savegame.mod.pcomb.mbcs.mass_threshold", 8)
    end
end

function draw()
    -- Title
    UiAlign("center middle")
    UiTranslate(UiCenter(), 50)
    UiFont("bold.ttf", 32)
    UiText("Physics Combination Mod Settings")
    UiTranslate(0, 60)

    -- Global Settings
    UiAlign("left middle")
    UiTranslate(100, 0)
    UiFont("bold.ttf", 24)
    UiText("Global Settings")
    UiTranslate(0, 40)

    UiFont("regular.ttf", 20)
    local globalEnabled = UiBoolOption("Enable Physics Combination Mod", "savegame.mod.pcomb.global.enabled", GetBool("savegame.mod.pcomb.global.enabled"))
    local debugEnabled = UiBoolOption("Debug Mode", "savegame.mod.pcomb.global.debug", GetBool("savegame.mod.pcomb.global.debug"))

    -- Priority slider
    UiTranslate(0, 20)
    UiText("Performance Priority (1=Performance, 2=Quality, 3=Maximum)")
    UiTranslate(0, 30)
    local priority = GetInt("savegame.mod.pcomb.global.priority")
    local newPriority = UiSlider("ui/common/dot.png", 200, 20, priority, 1, 3)
    if newPriority ~= priority then
        SetInt("savegame.mod.pcomb.global.priority", newPriority)
    end
    UiTranslate(0, 40)

    -- PRGD Settings
    UiTranslate(-400, 100)
    UiFont("bold.ttf", 24)
    UiText("Progressive Destruction (PRGD)")
    UiTranslate(0, 40)

    UiFont("regular.ttf", 20)
    local prgdEnabled = UiBoolOption("Enable Progressive Destruction", "savegame.mod.pcomb.prgd.enabled", GetBool("savegame.mod.pcomb.prgd.enabled"))
    local dustEnabled = UiBoolOption("Enable Dust Effects", "savegame.mod.pcomb.prgd.dust", GetBool("savegame.mod.pcomb.prgd.dust"))

    -- Dust amount slider
    UiTranslate(0, 20)
    UiText("Dust Amount (0-100)")
    UiTranslate(0, 30)
    local dustAmount = GetInt("savegame.mod.pcomb.prgd.dust_amount")
    local newDustAmount = UiSlider("ui/common/dot.png", 200, 20, dustAmount, 0, 100)
    if newDustAmount ~= dustAmount then
        SetInt("savegame.mod.pcomb.prgd.dust_amount", newDustAmount)
    end
    UiTranslate(0, 40)

    -- IBSIT Settings
    UiTranslate(400, -140)
    UiFont("bold.ttf", 24)
    UiText("Structural Integrity (IBSIT)")
    UiTranslate(0, 40)

    UiFont("regular.ttf", 20)
    local ibsitEnabled = UiBoolOption("Enable Structural Integrity", "savegame.mod.pcomb.ibsit.enabled", GetBool("savegame.mod.pcomb.ibsit.enabled"))
    local particlesEnabled = UiBoolOption("Enable Particle Effects", "savegame.mod.pcomb.ibsit.particles", GetBool("savegame.mod.pcomb.ibsit.particles"))
    local soundsEnabled = UiBoolOption("Enable Sound Effects", "savegame.mod.pcomb.ibsit.sounds", GetBool("savegame.mod.pcomb.ibsit.sounds"))
    UiTranslate(0, 40)

    -- MBCS Settings
    UiTranslate(0, 100)
    UiFont("bold.ttf", 24)
    UiText("Mass Based Collateral (MBCS)")
    UiTranslate(0, 40)

    UiFont("regular.ttf", 20)
    local mbcsEnabled = UiBoolOption("Enable Mass Collateral", "savegame.mod.pcomb.mbcs.enabled", GetBool("savegame.mod.pcomb.mbcs.enabled"))

    -- Mass threshold slider
    UiTranslate(0, 20)
    UiText("Mass Threshold (2^4 to 2^16)")
    UiTranslate(0, 30)
    local massThreshold = GetInt("savegame.mod.pcomb.mbcs.mass_threshold")
    local newMassThreshold = UiSlider("ui/common/dot.png", 200, 20, massThreshold, 4, 16)
    if newMassThreshold ~= massThreshold then
        SetInt("savegame.mod.pcomb.mbcs.mass_threshold", newMassThreshold)
    end
    UiTranslate(0, 40)

    -- Performance Presets
    UiTranslate(-400, 100)
    UiFont("bold.ttf", 24)
    UiText("Performance Presets")
    UiTranslate(0, 40)

    UiFont("regular.ttf", 20)
    UiText("Quick configuration for different performance needs:")
    UiTranslate(0, 30)

    -- Performance Mode Button
    UiPush()
    UiColor(0.2, 0.6, 0.2)
    if UiTextButton("Performance Mode (45+ FPS)", 200, 30) then
        SetInt("savegame.mod.pcomb.global.priority", 1)
        SetInt("savegame.mod.pcomb.prgd.dust_amount", 15)
        SetInt("savegame.mod.pcomb.ibsit.particle_quality", 1)
    end
    UiPop()
    UiTranslate(220, 0)

    -- Quality Mode Button
    UiPush()
    UiColor(0.6, 0.6, 0.2)
    if UiTextButton("Quality Mode (30+ FPS)", 200, 30) then
        SetInt("savegame.mod.pcomb.global.priority", 2)
        SetInt("savegame.mod.pcomb.prgd.dust_amount", 25)
        SetInt("savegame.mod.pcomb.ibsit.particle_quality", 2)
    end
    UiPop()
    UiTranslate(220, 0)

    -- Maximum Mode Button
    UiPush()
    UiColor(0.6, 0.2, 0.2)
    if UiTextButton("Maximum Mode (20+ FPS)", 200, 30) then
        SetInt("savegame.mod.pcomb.global.priority", 3)
        SetInt("savegame.mod.pcomb.prgd.dust_amount", 50)
        SetInt("savegame.mod.pcomb.ibsit.particle_quality", 5)
    end
    UiPop()
end

function UiBoolOption(text, key, initialValue)
    UiText(text)
    UiTranslate(0, 35)
    local returnValue = initialValue
    if initialValue then
        UiColor(0.467, 0.867, 0.467) -- Green
        if UiTextButton("Enabled") then
            returnValue = false
            SetBool(key, returnValue)
        end
    else
        UiColor(0.910, 0.420, 0.302) -- Red
        if UiTextButton("Disabled") then
            returnValue = true
            SetBool(key, returnValue)
        end
    end
    UiTranslate(0, 80)
    UiColor(1, 1, 1)
    return returnValue
end