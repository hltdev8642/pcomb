-- PHYSICS COMBINATION MOD - CENTRALIZED SETTINGS
-- Shared settings system for both main options menu and pause menu
-- Ensures both menus access identical settings and defaults

PcombSettings = {}

-- Tab definitions (shared between both menus)
PcombSettings.tabs = {
    "Global",
    "PRGD Core",
    "PRGD Advanced",
    "IBSIT Core",
    "IBSIT Advanced",
    "MBCS",
    "Performance",
    "Materials"
}

-- Settings registry keys and their default values
PcombSettings.defaults = {
    -- Global settings
    ["savegame.mod.pcomb.global.enabled"] = true,
    ["savegame.mod.pcomb.global.debug"] = false,
    ["savegame.mod.pcomb.global.priority"] = 2,
    ["savegame.mod.pcomb.global.performance_scale"] = 1.0,
    ["savegame.mod.pcomb.current_tab"] = 1,
    ["savegame.mod.pcomb.tab_scroll"] = 0,

    -- PRGD settings
    ["savegame.mod.pcomb.prgd.enabled"] = true,
    ["savegame.mod.pcomb.prgd.crumble"] = true,
    ["savegame.mod.pcomb.prgd.dust"] = true,
    ["savegame.mod.pcomb.prgd.explosions"] = false,
    ["savegame.mod.pcomb.prgd.force"] = false,
    ["savegame.mod.pcomb.prgd.fire"] = false,
    ["savegame.mod.pcomb.prgd.violence"] = false,
    ["savegame.mod.pcomb.prgd.joints"] = false,
    ["savegame.mod.pcomb.prgd.fps_control"] = true,
    ["savegame.mod.pcomb.prgd.fps_target"] = 30,
    ["savegame.mod.pcomb.prgd.sdf"] = true,
    ["savegame.mod.pcomb.prgd.lff"] = false,
    ["savegame.mod.pcomb.prgd.dbf"] = false,
    ["savegame.mod.pcomb.prgd.damage_light"] = 50,
    ["savegame.mod.pcomb.prgd.damage_medium"] = 50,
    ["savegame.mod.pcomb.prgd.damage_heavy"] = 50,
    ["savegame.mod.pcomb.prgd.crumble_size"] = 8,
    ["savegame.mod.pcomb.prgd.crumble_speed"] = 2,
    ["savegame.mod.pcomb.prgd.dust_amount"] = 25,
    ["savegame.mod.pcomb.prgd.dust_size"] = 2,
    ["savegame.mod.pcomb.prgd.dust_life"] = 8,
    ["savegame.mod.pcomb.prgd.dust_gravity"] = 0.35,
    ["savegame.mod.pcomb.prgd.dust_drag"] = 0.15,

    -- IBSIT settings
    ["savegame.mod.pcomb.ibsit.enabled"] = true,
    ["savegame.mod.pcomb.ibsit.particles"] = true,
    ["savegame.mod.pcomb.ibsit.sounds"] = true,
    ["savegame.mod.pcomb.ibsit.haptic"] = true,
    ["savegame.mod.pcomb.ibsit.vehicles"] = false,
    ["savegame.mod.pcomb.ibsit.joints"] = false,
    ["savegame.mod.pcomb.ibsit.protection"] = false,
    ["savegame.mod.pcomb.ibsit.dust_amount"] = 50,
    ["savegame.mod.pcomb.ibsit.wood_damage"] = 100,
    ["savegame.mod.pcomb.ibsit.stone_damage"] = 75,
    ["savegame.mod.pcomb.ibsit.metal_damage"] = 50,
    ["savegame.mod.pcomb.ibsit.momentum_threshold"] = 12,
    ["savegame.mod.pcomb.ibsit.gravity_collapse"] = true,
    ["savegame.mod.pcomb.ibsit.collapse_threshold"] = 0.3,
    ["savegame.mod.pcomb.ibsit.gravity_force"] = 2.0,
    ["savegame.mod.pcomb.ibsit.com_margin"] = 0.05,
    ["savegame.mod.pcomb.ibsit.debris_cleanup"] = true,
    ["savegame.mod.pcomb.ibsit.cleanup_delay"] = 30.0,
    ["savegame.mod.pcomb.ibsit.fps_optimization"] = true,
    ["savegame.mod.pcomb.ibsit.target_fps"] = 30,
    ["savegame.mod.pcomb.ibsit.volume"] = 0.7,
    ["savegame.mod.pcomb.ibsit.particle_quality"] = 2,

    -- MBCS settings
    ["savegame.mod.pcomb.mbcs.enabled"] = true,
    ["savegame.mod.pcomb.mbcs.dust_amount"] = 50,
    ["savegame.mod.pcomb.mbcs.wood_damage"] = 100,
    ["savegame.mod.pcomb.mbcs.stone_damage"] = 75,
    ["savegame.mod.pcomb.mbcs.metal_damage"] = 50,
    ["savegame.mod.pcomb.mbcs.mass_threshold"] = 8,
    ["savegame.mod.pcomb.mbcs.distance_threshold"] = 4,

    -- Materials settings
    ["savegame.mod.pcomb.materials.multi_directional"] = true,
    ["savegame.mod.pcomb.materials.glass.density"] = 2.5,
    ["savegame.mod.pcomb.materials.glass.collapse_resistance"] = 0.1,
    ["savegame.mod.pcomb.materials.wood.density"] = 0.6,
    ["savegame.mod.pcomb.materials.wood.collapse_resistance"] = 0.4,
    ["savegame.mod.pcomb.materials.stone.density"] = 2.6,
    ["savegame.mod.pcomb.materials.stone.collapse_resistance"] = 0.8,
    ["savegame.mod.pcomb.materials.metal.density"] = 7.8,
    ["savegame.mod.pcomb.materials.metal.collapse_resistance"] = 0.95,
    ["savegame.mod.pcomb.materials.compatibility_factor"] = 1.0,

    -- Impact settings
    ["savegame.mod.pcomb.impact.enabled"] = true,
    ["savegame.mod.pcomb.impact.multiplier"] = 1.0,
    ["savegame.mod.pcomb.impact.radius"] = 2.0,

    -- Conversion settings
    ["savegame.mod.pcomb.conversion.size_threshold"] = 1.0
}

-- Initialize all default values if they don't exist
function PcombSettings.init()
    for key, defaultValue in pairs(PcombSettings.defaults) do
        if not HasKey(key) then
            if type(defaultValue) == "boolean" then
                SetBool(key, defaultValue)
            elseif type(defaultValue) == "number" then
                if math.floor(defaultValue) == defaultValue then
                    SetInt(key, defaultValue)
                else
                    SetFloat(key, defaultValue)
                end
            end
        end
    end
end

-- Get setting value with type safety
function PcombSettings.get(key)
    if not HasKey(key) then
        return PcombSettings.defaults[key]
    end

    local defaultValue = PcombSettings.defaults[key]
    if type(defaultValue) == "boolean" then
        return GetBool(key)
    elseif type(defaultValue) == "number" then
        if math.floor(defaultValue) == defaultValue then
            return GetInt(key)
        else
            return GetFloat(key)
        end
    end
    return nil
end

-- Set setting value with type safety
function PcombSettings.set(key, value)
    local defaultValue = PcombSettings.defaults[key]
    if type(defaultValue) == "boolean" then
        SetBool(key, value)
    elseif type(defaultValue) == "number" then
        if math.floor(defaultValue) == defaultValue then
            SetInt(key, value)
        else
            SetFloat(key, value)
        end
    end
end

-- UI Helper Functions (shared between both menus)

-- Boolean option toggle button
function PcombSettings.UiBoolOption(text, key)
    UiText(text)
    UiTranslate(0, 35)

    -- Read current state
    local currentValue = PcombSettings.get(key)
    local buttonClicked = false
    local newValue = currentValue

    if currentValue then
        UiColor(0.467, 0.867, 0.467) -- Green
        if UiTextButton("Enabled") then
            buttonClicked = true
            newValue = false
            PcombSettings.set(key, newValue)
        end
    else
        UiColor(0.910, 0.420, 0.302) -- Red
        if UiTextButton("Disabled") then
            buttonClicked = true
            newValue = true
            PcombSettings.set(key, newValue)
        end
    end

    -- If button was clicked, provide immediate visual feedback
    if buttonClicked then
        UiTranslate(0, -35)
        UiText(text)
        UiTranslate(0, 35)

        if newValue then
            UiColor(0.467, 0.867, 0.467)
            UiText("Enabled")
        else
            UiColor(0.910, 0.420, 0.302)
            UiText("Disabled")
        end
    end

    UiTranslate(0, 80)
    UiColor(1, 1, 1)
    return newValue
end

-- Slider with value display
function PcombSettings.UiSliderWithValue(image, width, height, current, min, max, fmt)
    fmt = fmt or "%.2f"
    UiPush()

    -- Ensure min/max
    local minv = min or 0
    local maxv = max or 1
    if maxv == minv then
        UiPop()
        return current
    end

    -- Clamp current to [min,max]
    local cur = current
    if cur < minv then cur = minv end
    if cur > maxv then cur = maxv end

    -- Map value -> pixel position
    local span = maxv - minv
    local normalized = (cur - minv) / span
    local pixelCurrent = normalized * width

    -- Call UiSlider
    local newPixel = UiSlider(image, "x", pixelCurrent, 0, width)
    local newNormalized = newPixel / width
    local newVal = minv + newNormalized * span

    -- Round to nearest integer if needed
    if math.floor(minv) == minv and math.floor(maxv) == maxv and math.floor(current) == current then
        newVal = math.floor(newVal + 0.5)
    end

    -- Draw numeric value
    UiTranslate(width + 12, -6)
    UiFont("regular.ttf", 16)
    UiColor(1, 1, 1)
    UiText(string.format(fmt, newVal))
    UiPop()
    return newVal
end

-- Tab drawing functions (shared between both menus)

function PcombSettings.drawGlobalTab()
    UiAlign("left top")
    UiFont("regular.ttf", 18)

    -- Master switch
    PcombSettings.UiBoolOption("Enable Physics Combination Mod", "savegame.mod.pcomb.global.enabled")

    -- Debug mode
    PcombSettings.UiBoolOption("Debug Mode", "savegame.mod.pcomb.global.debug")

    -- Performance priority
    UiTranslate(0, 20)
    UiText("Performance Priority (1=Performance, 2=Quality, 3=Maximum)")
    UiTranslate(0, 25)
    local priority = PcombSettings.get("savegame.mod.pcomb.global.priority")
    local newPriority = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, priority, 1, 3, "%.0f")
    if newPriority ~= priority then
        PcombSettings.set("savegame.mod.pcomb.global.priority", newPriority)
    end
    UiTranslate(0, 30)

    -- Conversion size threshold
    UiText("Conversion Size Threshold")
    UiTranslate(0, 25)
    local sizeThreshold = PcombSettings.get("savegame.mod.pcomb.conversion.size_threshold")
    local newSizeThreshold = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, sizeThreshold * 10, 1, 50, "%.1f") / 10
    if newSizeThreshold ~= sizeThreshold then
        PcombSettings.set("savegame.mod.pcomb.conversion.size_threshold", newSizeThreshold)
    end
    UiTranslate(0, 30)

    -- System enables
    PcombSettings.UiBoolOption("Enable PRGD System", "savegame.mod.pcomb.prgd.enabled")
    PcombSettings.UiBoolOption("Enable IBSIT System", "savegame.mod.pcomb.ibsit.enabled")
    PcombSettings.UiBoolOption("Enable MBCS System", "savegame.mod.pcomb.mbcs.enabled")
end

function PcombSettings.drawPRGDCoreTab()
    UiAlign("left top")
    UiFont("regular.ttf", 18)

    -- Core features
    PcombSettings.UiBoolOption("Crumbling Effects", "savegame.mod.pcomb.prgd.crumble")
    PcombSettings.UiBoolOption("Dust Particles", "savegame.mod.pcomb.prgd.dust")
    PcombSettings.UiBoolOption("Enhanced Explosions", "savegame.mod.pcomb.prgd.explosions")
    PcombSettings.UiBoolOption("Force System", "savegame.mod.pcomb.prgd.force")
    PcombSettings.UiBoolOption("Fire Effects", "savegame.mod.pcomb.prgd.fire")
    PcombSettings.UiBoolOption("Physics Violence", "savegame.mod.pcomb.prgd.violence")
    PcombSettings.UiBoolOption("Joint Breaking", "savegame.mod.pcomb.prgd.joints")

    -- Damage multipliers
    UiTranslate(0, 20)
    UiText("Light Material Damage Multiplier (%)")
    UiTranslate(0, 25)
    local lightDamage = PcombSettings.get("savegame.mod.pcomb.prgd.damage_light")
    local newLightDamage = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, lightDamage, 0, 200, "%.0f")
    if newLightDamage ~= lightDamage then
        PcombSettings.set("savegame.mod.pcomb.prgd.damage_light", newLightDamage)
    end
    UiTranslate(0, 30)

    UiText("Medium Material Damage Multiplier (%)")
    UiTranslate(0, 25)
    local mediumDamage = PcombSettings.get("savegame.mod.pcomb.prgd.damage_medium")
    local newMediumDamage = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, mediumDamage, 0, 200, "%.0f")
    if newMediumDamage ~= mediumDamage then
        PcombSettings.set("savegame.mod.pcomb.prgd.damage_medium", newMediumDamage)
    end
    UiTranslate(0, 30)

    UiText("Heavy Material Damage Multiplier (%)")
    UiTranslate(0, 25)
    local heavyDamage = PcombSettings.get("savegame.mod.pcomb.prgd.damage_heavy")
    local newHeavyDamage = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, heavyDamage, 0, 200, "%.0f")
    if newHeavyDamage ~= heavyDamage then
        PcombSettings.set("savegame.mod.pcomb.prgd.damage_heavy", newHeavyDamage)
    end
    UiTranslate(0, 30)
end

function PcombSettings.drawPRGDAdvancedTab()
    UiAlign("left top")
    UiFont("regular.ttf", 18)

    -- Performance controls
    PcombSettings.UiBoolOption("FPS Control", "savegame.mod.pcomb.prgd.fps_control")
    PcombSettings.UiBoolOption("Small Debris Filter", "savegame.mod.pcomb.prgd.sdf")
    PcombSettings.UiBoolOption("Low FPS Filter", "savegame.mod.pcomb.prgd.lff")
    PcombSettings.UiBoolOption("Distance Based Filter", "savegame.mod.pcomb.prgd.dbf")

    -- FPS target
    UiTranslate(0, 20)
    UiText("Target FPS")
    UiTranslate(0, 25)
    local fpsTarget = PcombSettings.get("savegame.mod.pcomb.prgd.fps_target")
    local newFpsTarget = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, fpsTarget, 15, 60, "%.0f")
    if newFpsTarget ~= fpsTarget then
        PcombSettings.set("savegame.mod.pcomb.prgd.fps_target", newFpsTarget)
    end
    UiTranslate(0, 30)

    -- Crumbling settings
    UiText("Crumble Size")
    UiTranslate(0, 25)
    local crumbleSize = PcombSettings.get("savegame.mod.pcomb.prgd.crumble_size")
    local newCrumbleSize = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, crumbleSize, 1, 20, "%.0f")
    if newCrumbleSize ~= crumbleSize then
        PcombSettings.set("savegame.mod.pcomb.prgd.crumble_size", newCrumbleSize)
    end
    UiTranslate(0, 30)

    UiText("Crumble Speed")
    UiTranslate(0, 25)
    local crumbleSpeed = PcombSettings.get("savegame.mod.pcomb.prgd.crumble_speed")
    local newCrumbleSpeed = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, crumbleSpeed, 1, 10, "%.0f")
    if newCrumbleSpeed ~= crumbleSpeed then
        PcombSettings.set("savegame.mod.pcomb.prgd.crumble_speed", newCrumbleSpeed)
    end
    UiTranslate(0, 30)

    -- Dust settings
    UiText("Dust Amount")
    UiTranslate(0, 25)
    local dustAmount = PcombSettings.get("savegame.mod.pcomb.prgd.dust_amount")
    local newDustAmount = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, dustAmount, 0, 100, "%.0f")
    if newDustAmount ~= dustAmount then
        PcombSettings.set("savegame.mod.pcomb.prgd.dust_amount", newDustAmount)
    end
    UiTranslate(0, 30)

    UiText("Dust Size")
    UiTranslate(0, 25)
    local dustSize = PcombSettings.get("savegame.mod.pcomb.prgd.dust_size")
    local newDustSize = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, dustSize, 1, 10, "%.0f")
    if newDustSize ~= dustSize then
        PcombSettings.set("savegame.mod.pcomb.prgd.dust_size", newDustSize)
    end
    UiTranslate(0, 30)

    UiText("Dust Lifetime")
    UiTranslate(0, 25)
    local dustLife = PcombSettings.get("savegame.mod.pcomb.prgd.dust_life")
    local newDustLife = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, dustLife, 1, 20, "%.0f")
    if newDustLife ~= dustLife then
        PcombSettings.set("savegame.mod.pcomb.prgd.dust_life", newDustLife)
    end
    UiTranslate(0, 30)

    UiText("Dust Gravity")
    UiTranslate(0, 25)
    local dustGravity = PcombSettings.get("savegame.mod.pcomb.prgd.dust_gravity")
    local newDustGravity = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, dustGravity * 100, -200, 200, "%.2f") / 100
    if newDustGravity ~= dustGravity then
        PcombSettings.set("savegame.mod.pcomb.prgd.dust_gravity", newDustGravity)
    end
    UiTranslate(0, 30)

    UiText("Dust Air Resistance")
    UiTranslate(0, 25)
    local dustDrag = PcombSettings.get("savegame.mod.pcomb.prgd.dust_drag")
    local newDustDrag = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, dustDrag * 100, 0, 100, "%.2f") / 100
    if newDustDrag ~= dustDrag then
        PcombSettings.set("savegame.mod.pcomb.prgd.dust_drag", newDustDrag)
    end
    UiTranslate(0, 30)
end

function PcombSettings.drawIBSITCoreTab()
    UiAlign("left top")
    UiFont("regular.ttf", 18)

    -- Core features
    PcombSettings.UiBoolOption("Particle Effects", "savegame.mod.pcomb.ibsit.particles")
    PcombSettings.UiBoolOption("Sound Effects", "savegame.mod.pcomb.ibsit.sounds")
    PcombSettings.UiBoolOption("Haptic Feedback", "savegame.mod.pcomb.ibsit.haptic")
    PcombSettings.UiBoolOption("Vehicle Integrity", "savegame.mod.pcomb.ibsit.vehicles")
    PcombSettings.UiBoolOption("Joint Analysis", "savegame.mod.pcomb.ibsit.joints")
    PcombSettings.UiBoolOption("Player Protection", "savegame.mod.pcomb.ibsit.protection")

    -- Damage multipliers
    UiTranslate(0, 20)
    UiText("Wood Damage Multiplier (%)")
    UiTranslate(0, 25)
    local woodDamage = PcombSettings.get("savegame.mod.pcomb.ibsit.wood_damage")
    local newWoodDamage = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, woodDamage, 10, 300, "%.0f")
    if newWoodDamage ~= woodDamage then
        PcombSettings.set("savegame.mod.pcomb.ibsit.wood_damage", newWoodDamage)
    end
    UiTranslate(0, 30)

    UiText("Stone Damage Multiplier (%)")
    UiTranslate(0, 25)
    local stoneDamage = PcombSettings.get("savegame.mod.pcomb.ibsit.stone_damage")
    local newStoneDamage = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, stoneDamage, 10, 300, "%.0f")
    if newStoneDamage ~= stoneDamage then
        PcombSettings.set("savegame.mod.pcomb.ibsit.stone_damage", newStoneDamage)
    end
    UiTranslate(0, 30)

    UiText("Metal Damage Multiplier (%)")
    UiTranslate(0, 25)
    local metalDamage = PcombSettings.get("savegame.mod.pcomb.ibsit.metal_damage")
    local newMetalDamage = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, metalDamage, 10, 300, "%.0f")
    if newMetalDamage ~= metalDamage then
        PcombSettings.set("savegame.mod.pcomb.ibsit.metal_damage", newMetalDamage)
    end
    UiTranslate(0, 30)

    -- Momentum threshold
    UiText("Momentum Threshold (2^value)")
    UiTranslate(0, 25)
    local momentumThreshold = PcombSettings.get("savegame.mod.pcomb.ibsit.momentum_threshold")
    local newMomentumThreshold = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, momentumThreshold, 1, 20, "%.0f")
    if newMomentumThreshold ~= momentumThreshold then
        PcombSettings.set("savegame.mod.pcomb.ibsit.momentum_threshold", newMomentumThreshold)
    end
    UiTranslate(0, 30)
end

function PcombSettings.drawIBSITAdvancedTab()
    UiAlign("left top")
    UiFont("regular.ttf", 18)

    -- Advanced features
    PcombSettings.UiBoolOption("Gravity Collapse", "savegame.mod.pcomb.ibsit.gravity_collapse")
    PcombSettings.UiBoolOption("Debris Cleanup", "savegame.mod.pcomb.ibsit.debris_cleanup")
    PcombSettings.UiBoolOption("FPS Optimization", "savegame.mod.pcomb.ibsit.fps_optimization")

    -- Collapse settings
    UiTranslate(0, 20)
    UiText("Collapse Threshold")
    UiTranslate(0, 25)
    local collapseThreshold = PcombSettings.get("savegame.mod.pcomb.ibsit.collapse_threshold")
    local newCollapseThreshold = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, collapseThreshold * 100, 1, 100, "%.2f") / 100
    if newCollapseThreshold ~= collapseThreshold then
        PcombSettings.set("savegame.mod.pcomb.ibsit.collapse_threshold", newCollapseThreshold)
    end
    UiTranslate(0, 30)

    UiText("Gravity Force Multiplier")
    UiTranslate(0, 25)
    local gravityForce = PcombSettings.get("savegame.mod.pcomb.ibsit.gravity_force")
    local newGravityForce = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, gravityForce * 10, 5, 50, "%.2f") / 10
    if newGravityForce ~= gravityForce then
        PcombSettings.set("savegame.mod.pcomb.ibsit.gravity_force", newGravityForce)
    end
    UiTranslate(0, 30)

    -- Cleanup settings
    UiText("Cleanup Delay (seconds)")
    UiTranslate(0, 25)
    local cleanupDelay = PcombSettings.get("savegame.mod.pcomb.ibsit.cleanup_delay")
    local newCleanupDelay = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, cleanupDelay, 5, 120, "%.0f")
    if newCleanupDelay ~= cleanupDelay then
        PcombSettings.set("savegame.mod.pcomb.ibsit.cleanup_delay", newCleanupDelay)
    end
    UiTranslate(0, 30)

    -- Performance settings
    UiText("Target FPS")
    UiTranslate(0, 25)
    local targetFps = PcombSettings.get("savegame.mod.pcomb.ibsit.target_fps")
    local newTargetFps = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, targetFps, 15, 60, "%.0f")
    if newTargetFps ~= targetFps then
        PcombSettings.set("savegame.mod.pcomb.ibsit.target_fps", newTargetFps)
    end
    UiTranslate(0, 30)

    -- Audio settings
    UiText("Sound Volume")
    UiTranslate(0, 25)
    local volume = PcombSettings.get("savegame.mod.pcomb.ibsit.volume")
    local newVolume = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, volume * 100, 0, 100, "%.2f") / 100
    if newVolume ~= volume then
        PcombSettings.set("savegame.mod.pcomb.ibsit.volume", newVolume)
    end
    UiTranslate(0, 30)

    -- Particle settings
    UiText("Particle Quality")
    UiTranslate(0, 25)
    local particleQuality = PcombSettings.get("savegame.mod.pcomb.ibsit.particle_quality")
    local newParticleQuality = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, particleQuality, 1, 5, "%.0f")
    if newParticleQuality ~= particleQuality then
        PcombSettings.set("savegame.mod.pcomb.ibsit.particle_quality", newParticleQuality)
    end
    UiTranslate(0, 30)

    UiText("Particle Amount")
    UiTranslate(0, 25)
    local dustAmount = PcombSettings.get("savegame.mod.pcomb.ibsit.dust_amount")
    local newDustAmount = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, dustAmount, 0, 100, "%.0f")
    if newDustAmount ~= dustAmount then
        PcombSettings.set("savegame.mod.pcomb.ibsit.dust_amount", newDustAmount)
    end
    UiTranslate(0, 30)

    -- COM support margin slider
    UiText("COM Support Margin")
    UiTranslate(0, 25)
    local comMargin = PcombSettings.get("savegame.mod.pcomb.ibsit.com_margin")
    local newComMargin = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, comMargin * 100, 0, 30, "%.1f") / 100
    if newComMargin ~= comMargin then
        PcombSettings.set("savegame.mod.pcomb.ibsit.com_margin", newComMargin)
    end
    UiTranslate(0, 30)
end

function PcombSettings.drawMBCSTab()
    UiAlign("left top")
    UiFont("regular.ttf", 18)

    -- Core settings
    UiText("Mass Threshold (2^value)")
    UiTranslate(0, 25)
    local massThreshold = PcombSettings.get("savegame.mod.pcomb.mbcs.mass_threshold")
    local newMassThreshold = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, massThreshold, 1, 16, "%.0f")
    if newMassThreshold ~= massThreshold then
        PcombSettings.set("savegame.mod.pcomb.mbcs.mass_threshold", newMassThreshold)
    end
    UiTranslate(0, 30)

    UiText("Distance Threshold (meters)")
    UiTranslate(0, 25)
    local distanceThreshold = PcombSettings.get("savegame.mod.pcomb.mbcs.distance_threshold")
    local newDistanceThreshold = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, distanceThreshold, 1, 20, "%.0f")
    if newDistanceThreshold ~= distanceThreshold then
        PcombSettings.set("savegame.mod.pcomb.mbcs.distance_threshold", newDistanceThreshold)
    end
    UiTranslate(0, 30)

    -- Damage multipliers
    UiText("Wood Damage Multiplier (%)")
    UiTranslate(0, 25)
    local woodDamage = PcombSettings.get("savegame.mod.pcomb.mbcs.wood_damage")
    local newWoodDamage = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, woodDamage, 10, 300, "%.0f")
    if newWoodDamage ~= woodDamage then
        PcombSettings.set("savegame.mod.pcomb.mbcs.wood_damage", newWoodDamage)
    end
    UiTranslate(0, 30)

    UiText("Stone Damage Multiplier (%)")
    UiTranslate(0, 25)
    local stoneDamage = PcombSettings.get("savegame.mod.pcomb.mbcs.stone_damage")
    local newStoneDamage = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, stoneDamage, 10, 300, "%.0f")
    if newStoneDamage ~= stoneDamage then
        PcombSettings.set("savegame.mod.pcomb.mbcs.stone_damage", newStoneDamage)
    end
    UiTranslate(0, 30)

    UiText("Metal Damage Multiplier (%)")
    UiTranslate(0, 25)
    local metalDamage = PcombSettings.get("savegame.mod.pcomb.mbcs.metal_damage")
    local newMetalDamage = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, metalDamage, 10, 300, "%.0f")
    if newMetalDamage ~= metalDamage then
        PcombSettings.set("savegame.mod.pcomb.mbcs.metal_damage", newMetalDamage)
    end
    UiTranslate(0, 30)

    UiText("Particle Amount")
    UiTranslate(0, 25)
    local dustAmount = PcombSettings.get("savegame.mod.pcomb.mbcs.dust_amount")
    local newDustAmount = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, dustAmount, 0, 100, "%.0f")
    if newDustAmount ~= dustAmount then
        PcombSettings.set("savegame.mod.pcomb.mbcs.dust_amount", newDustAmount)
    end
    UiTranslate(0, 30)
end

function PcombSettings.drawPerformanceTab()
    UiAlign("left top")
    UiFont("regular.ttf", 18)

    -- Performance presets
    UiText("Quick Configuration Presets:")
    UiTranslate(0, 30)

    -- Performance Mode Button
    UiPush()
    UiColor(0.2, 0.6, 0.2)
    if UiTextButton("Performance Mode (45+ FPS)", 220, 30) then
        PcombSettings.set("savegame.mod.pcomb.global.priority", 1)
        PcombSettings.set("savegame.mod.pcomb.prgd.fps_target", 45)
        PcombSettings.set("savegame.mod.pcomb.prgd.sdf", true)
        PcombSettings.set("savegame.mod.pcomb.prgd.lff", true)
        PcombSettings.set("savegame.mod.pcomb.prgd.dust_amount", 15)
        PcombSettings.set("savegame.mod.pcomb.ibsit.target_fps", 45)
        PcombSettings.set("savegame.mod.pcomb.ibsit.particle_quality", 1)
        PcombSettings.set("savegame.mod.pcomb.ibsit.dust_amount", 25)
        PcombSettings.set("savegame.mod.pcomb.mbcs.dust_amount", 25)
    end
    UiPop()
    UiTranslate(240, 0)

    -- Quality Mode Button
    UiPush()
    UiColor(0.6, 0.6, 0.2)
    if UiTextButton("Quality Mode (30+ FPS)", 220, 30) then
        PcombSettings.set("savegame.mod.pcomb.global.priority", 2)
        PcombSettings.set("savegame.mod.pcomb.prgd.fps_target", 30)
        PcombSettings.set("savegame.mod.pcomb.prgd.sdf", true)
        PcombSettings.set("savegame.mod.pcomb.prgd.lff", false)
        PcombSettings.set("savegame.mod.pcomb.prgd.dust_amount", 25)
        PcombSettings.set("savegame.mod.pcomb.ibsit.target_fps", 30)
        PcombSettings.set("savegame.mod.pcomb.ibsit.particle_quality", 2)
        PcombSettings.set("savegame.mod.pcomb.ibsit.dust_amount", 50)
        PcombSettings.set("savegame.mod.pcomb.mbcs.dust_amount", 50)
    end
    UiPop()
    UiTranslate(-240, 40)

    -- Maximum Mode Button
    UiPush()
    UiColor(0.6, 0.2, 0.2)
    if UiTextButton("Maximum Mode (20+ FPS)", 220, 30) then
        PcombSettings.set("savegame.mod.pcomb.global.priority", 3)
        PcombSettings.set("savegame.mod.pcomb.prgd.fps_target", 20)
        PcombSettings.set("savegame.mod.pcomb.prgd.sdf", false)
        PcombSettings.set("savegame.mod.pcomb.prgd.lff", false)
        PcombSettings.set("savegame.mod.pcomb.prgd.dust_amount", 50)
        PcombSettings.set("savegame.mod.pcomb.ibsit.target_fps", 20)
        PcombSettings.set("savegame.mod.pcomb.ibsit.particle_quality", 5)
        PcombSettings.set("savegame.mod.pcomb.ibsit.dust_amount", 100)
        PcombSettings.set("savegame.mod.pcomb.mbcs.dust_amount", 100)
    end
    UiPop()
    UiTranslate(0, 60)

    -- Manual performance tuning
    UiText("Manual Performance Scale")
    UiTranslate(0, 25)
    local performanceScale = PcombSettings.get("savegame.mod.pcomb.global.performance_scale")
    local newPerformanceScale = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, performanceScale * 100, 10, 100, "%.2f") / 100
    if newPerformanceScale ~= performanceScale then
        PcombSettings.set("savegame.mod.pcomb.global.performance_scale", newPerformanceScale)
    end
    UiTranslate(0, 30)

    UiText("Current Performance Scale: " .. string.format("%.2f", performanceScale))
end

function PcombSettings.drawMaterialsTab()
    UiAlign("left top")
    UiFont("regular.ttf", 18)

    -- Material Properties Header
    UiText("Material-Specific Physics Properties")
    UiTranslate(0, 30)
    UiFont("regular.ttf", 14)
    UiColor(1, 1, 1)
    UiText("Adjust how different materials behave in physics calculations")
    UiTranslate(0, 40)

    -- Glass Materials
    UiFont("regular.ttf", 16)
    UiColor(0.8, 0.9, 1.0)
    UiText("Glass Materials")
    UiTranslate(0, 25)
    UiFont("regular.ttf", 14)
    UiColor(1, 1, 1)

    UiText("Glass Density Multiplier")
    UiTranslate(0, 25)
    local glassDensity = PcombSettings.get("savegame.mod.pcomb.materials.glass.density")
    local newGlassDensity = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, glassDensity, 1.0, 5.0, "%.2f")
    if newGlassDensity ~= glassDensity then
        PcombSettings.set("savegame.mod.pcomb.materials.glass.density", newGlassDensity)
    end
    UiTranslate(0, 30)

    UiText("Glass Collapse Resistance")
    UiTranslate(0, 25)
    local glassResistance = PcombSettings.get("savegame.mod.pcomb.materials.glass.collapse_resistance")
    local newGlassResistance = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, glassResistance * 100, 1, 50, "%.1f") / 100
    if newGlassResistance ~= glassResistance then
        PcombSettings.set("savegame.mod.pcomb.materials.glass.collapse_resistance", newGlassResistance)
    end
    UiTranslate(0, 40)

    -- Wood Materials
    UiFont("regular.ttf", 16)
    UiColor(0.9, 0.8, 0.6)
    UiText("Wood Materials")
    UiTranslate(0, 25)
    UiFont("regular.ttf", 14)
    UiColor(1, 1, 1)

    UiText("Wood Density Multiplier")
    UiTranslate(0, 25)
    local woodDensity = PcombSettings.get("savegame.mod.pcomb.materials.wood.density")
    local newWoodDensity = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, woodDensity, 0.3, 1.2, "%.2f")
    if newWoodDensity ~= woodDensity then
        PcombSettings.set("savegame.mod.pcomb.materials.wood.density", newWoodDensity)
    end
    UiTranslate(0, 30)

    UiText("Wood Collapse Resistance")
    UiTranslate(0, 25)
    local woodResistance = PcombSettings.get("savegame.mod.pcomb.materials.wood.collapse_resistance")
    local newWoodResistance = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, woodResistance * 100, 20, 80, "%.1f") / 100
    if newWoodResistance ~= woodResistance then
        PcombSettings.set("savegame.mod.pcomb.materials.wood.collapse_resistance", newWoodResistance)
    end
    UiTranslate(0, 40)

    -- Stone/Concrete Materials
    UiFont("regular.ttf", 16)
    UiColor(0.7, 0.7, 0.7)
    UiText("Stone & Concrete Materials")
    UiTranslate(0, 25)
    UiFont("regular.ttf", 14)
    UiColor(1, 1, 1)

    UiText("Stone Density Multiplier")
    UiTranslate(0, 25)
    local stoneDensity = PcombSettings.get("savegame.mod.pcomb.materials.stone.density")
    local newStoneDensity = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, stoneDensity, 1.5, 4.0, "%.2f")
    if newStoneDensity ~= stoneDensity then
        PcombSettings.set("savegame.mod.pcomb.materials.stone.density", newStoneDensity)
    end
    UiTranslate(0, 30)

    UiText("Stone Collapse Resistance")
    UiTranslate(0, 25)
    local stoneResistance = PcombSettings.get("savegame.mod.pcomb.materials.stone.collapse_resistance")
    local newStoneResistance = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, stoneResistance * 100, 60, 95, "%.1f") / 100
    if newStoneResistance ~= stoneResistance then
        PcombSettings.set("savegame.mod.pcomb.materials.stone.collapse_resistance", newStoneResistance)
    end
    UiTranslate(0, 40)

    -- Metal Materials
    UiFont("regular.ttf", 16)
    UiColor(0.8, 0.8, 0.9)
    UiText("Metal Materials")
    UiTranslate(0, 25)
    UiFont("regular.ttf", 14)
    UiColor(1, 1, 1)

    UiText("Metal Density Multiplier")
    UiTranslate(0, 25)
    local metalDensity = PcombSettings.get("savegame.mod.pcomb.materials.metal.density")
    local newMetalDensity = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, metalDensity, 5.0, 10.0, "%.2f")
    if newMetalDensity ~= metalDensity then
        PcombSettings.set("savegame.mod.pcomb.materials.metal.density", newMetalDensity)
    end
    UiTranslate(0, 30)

    UiText("Metal Collapse Resistance")
    UiTranslate(0, 25)
    local metalResistance = PcombSettings.get("savegame.mod.pcomb.materials.metal.collapse_resistance")
    local newMetalResistance = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, metalResistance * 100, 90, 99, "%.1f") / 100
    if newMetalResistance ~= metalResistance then
        PcombSettings.set("savegame.mod.pcomb.materials.metal.collapse_resistance", newMetalResistance)
    end
    UiTranslate(0, 40)

    -- Material Interaction Settings
    UiFont("regular.ttf", 16)
    UiColor(1, 1, 0.8)
    UiText("Material Interaction")
    UiTranslate(0, 25)
    UiFont("regular.ttf", 14)
    UiColor(1, 1, 1)

    UiText("Material Compatibility Factor")
    UiTranslate(0, 25)
    local compatibility = PcombSettings.get("savegame.mod.pcomb.materials.compatibility_factor")
    local newCompatibility = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, compatibility * 100, 50, 150, "%.1f") / 100
    if newCompatibility ~= compatibility then
        PcombSettings.set("savegame.mod.pcomb.materials.compatibility_factor", newCompatibility)
    end
    UiTranslate(0, 30)

    UiText("Multi-Directional Analysis")
    UiTranslate(0, 25)

    -- Read current state
    local multiDir = PcombSettings.get("savegame.mod.pcomb.materials.multi_directional")
    local buttonClicked = false
    local newMultiDir = multiDir

    if multiDir then
        UiColor(0.2, 0.8, 0.2)
        if UiTextButton("Enabled") then
            buttonClicked = true
            newMultiDir = false
            PcombSettings.set("savegame.mod.pcomb.materials.multi_directional", newMultiDir)
        end
    else
        UiColor(0.8, 0.2, 0.2)
        if UiTextButton("Disabled") then
            buttonClicked = true
            newMultiDir = true
            PcombSettings.set("savegame.mod.pcomb.materials.multi_directional", newMultiDir)
        end
    end

    -- If button was clicked, provide immediate visual feedback
    if buttonClicked then
        UiTranslate(0, -25)
        UiText("Multi-Directional Analysis")
        UiTranslate(0, 25)

        if newMultiDir then
            UiColor(0.2, 0.8, 0.2)
            UiText("Enabled")
        else
            UiColor(0.8, 0.2, 0.2)
            UiText("Disabled")
        end
    end
    UiTranslate(0, 40)

    -- Impact Damage Settings
    UiFont("regular.ttf", 16)
    UiColor(1, 0.5, 0.5)
    UiText("Impact Damage System")
    UiTranslate(0, 25)
    UiFont("regular.ttf", 14)
    UiColor(1, 1, 1)

    UiText("Enable Impact Damage")
    UiTranslate(0, 25)

    -- Read current state
    local impactEnabled = PcombSettings.get("savegame.mod.pcomb.impact.enabled")
    local buttonClicked = false
    local newImpactEnabled = impactEnabled

    if impactEnabled then
        UiColor(0.2, 0.8, 0.2)
        if UiTextButton("Enabled") then
            buttonClicked = true
            newImpactEnabled = false
            PcombSettings.set("savegame.mod.pcomb.impact.enabled", newImpactEnabled)
        end
    else
        UiColor(0.8, 0.2, 0.2)
        if UiTextButton("Disabled") then
            buttonClicked = true
            newImpactEnabled = true
            PcombSettings.set("savegame.mod.pcomb.impact.enabled", newImpactEnabled)
        end
    end

    -- If button was clicked, provide immediate visual feedback
    if buttonClicked then
        UiTranslate(0, -25)
        UiText("Enable Impact Damage")
        UiTranslate(0, 25)

        if newImpactEnabled then
            UiColor(0.2, 0.8, 0.2)
            UiText("Enabled")
        else
            UiColor(0.8, 0.2, 0.2)
            UiText("Disabled")
        end
    end

    UiTranslate(0, 30)

    UiText("Impact Damage Multiplier")
    UiTranslate(0, 25)
    local impactMultiplier = PcombSettings.get("savegame.mod.pcomb.impact.multiplier")
    local newImpactMultiplier = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, impactMultiplier * 100, 10, 300, "%.1f") / 100
    if newImpactMultiplier ~= impactMultiplier then
        PcombSettings.set("savegame.mod.pcomb.impact.multiplier", newImpactMultiplier)
    end
    UiTranslate(0, 30)

    UiText("Impact Radius")
    UiTranslate(0, 25)
    local impactRadius = PcombSettings.get("savegame.mod.pcomb.impact.radius")
    local newImpactRadius = PcombSettings.UiSliderWithValue("ui/common/dot.png", 360, 20, impactRadius * 10, 5, 50, "%.1f") / 10
    if newImpactRadius ~= impactRadius then
        PcombSettings.set("savegame.mod.pcomb.impact.radius", newImpactRadius)
    end
    UiTranslate(0, 80)
    UiColor(1, 1, 1)
end