-- PHYSICS COMBINATION MOD - OPTIONS INTERFACE
-- Comprehensive configuration system for PRGD, IBSIT, and MBCS
-- Uses only official Teardown API functions

-- Option categories
local categories = {
    {id = "global", title = "Global Settings", desc = "Overall system configuration"},
    {id = "prgd", title = "Progressive Destruction", desc = "Crumbling, dust, and violence effects"},
    {id = "ibsit", title = "Structural Integrity", desc = "Physics-based damage and collapse"},
    {id = "mbcs", title = "Mass Collateral", desc = "Proximity-based structural failure"},
    {id = "performance", title = "Performance", desc = "FPS optimization and quality settings"}
}

-- Global System Options
function optionGlobal()
    local function addOption(key, type, min, max, title, desc, default)
        if type == "bool" then
            ui_option(key, "bool", title, desc, default)
        elseif type == "int" then
            ui_option(key, "int", title, desc, default, min, max)
        elseif type == "float" then
            ui_option(key, "float", title, desc, default, min, max)
        end
    end
    
    ui_header("Global Physics System")
    addOption("savegame.mod.pcomb.global.enabled", "bool", nil, nil, 
        "Enable Physics Combination Mod", 
        "Master switch for the entire physics combination system", true)
    
    addOption("savegame.mod.pcomb.global.debug", "bool", nil, nil,
        "Debug Mode",
        "Show debug information on screen during gameplay", false)
    
    ui_header("Performance Priority")
    ui_option("savegame.mod.pcomb.global.priority", "int", "Performance Priority",
        "1=Performance (45+ FPS), 2=Quality (30+ FPS), 3=Maximum (20+ FPS)", 2, 1, 3)
    
    addOption("savegame.mod.pcomb.global.performance_scale", "float", 0.1, 1.0,
        "Performance Scale", 
        "Manual performance scaling factor (0.1 = lowest, 1.0 = highest)", 1.0)
    
    ui_header("System Integration")
    addOption("savegame.mod.pcomb.prgd.enabled", "bool", nil, nil,
        "Progressive Destruction System",
        "Enable PRGD crumbling, dust, and violence effects", true)
    
    addOption("savegame.mod.pcomb.ibsit.enabled", "bool", nil, nil,
        "Impact Structural Integrity System", 
        "Enable IBSIT physics-based structural damage", true)
    
    addOption("savegame.mod.pcomb.mbcs.enabled", "bool", nil, nil,
        "Mass Based Collateral System",
        "Enable MBCS proximity-based structural collapse", true)
end

-- Progressive Destruction Options (Based on original PRGD mod)
function optionPRGD()
    local function addOption(key, type, min, max, title, desc, default)
        if type == "bool" then
            ui_option(key, "bool", title, desc, default)
        elseif type == "int" then
            ui_option(key, "int", title, desc, default, min, max)
        elseif type == "float" then
            ui_option(key, "float", title, desc, default, min, max)
        end
    end
    
    ui_header("Core Progressive Destruction Features")
    addOption("savegame.mod.pcomb.prgd.crumble", "bool", nil, nil,
        "Crumbling Effects",
        "Enable progressive crumbling of damaged structures", true)
    
    addOption("savegame.mod.pcomb.prgd.dust", "bool", nil, nil,
        "Dust Particles",
        "Generate dust clouds from destroyed materials", true)
    
    addOption("savegame.mod.pcomb.prgd.explosions", "bool", nil, nil,
        "Enhanced Explosions",
        "Improved explosion effects with debris", false)
    
    addOption("savegame.mod.pcomb.prgd.force", "bool", nil, nil,
        "Force System",
        "Environmental forces affecting debris (wind, gravity)", false)
    
    addOption("savegame.mod.pcomb.prgd.fire", "bool", nil, nil,
        "Fire Effects",
        "Fire damage and spreading effects", false)
    
    addOption("savegame.mod.pcomb.prgd.violence", "bool", nil, nil,
        "Physics Violence",
        "Enhanced physics interactions and violence", false)
    
    addOption("savegame.mod.pcomb.prgd.joints", "bool", nil, nil,
        "Joint Breaking",
        "Realistic joint failure under stress", false)
    
    ui_header("Performance Controls")
    addOption("savegame.mod.pcomb.prgd.fps_control", "bool", nil, nil,
        "FPS Control",
        "Automatically adjust effects based on performance", true)
    
    addOption("savegame.mod.pcomb.prgd.fps_target", "int", 15, 60,
        "Target FPS",
        "Minimum FPS to maintain (15-60)", 30)
    
    addOption("savegame.mod.pcomb.prgd.sdf", "bool", nil, nil,
        "Small Debris Filter",
        "Remove very small debris to improve performance", true)
    
    addOption("savegame.mod.pcomb.prgd.lff", "bool", nil, nil,
        "Low FPS Filter",
        "Reduce effects when FPS drops below target", false)
    
    addOption("savegame.mod.pcomb.prgd.dbf", "bool", nil, nil,
        "Distance Based Filter",
        "Reduce distant effects to save performance", false)
    
    ui_header("Damage Configuration")
    addOption("savegame.mod.pcomb.prgd.damage_light", "int", 0, 200,
        "Light Material Damage",
        "Damage multiplier for wood and foliage (0-200%)", 50)
    
    addOption("savegame.mod.pcomb.prgd.damage_medium", "int", 0, 200,
        "Medium Material Damage", 
        "Damage multiplier for stone and concrete (0-200%)", 50)
    
    addOption("savegame.mod.pcomb.prgd.damage_heavy", "int", 0, 200,
        "Heavy Material Damage",
        "Damage multiplier for metal and hardmetal (0-200%)", 50)
    
    ui_header("Crumbling Settings")
    addOption("savegame.mod.pcomb.prgd.crumble_size", "int", 1, 20,
        "Crumble Size",
        "Size of crumbling holes (1-20)", 8)
    
    addOption("savegame.mod.pcomb.prgd.crumble_speed", "int", 1, 10,
        "Crumble Speed",
        "Rate of progressive crumbling (1-10)", 2)
    
    ui_header("Dust System")
    addOption("savegame.mod.pcomb.prgd.dust_amount", "int", 0, 100,
        "Dust Amount",
        "Number of dust particles generated (0-100)", 25)
    
    addOption("savegame.mod.pcomb.prgd.dust_size", "int", 1, 10,
        "Dust Size",
        "Size of individual dust particles (1-10)", 2)
    
    addOption("savegame.mod.pcomb.prgd.dust_life", "int", 1, 20,
        "Dust Lifetime",
        "How long dust particles last (1-20 seconds)", 8)
    
    addOption("savegame.mod.pcomb.prgd.dust_gravity", "float", -2.0, 2.0,
        "Dust Gravity",
        "Gravitational effect on dust (-2.0 to 2.0)", 0.35)
    
    addOption("savegame.mod.pcomb.prgd.dust_drag", "float", 0.0, 1.0,
        "Dust Air Resistance",
        "Air resistance affecting dust movement (0.0-1.0)", 0.15)
    
    -- Force System Options (Advanced)
    if get_option("savegame.mod.pcomb.prgd.force") then
        ui_header("Force System (Advanced)")
        ui_option("savegame.mod.pcomb.prgd.force_method", "int", "Force Method",
            "1=Horizontal Push, 2=Vertical Lift, 3=Horizontal Rotation (wind)", 1, 1, 3)
        
        addOption("savegame.mod.pcomb.prgd.force_strength", "float", 0.1, 10.0,
            "Force Strength",
            "Strength of environmental forces (0.1-10.0)", 1.0)
        
        addOption("savegame.mod.pcomb.prgd.force_radius", "float", 1.0, 50.0,
            "Force Radius",
            "Range of force effects (1.0-50.0 meters)", 10.0)
    end
    
    -- Violence System Options (Advanced)
    if get_option("savegame.mod.pcomb.prgd.violence") then
        ui_header("Physics Violence (Advanced)")
        addOption("savegame.mod.pcomb.prgd.violence_multiplier", "float", 0.1, 5.0,
            "Violence Multiplier",
            "Intensity of physics violence effects (0.1-5.0)", 1.0)
        
        addOption("savegame.mod.pcomb.prgd.bounce_damping", "float", 0.0, 1.0,
            "Bounce Damping",
            "Reduction in bounce energy over time (0.0-1.0)", 0.2)
    end
end

-- Impact Based Structural Integrity Options (Based on IBSIT Enhanced)
function optionIBSIT()
    local function addOption(key, type, min, max, title, desc, default)
        if type == "bool" then
            ui_option(key, "bool", title, desc, default)
        elseif type == "int" then
            ui_option(key, "int", title, desc, default, min, max)
        elseif type == "float" then
            ui_option(key, "float", title, desc, default, min, max)
        end
    end
    
    ui_header("Core Structural Integrity Features")
    addOption("savegame.mod.pcomb.ibsit.particles", "bool", nil, nil,
        "Particle Effects",
        "Material-specific particle effects for structural damage", true)
    
    addOption("savegame.mod.pcomb.ibsit.sounds", "bool", nil, nil,
        "Sound Effects", 
        "Audio feedback for structural failure events", true)
    
    addOption("savegame.mod.pcomb.ibsit.haptic", "bool", nil, nil,
        "Haptic Feedback",
        "Controller vibration for structural impacts", true)
    
    addOption("savegame.mod.pcomb.ibsit.vehicles", "bool", nil, nil,
        "Vehicle Integrity",
        "Apply structural integrity to vehicles", false)
    
    addOption("savegame.mod.pcomb.ibsit.joints", "bool", nil, nil,
        "Joint Analysis",
        "Analyze and simulate joint stress failure", false)
    
    addOption("savegame.mod.pcomb.ibsit.protection", "bool", nil, nil,
        "Player Protection",
        "Reduce damage effects near player", false)
    
    ui_header("Damage Analysis")
    addOption("savegame.mod.pcomb.ibsit.dust_amount", "int", 0, 100,
        "Particle Intensity",
        "Number of particles generated per impact (0-100)", 50)
    
    addOption("savegame.mod.pcomb.ibsit.momentum_threshold", "int", 8, 20,
        "Momentum Threshold",
        "Minimum momentum for structural analysis (2^8 to 2^20)", 12)
    
    ui_header("Material-Specific Damage Multipliers")
    addOption("savegame.mod.pcomb.ibsit.wood_damage", "int", 10, 300,
        "Wood Damage Multiplier",
        "Structural integrity loss for wood materials (10-300%)", 100)
    
    addOption("savegame.mod.pcomb.ibsit.stone_damage", "int", 10, 300,
        "Stone Damage Multiplier",
        "Structural integrity loss for stone materials (10-300%)", 75)
    
    addOption("savegame.mod.pcomb.ibsit.metal_damage", "int", 10, 300,
        "Metal Damage Multiplier", 
        "Structural integrity loss for metal materials (10-300%)", 50)
    
    ui_header("Advanced Features")
    addOption("savegame.mod.pcomb.ibsit.gravity_collapse", "bool", nil, nil,
        "Gravity Collapse",
        "Simulate gravitational structural failure", true)
    
    addOption("savegame.mod.pcomb.ibsit.collapse_threshold", "float", 0.1, 1.0,
        "Collapse Threshold",
        "Minimum structural integrity before collapse (0.1-1.0)", 0.3)
    
    addOption("savegame.mod.pcomb.ibsit.gravity_force", "float", 0.5, 5.0,
        "Gravity Force Multiplier",
        "Strength of gravitational collapse forces (0.5-5.0)", 2.0)
    
    ui_header("Cleanup and Optimization")
    addOption("savegame.mod.pcomb.ibsit.debris_cleanup", "bool", nil, nil,
        "Debris Cleanup",
        "Automatically remove small debris after time", true)
    
    addOption("savegame.mod.pcomb.ibsit.cleanup_delay", "float", 5.0, 120.0,
        "Cleanup Delay",
        "Time before debris cleanup starts (5-120 seconds)", 30.0)
    
    addOption("savegame.mod.pcomb.ibsit.fps_optimization", "bool", nil, nil,
        "FPS Optimization",
        "Automatically adjust effects based on performance", true)
    
    addOption("savegame.mod.pcomb.ibsit.target_fps", "int", 15, 60,
        "Target FPS",
        "Minimum FPS to maintain with optimization (15-60)", 30)
    
    ui_header("Audio and Visual")
    addOption("savegame.mod.pcomb.ibsit.volume", "float", 0.0, 1.0,
        "Sound Volume",
        "Volume level for structural sound effects (0.0-1.0)", 0.7)
    
    addOption("savegame.mod.pcomb.ibsit.particle_quality", "int", 1, 5,
        "Particle Quality",
        "Visual quality of particle effects (1=Low, 5=Ultra)", 2)
end

-- Mass Based Collateral System Options (Based on MBCS)
function optionMBCS()
    local function addOption(key, type, min, max, title, desc, default)
        if type == "bool" then
            ui_option(key, "bool", title, desc, default)
        elseif type == "int" then
            ui_option(key, "int", title, desc, default, min, max)
        elseif type == "float" then
            ui_option(key, "float", title, desc, default, min, max)
        end
    end
    
    ui_header("Mass Based Collateral System")
    ui_text("Configure proximity-based structural collapse triggered by mass")
    
    ui_header("Core Settings")
    addOption("savegame.mod.pcomb.mbcs.dust_amount", "int", 0, 100,
        "Particle Amount",
        "Number of particles generated during collapse (0-100)", 50)
    
    addOption("savegame.mod.pcomb.mbcs.mass_threshold", "int", 4, 16,
        "Mass Threshold",
        "Minimum mass to trigger collapse (2^4 to 2^16 units)", 8)
    
    addOption("savegame.mod.pcomb.mbcs.distance_threshold", "int", 1, 20,
        "Distance Threshold", 
        "Maximum distance for mass-based triggering (1-20 meters)", 4)
    
    ui_header("Material Damage")
    addOption("savegame.mod.pcomb.mbcs.wood_damage", "int", 10, 300,
        "Wood Damage Multiplier",
        "Collapse damage for wood materials (10-300%)", 100)
    
    addOption("savegame.mod.pcomb.mbcs.stone_damage", "int", 10, 300,
        "Stone Damage Multiplier",
        "Collapse damage for stone materials (10-300%)", 75)
    
    addOption("savegame.mod.pcomb.mbcs.metal_damage", "int", 10, 300,
        "Metal Damage Multiplier",
        "Collapse damage for metal materials (10-300%)", 50)
    
    ui_header("Advanced Configuration")
    ui_text("Mass Threshold Reference:")
    ui_text("2^4 = 16 (very light objects)")
    ui_text("2^8 = 256 (medium objects)")
    ui_text("2^12 = 4096 (heavy objects)")
    ui_text("2^16 = 65536 (very heavy objects)")
    
    ui_text("Distance determines how far massive objects can trigger collapse.")
    ui_text("Lower values = more precise triggering")
    ui_text("Higher values = wider area of effect")
end

-- Performance and Quality Options
function optionPerformance()
    local function addOption(key, type, min, max, title, desc, default)
        if type == "bool" then
            ui_option(key, "bool", title, desc, default)
        elseif type == "int" then
            ui_option(key, "int", title, desc, default, min, max)
        elseif type == "float" then
            ui_option(key, "float", title, desc, default, min, max)
        end
    end
    
    ui_header("Performance Presets")
    ui_text("Quick configuration presets for different performance needs")
    
    if ui_button("Performance Mode (45+ FPS)") then
        -- Set all systems to performance-focused values
        set_option("savegame.mod.pcomb.global.priority", 1)
        set_option("savegame.mod.pcomb.prgd.fps_target", 45)
        set_option("savegame.mod.pcomb.prgd.sdf", true)
        set_option("savegame.mod.pcomb.prgd.lff", true)
        set_option("savegame.mod.pcomb.prgd.dust_amount", 15)
        set_option("savegame.mod.pcomb.ibsit.target_fps", 45)
        set_option("savegame.mod.pcomb.ibsit.particle_quality", 1)
        set_option("savegame.mod.pcomb.ibsit.dust_amount", 25)
    end
    
    if ui_button("Quality Mode (30+ FPS)") then
        -- Set all systems to balanced values
        set_option("savegame.mod.pcomb.global.priority", 2)
        set_option("savegame.mod.pcomb.prgd.fps_target", 30)
        set_option("savegame.mod.pcomb.prgd.sdf", true)
        set_option("savegame.mod.pcomb.prgd.lff", false)
        set_option("savegame.mod.pcomb.prgd.dust_amount", 25)
        set_option("savegame.mod.pcomb.ibsit.target_fps", 30)
        set_option("savegame.mod.pcomb.ibsit.particle_quality", 2)
        set_option("savegame.mod.pcomb.ibsit.dust_amount", 50)
    end
    
    if ui_button("Maximum Mode (20+ FPS)") then
        -- Set all systems to maximum quality
        set_option("savegame.mod.pcomb.global.priority", 3)
        set_option("savegame.mod.pcomb.prgd.fps_target", 20)
        set_option("savegame.mod.pcomb.prgd.sdf", false)
        set_option("savegame.mod.pcomb.prgd.lff", false)
        set_option("savegame.mod.pcomb.prgd.dust_amount", 50)
        set_option("savegame.mod.pcomb.ibsit.target_fps", 20)
        set_option("savegame.mod.pcomb.ibsit.particle_quality", 5)
        set_option("savegame.mod.pcomb.ibsit.dust_amount", 100)
    end
    
    ui_header("Manual Performance Tuning")
    ui_text("Fine-tune individual performance settings")
    
    local currentFPS = get_option("savegame.mod.pcomb.prgd.fps_target") or 30
    local currentParticles = get_option("savegame.mod.pcomb.ibsit.dust_amount") or 50
    local currentQuality = get_option("savegame.mod.pcomb.ibsit.particle_quality") or 2
    
    ui_text("Current Target FPS: " .. currentFPS)
    ui_text("Current Particle Amount: " .. currentParticles)
    ui_text("Current Quality Level: " .. currentQuality)
    
    ui_header("System Status")
    ui_text("Check individual system status and performance impact")
    
    local prgdEnabled = get_option("savegame.mod.pcomb.prgd.enabled")
    local ibsitEnabled = get_option("savegame.mod.pcomb.ibsit.enabled")  
    local mbcsEnabled = get_option("savegame.mod.pcomb.mbcs.enabled")
    
    ui_text("PRGD System: " .. (prgdEnabled and "ENABLED" or "DISABLED"))
    ui_text("IBSIT System: " .. (ibsitEnabled and "ENABLED" or "DISABLED"))
    ui_text("MBCS System: " .. (mbcsEnabled and "ENABLED" or "DISABLED"))
    
    local activeCount = 0
    if prgdEnabled then activeCount = activeCount + 1 end
    if ibsitEnabled then activeCount = activeCount + 1 end
    if mbcsEnabled then activeCount = activeCount + 1 end
    
    ui_text("Active Systems: " .. activeCount .. "/3")
    
    if activeCount == 3 then
        ui_text("Performance Impact: HIGH")
        ui_text("Recommended: Use Performance Mode or disable one system")
    elseif activeCount == 2 then
        ui_text("Performance Impact: MEDIUM")
        ui_text("Recommended: Quality Mode works well")
    else
        ui_text("Performance Impact: LOW")
        ui_text("Recommended: Maximum Mode available")
    end
end

-- Main Options Function
function options()
    ui_tabbed(categories, function(tab)
        if tab.id == "global" then
            optionGlobal()
        elseif tab.id == "prgd" then
            optionPRGD()
        elseif tab.id == "ibsit" then
            optionIBSIT()
        elseif tab.id == "mbcs" then
            optionMBCS()
        elseif tab.id == "performance" then
            optionPerformance()
        end
    end)
end