-- PHYSICS COMBINATION MOD - OPTIONS INTERFACE
-- Comprehensive options for Teardown mod manager
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
    if not HasKey("savegame.mod.pcomb.global.performance_scale") then
        SetFloat("savegame.mod.pcomb.global.performance_scale", 1.0)
    end

    -- PRGD defaults
    if not HasKey("savegame.mod.pcomb.prgd.enabled") then
        SetBool("savegame.mod.pcomb.prgd.enabled", true)
        SetBool("savegame.mod.pcomb.prgd.crumble", true)
        SetBool("savegame.mod.pcomb.prgd.dust", true)
        SetBool("savegame.mod.pcomb.prgd.explosions", false)
        SetBool("savegame.mod.pcomb.prgd.force", false)
        SetBool("savegame.mod.pcomb.prgd.fire", false)
        SetBool("savegame.mod.pcomb.prgd.violence", false)
        SetBool("savegame.mod.pcomb.prgd.joints", false)
        SetBool("savegame.mod.pcomb.prgd.fps_control", true)
        SetInt("savegame.mod.pcomb.prgd.fps_target", 30)
        SetBool("savegame.mod.pcomb.prgd.sdf", true)
        SetBool("savegame.mod.pcomb.prgd.lff", false)
        SetBool("savegame.mod.pcomb.prgd.dbf", false)
        SetInt("savegame.mod.pcomb.prgd.damage_light", 50)
        SetInt("savegame.mod.pcomb.prgd.damage_medium", 50)
        SetInt("savegame.mod.pcomb.prgd.damage_heavy", 50)
        SetInt("savegame.mod.pcomb.prgd.crumble_size", 8)
        SetInt("savegame.mod.pcomb.prgd.crumble_speed", 2)
        SetInt("savegame.mod.pcomb.prgd.dust_amount", 25)
        SetInt("savegame.mod.pcomb.prgd.dust_size", 2)
        SetInt("savegame.mod.pcomb.prgd.dust_life", 8)
        SetFloat("savegame.mod.pcomb.prgd.dust_gravity", 0.35)
        SetFloat("savegame.mod.pcomb.prgd.dust_drag", 0.15)
    end

    -- IBSIT defaults
    if not HasKey("savegame.mod.pcomb.ibsit.enabled") then
        SetBool("savegame.mod.pcomb.ibsit.enabled", true)
        SetBool("savegame.mod.pcomb.ibsit.particles", true)
        SetBool("savegame.mod.pcomb.ibsit.sounds", true)
        SetBool("savegame.mod.pcomb.ibsit.haptic", true)
        SetBool("savegame.mod.pcomb.ibsit.vehicles", false)
        SetBool("savegame.mod.pcomb.ibsit.joints", false)
        SetBool("savegame.mod.pcomb.ibsit.protection", false)
        SetInt("savegame.mod.pcomb.ibsit.dust_amount", 50)
        SetInt("savegame.mod.pcomb.ibsit.wood_damage", 100)
        SetInt("savegame.mod.pcomb.ibsit.stone_damage", 75)
        SetInt("savegame.mod.pcomb.ibsit.metal_damage", 50)
        SetInt("savegame.mod.pcomb.ibsit.momentum_threshold", 12)
        SetBool("savegame.mod.pcomb.ibsit.gravity_collapse", true)
        SetFloat("savegame.mod.pcomb.ibsit.collapse_threshold", 0.3)
        SetFloat("savegame.mod.pcomb.ibsit.gravity_force", 2.0)
        SetBool("savegame.mod.pcomb.ibsit.debris_cleanup", true)
        SetFloat("savegame.mod.pcomb.ibsit.cleanup_delay", 30.0)
        SetBool("savegame.mod.pcomb.ibsit.fps_optimization", true)
        SetInt("savegame.mod.pcomb.ibsit.target_fps", 30)
        SetFloat("savegame.mod.pcomb.ibsit.volume", 0.7)
        SetInt("savegame.mod.pcomb.ibsit.particle_quality", 2)
    end

    -- MBCS defaults
    if not HasKey("savegame.mod.pcomb.mbcs.enabled") then
        SetBool("savegame.mod.pcomb.mbcs.enabled", true)
        SetInt("savegame.mod.pcomb.mbcs.dust_amount", 50)
        SetInt("savegame.mod.pcomb.mbcs.wood_damage", 100)
        SetInt("savegame.mod.pcomb.mbcs.stone_damage", 75)
        SetInt("savegame.mod.pcomb.mbcs.metal_damage", 50)
        SetInt("savegame.mod.pcomb.mbcs.mass_threshold", 8)
        SetInt("savegame.mod.pcomb.mbcs.distance_threshold", 4)
    end
end

function draw()
    -- Title
    UiAlign("center middle")
    UiTranslate(UiCenter(), 30)
    UiFont("bold.ttf", 24)
    UiText("Physics Combination Mod Settings")
    UiTranslate(0, 40)

    -- Tab system
    UiAlign("left middle")
    UiTranslate(50, 0)
    UiFont("regular.ttf", 16)

    local tabs = {"Global", "PRGD Core", "PRGD Advanced", "IBSIT Core", "IBSIT Advanced", "MBCS", "Performance"}
    local currentTab = GetInt("savegame.mod.pcomb.current_tab") or 1

    -- Tab buttons (draw inside a push/pop so we don't disturb the layout origin)
    UiPush()
    for i, tabName in ipairs(tabs) do
        UiPush()
        if currentTab == i then
            UiColor(0.3, 0.6, 1.0)
        else
            UiColor(0.4, 0.4, 0.4)
        end

        if UiTextButton(tabName, 120, 30) then
            SetInt("savegame.mod.pcomb.current_tab", i)
            currentTab = i
        end
        UiPop()
        UiTranslate(130, 0)
    end
    UiPop()

    -- Move down for content area but keep horizontal origin unchanged
    UiTranslate(0, 50)

    -- Render selected tab content
    if currentTab == 1 then
        drawGlobalTab()
    elseif currentTab == 2 then
        drawPRGDCoreTab()
    elseif currentTab == 3 then
        drawPRGDAdvancedTab()
    elseif currentTab == 4 then
        drawIBSITCoreTab()
    elseif currentTab == 5 then
        drawIBSITAdvancedTab()
    elseif currentTab == 6 then
        drawMBCSTab()
    elseif currentTab == 7 then
        drawPerformanceTab()
    end
end

function drawGlobalTab()
    UiAlign("left top")
    UiFont("regular.ttf", 18)

    -- Master switch
    UiBoolOption("Enable Physics Combination Mod", "savegame.mod.pcomb.global.enabled", GetBool("savegame.mod.pcomb.global.enabled"))

    -- Debug mode
    UiBoolOption("Debug Mode", "savegame.mod.pcomb.global.debug", GetBool("savegame.mod.pcomb.global.debug"))

    -- Performance priority
    UiTranslate(0, 20)
    UiText("Performance Priority (1=Performance, 2=Quality, 3=Maximum)")
    UiTranslate(0, 25)
    local priority = GetInt("savegame.mod.pcomb.global.priority")
    local newPriority = UiSliderWithValue("ui/common/dot.png", 360, 20, priority, 1, 3, "%.0f")
    if newPriority ~= priority then
        SetInt("savegame.mod.pcomb.global.priority", newPriority)
    end
    UiTranslate(0, 30)

    -- System enables
    UiBoolOption("Enable PRGD System", "savegame.mod.pcomb.prgd.enabled", GetBool("savegame.mod.pcomb.prgd.enabled"))
    UiBoolOption("Enable IBSIT System", "savegame.mod.pcomb.ibsit.enabled", GetBool("savegame.mod.pcomb.ibsit.enabled"))
    UiBoolOption("Enable MBCS System", "savegame.mod.pcomb.mbcs.enabled", GetBool("savegame.mod.pcomb.mbcs.enabled"))
end

function drawPRGDCoreTab()
    UiAlign("left top")
    UiFont("regular.ttf", 18)

    -- Core features
    UiBoolOption("Crumbling Effects", "savegame.mod.pcomb.prgd.crumble", GetBool("savegame.mod.pcomb.prgd.crumble"))
    UiBoolOption("Dust Particles", "savegame.mod.pcomb.prgd.dust", GetBool("savegame.mod.pcomb.prgd.dust"))
    UiBoolOption("Enhanced Explosions", "savegame.mod.pcomb.prgd.explosions", GetBool("savegame.mod.pcomb.prgd.explosions"))
    UiBoolOption("Force System", "savegame.mod.pcomb.prgd.force", GetBool("savegame.mod.pcomb.prgd.force"))
    UiBoolOption("Fire Effects", "savegame.mod.pcomb.prgd.fire", GetBool("savegame.mod.pcomb.prgd.fire"))
    UiBoolOption("Physics Violence", "savegame.mod.pcomb.prgd.violence", GetBool("savegame.mod.pcomb.prgd.violence"))
    UiBoolOption("Joint Breaking", "savegame.mod.pcomb.prgd.joints", GetBool("savegame.mod.pcomb.prgd.joints"))

    -- Damage multipliers
    UiTranslate(0, 20)
    UiText("Light Material Damage Multiplier (%)")
    UiTranslate(0, 25)
    local lightDamage = GetInt("savegame.mod.pcomb.prgd.damage_light")
    local newLightDamage = UiSliderWithValue("ui/common/dot.png", 360, 20, lightDamage, 0, 200, "%.0f")
    if newLightDamage ~= lightDamage then
        SetInt("savegame.mod.pcomb.prgd.damage_light", newLightDamage)
    end
    UiTranslate(0, 30)

    UiText("Medium Material Damage Multiplier (%)")
    UiTranslate(0, 25)
    local mediumDamage = GetInt("savegame.mod.pcomb.prgd.damage_medium")
    local newMediumDamage = UiSliderWithValue("ui/common/dot.png", 360, 20, mediumDamage, 0, 200, "%.0f")
    if newMediumDamage ~= mediumDamage then
        SetInt("savegame.mod.pcomb.prgd.damage_medium", newMediumDamage)
    end
    UiTranslate(0, 30)

    UiText("Heavy Material Damage Multiplier (%)")
    UiTranslate(0, 25)
    local heavyDamage = GetInt("savegame.mod.pcomb.prgd.damage_heavy")
    local newHeavyDamage = UiSliderWithValue("ui/common/dot.png", 360, 20, heavyDamage, 0, 200, "%.0f")
    if newHeavyDamage ~= heavyDamage then
        SetInt("savegame.mod.pcomb.prgd.damage_heavy", newHeavyDamage)
    end
    UiTranslate(0, 30)
end

function drawPRGDAdvancedTab()
    UiAlign("left top")
    UiFont("regular.ttf", 18)

    -- Performance controls
    UiBoolOption("FPS Control", "savegame.mod.pcomb.prgd.fps_control", GetBool("savegame.mod.pcomb.prgd.fps_control"))
    UiBoolOption("Small Debris Filter", "savegame.mod.pcomb.prgd.sdf", GetBool("savegame.mod.pcomb.prgd.sdf"))
    UiBoolOption("Low FPS Filter", "savegame.mod.pcomb.prgd.lff", GetBool("savegame.mod.pcomb.prgd.lff"))
    UiBoolOption("Distance Based Filter", "savegame.mod.pcomb.prgd.dbf", GetBool("savegame.mod.pcomb.prgd.dbf"))

    -- FPS target
    UiTranslate(0, 20)
    UiText("Target FPS")
    UiTranslate(0, 25)
    local fpsTarget = GetInt("savegame.mod.pcomb.prgd.fps_target")
    local newFpsTarget = UiSliderWithValue("ui/common/dot.png", 360, 20, fpsTarget, 15, 60, "%.0f")
    if newFpsTarget ~= fpsTarget then
        SetInt("savegame.mod.pcomb.prgd.fps_target", newFpsTarget)
    end
    UiTranslate(0, 30)

    -- Crumbling settings
    UiText("Crumble Size")
    UiTranslate(0, 25)
    local crumbleSize = GetInt("savegame.mod.pcomb.prgd.crumble_size")
    local newCrumbleSize = UiSliderWithValue("ui/common/dot.png", 360, 20, crumbleSize, 1, 20, "%.0f")
    if newCrumbleSize ~= crumbleSize then
        SetInt("savegame.mod.pcomb.prgd.crumble_size", newCrumbleSize)
    end
    UiTranslate(0, 30)

    UiText("Crumble Speed")
    UiTranslate(0, 25)
    local crumbleSpeed = GetInt("savegame.mod.pcomb.prgd.crumble_speed")
    local newCrumbleSpeed = UiSliderWithValue("ui/common/dot.png", 360, 20, crumbleSpeed, 1, 10, "%.0f")
    if newCrumbleSpeed ~= crumbleSpeed then
        SetInt("savegame.mod.pcomb.prgd.crumble_speed", newCrumbleSpeed)
    end
    UiTranslate(0, 30)

    -- Dust settings
    UiText("Dust Amount")
    UiTranslate(0, 25)
    local dustAmount = GetInt("savegame.mod.pcomb.prgd.dust_amount")
    local newDustAmount = UiSliderWithValue("ui/common/dot.png", 360, 20, dustAmount, 0, 100, "%.0f")
    if newDustAmount ~= dustAmount then
        SetInt("savegame.mod.pcomb.prgd.dust_amount", newDustAmount)
    end
    UiTranslate(0, 30)

    UiText("Dust Size")
    UiTranslate(0, 25)
    local dustSize = GetInt("savegame.mod.pcomb.prgd.dust_size")
    local newDustSize = UiSliderWithValue("ui/common/dot.png", 360, 20, dustSize, 1, 10, "%.0f")
    if newDustSize ~= dustSize then
        SetInt("savegame.mod.pcomb.prgd.dust_size", newDustSize)
    end
    UiTranslate(0, 30)

    UiText("Dust Lifetime")
    UiTranslate(0, 25)
    local dustLife = GetInt("savegame.mod.pcomb.prgd.dust_life")
    local newDustLife = UiSliderWithValue("ui/common/dot.png", 360, 20, dustLife, 1, 20, "%.0f")
    if newDustLife ~= dustLife then
        SetInt("savegame.mod.pcomb.prgd.dust_life", newDustLife)
    end
    UiTranslate(0, 30)

    UiText("Dust Gravity")
    UiTranslate(0, 25)
    local dustGravity = GetFloat("savegame.mod.pcomb.prgd.dust_gravity")
    local newDustGravity = UiSliderWithValue("ui/common/dot.png", 360, 20, dustGravity * 100, -200, 200, "%.2f") / 100
    if newDustGravity ~= dustGravity then
        SetFloat("savegame.mod.pcomb.prgd.dust_gravity", newDustGravity)
    end
    UiTranslate(0, 30)

    UiText("Dust Air Resistance")
    UiTranslate(0, 25)
    local dustDrag = GetFloat("savegame.mod.pcomb.prgd.dust_drag")
    local newDustDrag = UiSliderWithValue("ui/common/dot.png", 360, 20, dustDrag * 100, 0, 100, "%.2f") / 100
    if newDustDrag ~= dustDrag then
        SetFloat("savegame.mod.pcomb.prgd.dust_drag", newDustDrag)
    end
    UiTranslate(0, 30)
end

function drawIBSITCoreTab()
    UiAlign("left top")
    UiFont("regular.ttf", 18)

    -- Core features
    UiBoolOption("Particle Effects", "savegame.mod.pcomb.ibsit.particles", GetBool("savegame.mod.pcomb.ibsit.particles"))
    UiBoolOption("Sound Effects", "savegame.mod.pcomb.ibsit.sounds", GetBool("savegame.mod.pcomb.ibsit.sounds"))
    UiBoolOption("Haptic Feedback", "savegame.mod.pcomb.ibsit.haptic", GetBool("savegame.mod.pcomb.ibsit.haptic"))
    UiBoolOption("Vehicle Integrity", "savegame.mod.pcomb.ibsit.vehicles", GetBool("savegame.mod.pcomb.ibsit.vehicles"))
    UiBoolOption("Joint Analysis", "savegame.mod.pcomb.ibsit.joints", GetBool("savegame.mod.pcomb.ibsit.joints"))
    UiBoolOption("Player Protection", "savegame.mod.pcomb.ibsit.protection", GetBool("savegame.mod.pcomb.ibsit.protection"))

    -- Damage multipliers
    UiTranslate(0, 20)
    UiText("Wood Damage Multiplier (%)")
    UiTranslate(0, 25)
    local woodDamage = GetInt("savegame.mod.pcomb.ibsit.wood_damage")
    local newWoodDamage = UiSliderWithValue("ui/common/dot.png", 360, 20, woodDamage, 10, 300, "%.0f")
    if newWoodDamage ~= woodDamage then
        SetInt("savegame.mod.pcomb.ibsit.wood_damage", newWoodDamage)
    end
    UiTranslate(0, 30)

    UiText("Stone Damage Multiplier (%)")
    UiTranslate(0, 25)
    local stoneDamage = GetInt("savegame.mod.pcomb.ibsit.stone_damage")
    local newStoneDamage = UiSliderWithValue("ui/common/dot.png", 360, 20, stoneDamage, 10, 300, "%.0f")
    if newStoneDamage ~= stoneDamage then
        SetInt("savegame.mod.pcomb.ibsit.stone_damage", newStoneDamage)
    end
    UiTranslate(0, 30)

    UiText("Metal Damage Multiplier (%)")
    UiTranslate(0, 25)
    local metalDamage = GetInt("savegame.mod.pcomb.ibsit.metal_damage")
    local newMetalDamage = UiSliderWithValue("ui/common/dot.png", 360, 20, metalDamage, 10, 300, "%.0f")
    if newMetalDamage ~= metalDamage then
        SetInt("savegame.mod.pcomb.ibsit.metal_damage", newMetalDamage)
    end
    UiTranslate(0, 30)

    -- Momentum threshold
    UiText("Momentum Threshold (2^value)")
    UiTranslate(0, 25)
    local momentumThreshold = GetInt("savegame.mod.pcomb.ibsit.momentum_threshold")
    local newMomentumThreshold = UiSliderWithValue("ui/common/dot.png", 360, 20, momentumThreshold, 8, 20, "%.0f")
    if newMomentumThreshold ~= momentumThreshold then
        SetInt("savegame.mod.pcomb.ibsit.momentum_threshold", newMomentumThreshold)
    end
    UiTranslate(0, 30)
end

function drawIBSITAdvancedTab()
    UiAlign("left top")
    UiFont("regular.ttf", 18)

    -- Advanced features
    UiBoolOption("Gravity Collapse", "savegame.mod.pcomb.ibsit.gravity_collapse", GetBool("savegame.mod.pcomb.ibsit.gravity_collapse"))
    UiBoolOption("Debris Cleanup", "savegame.mod.pcomb.ibsit.debris_cleanup", GetBool("savegame.mod.pcomb.ibsit.debris_cleanup"))
    UiBoolOption("FPS Optimization", "savegame.mod.pcomb.ibsit.fps_optimization", GetBool("savegame.mod.pcomb.ibsit.fps_optimization"))

    -- Collapse settings
    UiTranslate(0, 20)
    UiText("Collapse Threshold")
    UiTranslate(0, 25)
    local collapseThreshold = GetFloat("savegame.mod.pcomb.ibsit.collapse_threshold")
    local newCollapseThreshold = UiSliderWithValue("ui/common/dot.png", 360, 20, collapseThreshold * 100, 10, 100, "%.2f") / 100
    if newCollapseThreshold ~= collapseThreshold then
        SetFloat("savegame.mod.pcomb.ibsit.collapse_threshold", newCollapseThreshold)
    end
    UiTranslate(0, 30)

    UiText("Gravity Force Multiplier")
    UiTranslate(0, 25)
    local gravityForce = GetFloat("savegame.mod.pcomb.ibsit.gravity_force")
    local newGravityForce = UiSliderWithValue("ui/common/dot.png", 360, 20, gravityForce * 10, 5, 50, "%.2f") / 10
    if newGravityForce ~= gravityForce then
        SetFloat("savegame.mod.pcomb.ibsit.gravity_force", newGravityForce)
    end
    UiTranslate(0, 30)

    -- Cleanup settings
    UiText("Cleanup Delay (seconds)")
    UiTranslate(0, 25)
    local cleanupDelay = GetFloat("savegame.mod.pcomb.ibsit.cleanup_delay")
    local newCleanupDelay = UiSliderWithValue("ui/common/dot.png", 360, 20, cleanupDelay, 5, 120, "%.0f")
    if newCleanupDelay ~= cleanupDelay then
        SetFloat("savegame.mod.pcomb.ibsit.cleanup_delay", newCleanupDelay)
    end
    UiTranslate(0, 30)

    -- Performance settings
    UiText("Target FPS")
    UiTranslate(0, 25)
    local targetFps = GetInt("savegame.mod.pcomb.ibsit.target_fps")
    local newTargetFps = UiSliderWithValue("ui/common/dot.png", 360, 20, targetFps, 15, 60, "%.0f")
    if newTargetFps ~= targetFps then
        SetInt("savegame.mod.pcomb.ibsit.target_fps", newTargetFps)
    end
    UiTranslate(0, 30)

    -- Audio settings
    UiText("Sound Volume")
    UiTranslate(0, 25)
    local volume = GetFloat("savegame.mod.pcomb.ibsit.volume")
    local newVolume = UiSliderWithValue("ui/common/dot.png", 360, 20, volume * 100, 0, 100, "%.2f") / 100
    if newVolume ~= volume then
        SetFloat("savegame.mod.pcomb.ibsit.volume", newVolume)
    end
    UiTranslate(0, 30)

    -- Particle settings
    UiText("Particle Quality")
    UiTranslate(0, 25)
    local particleQuality = GetInt("savegame.mod.pcomb.ibsit.particle_quality")
    local newParticleQuality = UiSliderWithValue("ui/common/dot.png", 360, 20, particleQuality, 1, 5, "%.0f")
    if newParticleQuality ~= particleQuality then
        SetInt("savegame.mod.pcomb.ibsit.particle_quality", newParticleQuality)
    end
    UiTranslate(0, 30)

    UiText("Particle Amount")
    UiTranslate(0, 25)
    local dustAmount = GetInt("savegame.mod.pcomb.ibsit.dust_amount")
    local newDustAmount = UiSliderWithValue("ui/common/dot.png", 360, 20, dustAmount, 0, 100, "%.0f")
    if newDustAmount ~= dustAmount then
        SetInt("savegame.mod.pcomb.ibsit.dust_amount", newDustAmount)
    end
    UiTranslate(0, 30)
end

function drawMBCSTab()
    UiAlign("left top")
    UiFont("regular.ttf", 18)

    -- Core settings
    UiText("Mass Threshold (2^value)")
    UiTranslate(0, 25)
    local massThreshold = GetInt("savegame.mod.pcomb.mbcs.mass_threshold")
    local newMassThreshold = UiSliderWithValue("ui/common/dot.png", 360, 20, massThreshold, 4, 16, "%.0f")
    if newMassThreshold ~= massThreshold then
        SetInt("savegame.mod.pcomb.mbcs.mass_threshold", newMassThreshold)
    end
    UiTranslate(0, 30)

    UiText("Distance Threshold (meters)")
    UiTranslate(0, 25)
    local distanceThreshold = GetInt("savegame.mod.pcomb.mbcs.distance_threshold")
    local newDistanceThreshold = UiSliderWithValue("ui/common/dot.png", 360, 20, distanceThreshold, 1, 20, "%.0f")
    if newDistanceThreshold ~= distanceThreshold then
        SetInt("savegame.mod.pcomb.mbcs.distance_threshold", newDistanceThreshold)
    end
    UiTranslate(0, 30)

    -- Damage multipliers
    UiText("Wood Damage Multiplier (%)")
    UiTranslate(0, 25)
    local woodDamage = GetInt("savegame.mod.pcomb.mbcs.wood_damage")
    local newWoodDamage = UiSliderWithValue("ui/common/dot.png", 360, 20, woodDamage, 10, 300, "%.0f")
    if newWoodDamage ~= woodDamage then
        SetInt("savegame.mod.pcomb.mbcs.wood_damage", newWoodDamage)
    end
    UiTranslate(0, 30)

    UiText("Stone Damage Multiplier (%)")
    UiTranslate(0, 25)
    local stoneDamage = GetInt("savegame.mod.pcomb.mbcs.stone_damage")
    local newStoneDamage = UiSliderWithValue("ui/common/dot.png", 360, 20, stoneDamage, 10, 300, "%.0f")
    if newStoneDamage ~= stoneDamage then
        SetInt("savegame.mod.pcomb.mbcs.stone_damage", newStoneDamage)
    end
    UiTranslate(0, 30)

    UiText("Metal Damage Multiplier (%)")
    UiTranslate(0, 25)
    local metalDamage = GetInt("savegame.mod.pcomb.mbcs.metal_damage")
    local newMetalDamage = UiSliderWithValue("ui/common/dot.png", 360, 20, metalDamage, 10, 300, "%.0f")
    if newMetalDamage ~= metalDamage then
        SetInt("savegame.mod.pcomb.mbcs.metal_damage", newMetalDamage)
    end
    UiTranslate(0, 30)

    UiText("Particle Amount")
    UiTranslate(0, 25)
    local dustAmount = GetInt("savegame.mod.pcomb.mbcs.dust_amount")
    local newDustAmount = UiSliderWithValue("ui/common/dot.png", 360, 20, dustAmount, 0, 100, "%.0f")
    if newDustAmount ~= dustAmount then
        SetInt("savegame.mod.pcomb.mbcs.dust_amount", newDustAmount)
    end
    UiTranslate(0, 30)
end

function drawPerformanceTab()
    UiAlign("left top")
    UiFont("regular.ttf", 18)

    -- Performance presets
    UiText("Quick Configuration Presets:")
    UiTranslate(0, 30)

    -- Performance Mode Button
    UiPush()
    UiColor(0.2, 0.6, 0.2)
    if UiTextButton("Performance Mode (45+ FPS)", 220, 30) then
        SetInt("savegame.mod.pcomb.global.priority", 1)
        SetInt("savegame.mod.pcomb.prgd.fps_target", 45)
        SetBool("savegame.mod.pcomb.prgd.sdf", true)
        SetBool("savegame.mod.pcomb.prgd.lff", true)
        SetInt("savegame.mod.pcomb.prgd.dust_amount", 15)
        SetInt("savegame.mod.pcomb.ibsit.target_fps", 45)
        SetInt("savegame.mod.pcomb.ibsit.particle_quality", 1)
        SetInt("savegame.mod.pcomb.ibsit.dust_amount", 25)
        SetInt("savegame.mod.pcomb.mbcs.dust_amount", 25)
    end
    UiPop()
    UiTranslate(240, 0)

    -- Quality Mode Button
    UiPush()
    UiColor(0.6, 0.6, 0.2)
    if UiTextButton("Quality Mode (30+ FPS)", 220, 30) then
        SetInt("savegame.mod.pcomb.global.priority", 2)
        SetInt("savegame.mod.pcomb.prgd.fps_target", 30)
        SetBool("savegame.mod.pcomb.prgd.sdf", true)
        SetBool("savegame.mod.pcomb.prgd.lff", false)
        SetInt("savegame.mod.pcomb.prgd.dust_amount", 25)
        SetInt("savegame.mod.pcomb.ibsit.target_fps", 30)
        SetInt("savegame.mod.pcomb.ibsit.particle_quality", 2)
        SetInt("savegame.mod.pcomb.ibsit.dust_amount", 50)
        SetInt("savegame.mod.pcomb.mbcs.dust_amount", 50)
    end
    UiPop()
    UiTranslate(-240, 40)

    -- Maximum Mode Button
    UiPush()
    UiColor(0.6, 0.2, 0.2)
    if UiTextButton("Maximum Mode (20+ FPS)", 220, 30) then
        SetInt("savegame.mod.pcomb.global.priority", 3)
        SetInt("savegame.mod.pcomb.prgd.fps_target", 20)
        SetBool("savegame.mod.pcomb.prgd.sdf", false)
        SetBool("savegame.mod.pcomb.prgd.lff", false)
        SetInt("savegame.mod.pcomb.prgd.dust_amount", 50)
        SetInt("savegame.mod.pcomb.ibsit.target_fps", 20)
        SetInt("savegame.mod.pcomb.ibsit.particle_quality", 5)
        SetInt("savegame.mod.pcomb.ibsit.dust_amount", 100)
        SetInt("savegame.mod.pcomb.mbcs.dust_amount", 100)
    end
    UiPop()
    UiTranslate(0, 60)

    -- Manual performance tuning
    UiText("Manual Performance Scale")
    UiTranslate(0, 25)
    local performanceScale = GetFloat("savegame.mod.pcomb.global.performance_scale")
    local newPerformanceScale = UiSliderWithValue("ui/common/dot.png", 360, 20, performanceScale * 100, 10, 100, "%.2f") / 100
    if newPerformanceScale ~= performanceScale then
        SetFloat("savegame.mod.pcomb.global.performance_scale", newPerformanceScale)
    end
    UiTranslate(0, 30)

    UiText("Current Performance Scale: " .. string.format("%.2f", performanceScale))
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

-- Slider helper that shows numeric value to the right without changing outer layout
function UiSliderWithValue(image, width, height, current, min, max, fmt)
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

    -- Map value -> pixel position so we can control visual width
    local span = maxv - minv
    local normalized = (cur - minv) / span
    local pixelCurrent = normalized * width

    -- Call UiSlider with correct signature: path, axis, current, min, max
    -- Many examples in the API use pixel ranges for current/min/max, so we use 0..width
    local newPixel = UiSlider(image, "x", pixelCurrent, 0, width)
    local newNormalized = newPixel / width
    local newVal = minv + newNormalized * span

    -- If the slider appears to be integer-based, round to nearest integer to avoid
    -- tiny float differences causing unnecessary writes/comparisons.
    if math.floor(minv) == minv and math.floor(maxv) == maxv and math.floor(current) == current then
        newVal = math.floor(newVal + 0.5)
    end

    -- Draw numeric value to the right of the slider
    UiTranslate(width + 12, -6)
    UiFont("regular.ttf", 16)
    UiColor(1, 1, 1)
    UiText(string.format(fmt, newVal))
    UiPop()
    return newVal
end