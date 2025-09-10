-- PHYSICS COMBINATION MOD - MAIN INTEGRATION
-- Combines Progressive Destruction, IBSIT, and MBCS systems
-- Uses only official Teardown API functions

-- System Modules (included inline for standalone operation)
local PcombCore = {}
local PcombDetection = {}
local PcombEffects = {}
local PcombPerformance = {}

-- Global state management
local systems = {
    prgd = {enabled = true, initialized = false},
    ibsit = {enabled = true, initialized = false},
    mbcs = {enabled = true, initialized = false}
}

local sharedState = {
    bodies = {},          -- Tracked bodies with unified data
    breakEvents = {},     -- Active break events
    particles = {},       -- Active particle systems
    performance = {       -- Performance metrics
        fps = 60,
        bodiesProcessed = 0,
        particlesActive = 0,
        memoryUsage = 0
    }
}

-- Configuration Management
local function initializeConfiguration()
    -- Global system settings
    if not HasKey("savegame.mod.pcomb.global.enabled") then
        SetBool("savegame.mod.pcomb.global.enabled", true)
        SetBool("savegame.mod.pcomb.global.debug", false)
        SetInt("savegame.mod.pcomb.global.priority", 1) -- 1=Performance, 2=Quality, 3=Maximum
        SetFloat("savegame.mod.pcomb.global.performance_scale", 1.0)
    end

    -- PRGD System Settings (Progressive Destruction)
    if not HasKey("savegame.mod.pcomb.prgd.enabled") then
        -- Core PRGD settings
        SetBool("savegame.mod.pcomb.prgd.enabled", true)
        SetBool("savegame.mod.pcomb.prgd.crumble", true)
        SetBool("savegame.mod.pcomb.prgd.dust", true)
        SetBool("savegame.mod.pcomb.prgd.explosions", false)
        SetBool("savegame.mod.pcomb.prgd.force", false)
        SetBool("savegame.mod.pcomb.prgd.fire", false)
        SetBool("savegame.mod.pcomb.prgd.violence", false)
        SetBool("savegame.mod.pcomb.prgd.joints", false)
        
        -- FPS Control
        SetBool("savegame.mod.pcomb.prgd.fps_control", true)
        SetInt("savegame.mod.pcomb.prgd.fps_target", 30)
        SetBool("savegame.mod.pcomb.prgd.sdf", true)      -- Small Debris Filter
        SetBool("savegame.mod.pcomb.prgd.lff", false)     -- Low FPS Filter
        SetBool("savegame.mod.pcomb.prgd.dbf", false)     -- Distance Based Filter
        
        -- Damage settings
        SetInt("savegame.mod.pcomb.prgd.damage_light", 50)
        SetInt("savegame.mod.pcomb.prgd.damage_medium", 50)
        SetInt("savegame.mod.pcomb.prgd.damage_heavy", 50)
        SetInt("savegame.mod.pcomb.prgd.crumble_size", 8)
        SetInt("savegame.mod.pcomb.prgd.crumble_speed", 2)
        
        -- Dust settings
        SetInt("savegame.mod.pcomb.prgd.dust_amount", 25)
        SetInt("savegame.mod.pcomb.prgd.dust_size", 2)
        SetInt("savegame.mod.pcomb.prgd.dust_life", 8)
        SetFloat("savegame.mod.pcomb.prgd.dust_gravity", 0.35)
        SetFloat("savegame.mod.pcomb.prgd.dust_drag", 0.15)
    end

    -- IBSIT System Settings (Structural Integrity)
    if not HasKey("savegame.mod.pcomb.ibsit.enabled") then
        SetBool("savegame.mod.pcomb.ibsit.enabled", true)
        SetBool("savegame.mod.pcomb.ibsit.particles", true)
        SetBool("savegame.mod.pcomb.ibsit.sounds", true)
        SetBool("savegame.mod.pcomb.ibsit.haptic", true)
        SetBool("savegame.mod.pcomb.ibsit.vehicles", false)
        SetBool("savegame.mod.pcomb.ibsit.joints", false)
        SetBool("savegame.mod.pcomb.ibsit.protection", false)
        
        -- Damage multipliers
        SetInt("savegame.mod.pcomb.ibsit.dust_amount", 50)
        SetInt("savegame.mod.pcomb.ibsit.wood_damage", 100)
        SetInt("savegame.mod.pcomb.ibsit.stone_damage", 75)
        SetInt("savegame.mod.pcomb.ibsit.metal_damage", 50)
        SetInt("savegame.mod.pcomb.ibsit.momentum_threshold", 12)
        
        -- New features
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

    -- MBCS System Settings (Mass Based Collateral)
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

-- Load system configurations
local function loadSystemConfigurations()
    -- Load PRGD settings
    systems.prgd.enabled = GetBool("savegame.mod.pcomb.prgd.enabled")
    
    -- Load IBSIT settings  
    systems.ibsit.enabled = GetBool("savegame.mod.pcomb.ibsit.enabled")
    
    -- Load MBCS settings
    systems.mbcs.enabled = GetBool("savegame.mod.pcomb.mbcs.enabled")
end

-- Core System Management Module
PcombCore = {
    init = function()
        initializeConfiguration()
        loadSystemConfigurations()
        
        -- Initialize enabled systems
        if systems.prgd.enabled then
            systems.prgd.initialized = PcombCore.initPRGD()
        end
        
        if systems.ibsit.enabled then
            systems.ibsit.initialized = PcombCore.initIBSIT()
        end
        
        if systems.mbcs.enabled then
            systems.mbcs.initialized = PcombCore.initMBCS()
        end
        
        -- Initialize shared systems
        PcombPerformance.init()
        
        if GetBool("savegame.mod.pcomb.global.debug") then
            DebugPrint("Physics Combination Mod initialized")
            DebugPrint("PRGD: " .. (systems.prgd.enabled and "Enabled" or "Disabled"))
            DebugPrint("IBSIT: " .. (systems.ibsit.enabled and "Enabled" or "Disabled"))
            DebugPrint("MBCS: " .. (systems.mbcs.enabled and "Enabled" or "Disabled"))
        end
    end,
    
    initPRGD = function()
        -- Initialize Progressive Destruction system
        if GetBool("savegame.mod.pcomb.prgd.force") then
            -- Load wind sound if force system is enabled with horizontal rotation
            local forceMethod = GetInt("savegame.mod.pcomb.prgd.force_method") or 1
            if forceMethod == 3 then
                LoadLoop("MOD/data/WindNoise/WindOgg.ogg")
            end
        end
        return true
    end,
    
    initIBSIT = function()
        -- Initialize IBSIT system
        if GetBool("savegame.mod.pcomb.ibsit.sounds") then
            LoadSound("MOD/sounds/collapse_heavy.ogg")
            LoadSound("MOD/sounds/collapse_light.ogg") 
            LoadSound("MOD/sounds/structure_stress.ogg")
        end
        
        if GetBool("savegame.mod.pcomb.ibsit.haptic") then
            LoadHaptic("MOD/haptic/impact_light.xml")
            LoadHaptic("MOD/haptic/impact_heavy.xml")
        end
        return true
    end,
    
    initMBCS = function()
        -- Initialize MBCS system
        -- Acquire voxels for static shapes
        local shapes = GetBodyShapes(GetWorldBody())
        for i = 1, #shapes do
            local shape = shapes[i]
            if not IsShapeDisconnected(shape) then
                SetTag(shape, "inherittags")
                SetTag(shape, "parent_shape", shape)
            end
        end
        return true
    end,
    
    updateSystems = function()
        loadSystemConfigurations()
    end
}

-- Detection and Analysis Module
PcombDetection = {
    analyzeBreakEvent = function(breakpoint, breaksize)
        local analysisData = {
            position = breakpoint,
            size = breaksize,
            affectedBodies = {},
            integrityLoss = {},
            massDistribution = {},
            proximityTriggers = {}
        }
        
        -- Query affected area
        local min = {breakpoint[1] - breaksize, breakpoint[2] - breaksize, breakpoint[3] - breaksize}
        local max = {breakpoint[1] + breaksize, breakpoint[2] + breaksize, breakpoint[3] + breaksize}
        
        -- IBSIT Analysis
        if systems.ibsit.enabled and systems.ibsit.initialized then
            QueryRequire("physical dynamic large")
            local bodies = QueryAabbBodies(min, max)
            
            for i = 1, #bodies do
                local body = bodies[i]
                if IsBodyBroken(body) and IsBodyActive(body) then
                    local mass = GetBodyMass(body)
                    local velocity = GetBodyVelocity(body)
                    local velocityMagnitude = VecLength(velocity)
                    
                    -- Calculate structural integrity loss
                    local integrityLoss = PcombDetection.calculateIntegrityLoss(body, breakpoint, velocityMagnitude)
                    
                    analysisData.affectedBodies[#analysisData.affectedBodies + 1] = body
                    analysisData.integrityLoss[body] = integrityLoss
                    analysisData.massDistribution[body] = mass
                end
            end
        end
        
        -- MBCS Analysis
        if systems.mbcs.enabled and systems.mbcs.initialized then
            local proximityTriggers = PcombDetection.analyzeProximityTriggers(breakpoint, breaksize)
            analysisData.proximityTriggers = proximityTriggers
        end
        
        return analysisData
    end,
    
    calculateIntegrityLoss = function(body, impactPoint, velocity)
        local momentum = GetBodyMass(body) * velocity
        local threshold = 2 ^ GetInt("savegame.mod.pcomb.ibsit.momentum_threshold")
        
        if momentum > threshold then
            local bodyTransform = GetBodyTransform(body)
            local distance = VecLength(VecSub(impactPoint, bodyTransform.pos))
            
            -- Calculate integrity loss based on momentum and proximity
            local baseLoss = math.min(momentum / threshold, 10) -- Cap at 10x threshold
            local proximityFactor = math.max(0.1, 1 - (distance / 20)) -- Closer = more damage
            
            return baseLoss * proximityFactor
        end
        
        return 0
    end,
    
    analyzeProximityTriggers = function(breakpoint, breaksize)
        local triggers = {}
        local massThreshold = 2 ^ GetInt("savegame.mod.pcomb.mbcs.mass_threshold")
        local distanceThreshold = GetInt("savegame.mod.pcomb.mbcs.distance_threshold")
        
        -- Find dynamic bodies that might trigger collapse
        local min = {breakpoint[1] - breaksize, breakpoint[2] - breaksize, breakpoint[3] - breaksize}
        local max = {breakpoint[1] + breaksize, breakpoint[2] + breaksize, breakpoint[3] + breaksize}
        
        QueryRequire("physical dynamic large")
        local bodies = QueryAabbBodies(min, max)
        
        for i = 1, #bodies do
            local body = bodies[i]
            if IsBodyBroken(body) and IsBodyActive(body) and VecLength(GetBodyVelocity(body)) < 5 then
                local bodyPos = TransformToParentPoint(GetBodyTransform(body), GetBodyCenterOfMass(body))
                local distance = VecLength(VecSub(bodyPos, breakpoint))
                
                if distance > distanceThreshold then
                    local mass = GetBodyMass(body)
                    local voxelCount = PcombDetection.getBodyVoxelCount(body)
                    
                    -- Check mass conditions
                    if mass < voxelCount * 0.5 or voxelCount * 10 < mass then
                        mass = mass * 0.5
                    end
                    
                    if mass > massThreshold then
                        triggers[body] = {
                            mass = mass,
                            distance = distance,
                            position = bodyPos,
                            triggerStrength = mass / massThreshold
                        }
                    end
                end
            end
        end
        
        return triggers
    end,
    
    getBodyVoxelCount = function(body)
        local count = 0
        local shapes = GetBodyShapes(body)
        for i = 1, #shapes do
            count = count + GetShapeVoxelCount(shapes[i])
        end
        return count
    end
}

-- Effects and Visual Systems Module
PcombEffects = {
    processEffects = function(analysisData)
        -- Process PRGD effects
        if systems.prgd.enabled and systems.prgd.initialized then
            PcombEffects.processPRGDEffects(analysisData)
        end
        
        -- Process IBSIT effects
        if systems.ibsit.enabled and systems.ibsit.initialized then
            PcombEffects.processIBSITEffects(analysisData)
        end
        
        -- Process MBCS effects
        if systems.mbcs.enabled and systems.mbcs.initialized then
            PcombEffects.processMBCSEffects(analysisData)
        end
    end,
    
    processPRGDEffects = function(analysisData)
        -- PRGD crumbling effects
        if GetBool("savegame.mod.pcomb.prgd.crumble") then
            for i = 1, #analysisData.affectedBodies do
                local body = analysisData.affectedBodies[i]
                PcombEffects.createCrumbleEffect(body, analysisData.position)
            end
        end
        
        -- PRGD dust effects
        if GetBool("savegame.mod.pcomb.prgd.dust") then
            PcombEffects.createPRGDDust(analysisData.position, analysisData.size)
        end
    end,
    
    processIBSITEffects = function(analysisData)
        -- IBSIT structural effects
        for body, integrityLoss in pairs(analysisData.integrityLoss) do
            if integrityLoss > 0 then
                PcombEffects.createStructuralEffects(body, integrityLoss, analysisData.position)
            end
        end
    end,
    
    processMBCSEffects = function(analysisData)
        -- MBCS proximity-based collapse effects
        for body, triggerData in pairs(analysisData.proximityTriggers) do
            PcombEffects.createCollapseEffects(body, triggerData, analysisData.position)
        end
    end,
    
    createCrumbleEffect = function(body, position)
        local shapes = GetBodyShapes(body)
        if #shapes == 0 then return end
        
        local mass = GetBodyMass(body)
        local velocity = GetBodyVelocity(body)
        
        -- Get damage multipliers
        local lightDamage = GetInt("savegame.mod.pcomb.prgd.damage_light") / 100
        local mediumDamage = GetInt("savegame.mod.pcomb.prgd.damage_medium") / 100
        local heavyDamage = GetInt("savegame.mod.pcomb.prgd.damage_heavy") / 100
        local crumbleSize = GetInt("savegame.mod.pcomb.prgd.crumble_size")
        
        -- Create holes based on mass
        local holeCount = math.min(math.floor(mass / 50000) + 1, 3)
        
        for i = 1, holeCount do
            local shape = shapes[math.random(#shapes)]
            local bounds = GetShapeBounds(shape)
            local holePos = {
                math.random() * (bounds[4] - bounds[1]) + bounds[1],
                math.random() * (bounds[5] - bounds[2]) + bounds[2], 
                math.random() * (bounds[6] - bounds[3]) + bounds[3]
            }
            
            local sizeMultiplier = (crumbleSize / 500) * (0.8 + math.random() * 0.4)
            local woodDamage = lightDamage * (mass * 0.008) * sizeMultiplier
            local stoneDamage = mediumDamage * (mass * 0.008) * sizeMultiplier
            local metalDamage = heavyDamage * (mass * 0.008) * sizeMultiplier
            
            MakeHole(holePos, woodDamage, stoneDamage, metalDamage)
        end
    end,
    
    createStructuralEffects = function(body, integrityLoss, position)
        if not GetBool("savegame.mod.pcomb.ibsit.particles") then return end
        
        -- Get material at break point
        local shapes = GetBodyShapes(body)
        if #shapes == 0 then return end
        
        local shape = shapes[1]
        local _, r, g, b, a, material = GetShapeMaterialAtPosition(shape, position)
        
        -- Create material-specific particles
        ParticleReset()
        
        if material == "metal" or material == "hardmetal" then
            ParticleType("plain")
            ParticleColor(1, 0.4, 0.3)
            ParticleAlpha(1, 0, "easein")
            ParticleRadius(0.03, 0.08, "easeout")
            ParticleEmissive(5, 0, "easeout")
            ParticleGravity(-15)
            ParticleSticky(0.3)
        elseif material == "wood" or material == "foliage" then
            ParticleType("smoke")
            ParticleColor(0.4, 0.3, 0.2)
            ParticleAlpha(0.8, 0, "easein")
            ParticleRadius(0.1, 0.3, "easeout")
            ParticleGravity(-0.2)
            ParticleDrag(0, 1, "easeout")
        else
            ParticleType("smoke")
            ParticleColor(r * 0.5 + 0.3, g * 0.5 + 0.275, b * 0.5 + 0.25)
            ParticleAlpha(a, 0, "easein")
            ParticleRadius(0.1, 0.25, "easeout")
            ParticleGravity(-0.1)
            ParticleDrag(0, 1, "easeout")
        end
        
        local particleCount = math.min(integrityLoss * 10, 50)
        for i = 1, particleCount do
            local velocity = {
                (math.random() - 0.5) * 2,
                math.random() * 2,
                (math.random() - 0.5) * 2
            }
            SpawnParticle(position, velocity, math.random() * 2)
        end
        
        -- Play appropriate sound
        if GetBool("savegame.mod.pcomb.ibsit.sounds") then
            local volume = GetFloat("savegame.mod.pcomb.ibsit.volume")
            if integrityLoss > 5 then
                PlaySound("MOD/sounds/collapse_heavy.ogg", volume)
            elseif integrityLoss > 2 then
                PlaySound("MOD/sounds/structure_stress.ogg", volume)
            else
                PlaySound("MOD/sounds/collapse_light.ogg", volume)
            end
        end
        
        -- Trigger haptic feedback
        if GetBool("savegame.mod.pcomb.ibsit.haptic") then
            if integrityLoss > 5 then
                PlayHaptic("MOD/haptic/impact_heavy.xml", 1.0)
            else
                PlayHaptic("MOD/haptic/impact_light.xml", 0.7)
            end
        end
    end,
    
    createCollapseEffects = function(body, triggerData, position)
        -- Create MBCS-style collapse particles
        local shapes = GetBodyShapes(body)
        if #shapes == 0 then return end
        
        local dustAmount = GetInt("savegame.mod.pcomb.mbcs.dust_amount")
        local woodDamage = GetInt("savegame.mod.pcomb.mbcs.wood_damage") / 100
        local stoneDamage = GetInt("savegame.mod.pcomb.mbcs.stone_damage") / 100  
        local metalDamage = GetInt("savegame.mod.pcomb.mbcs.metal_damage") / 100
        
        -- Create damage based on trigger strength
        for i = 1, #shapes do
            local shape = shapes[i]
            local shapeBounds = GetShapeBounds(shape)
            local center = {
                (shapeBounds[1] + shapeBounds[4]) / 2,
                (shapeBounds[2] + shapeBounds[5]) / 2,
                (shapeBounds[3] + shapeBounds[6]) / 2
            }
            
            local damageMultiplier = triggerData.triggerStrength * 0.5
            
            MakeHole(center, 
                woodDamage * damageMultiplier,
                stoneDamage * damageMultiplier, 
                metalDamage * damageMultiplier
            )
        end
    end,
    
    createPRGDDust = function(position, size)
        local dustAmount = GetInt("savegame.mod.pcomb.prgd.dust_amount")
        local dustSize = GetInt("savegame.mod.pcomb.prgd.dust_size") * 0.25
        local dustLife = GetInt("savegame.mod.pcomb.prgd.dust_life") * 0.5
        local dustGravity = GetFloat("savegame.mod.pcomb.prgd.dust_gravity")
        local dustDrag = GetFloat("savegame.mod.pcomb.prgd.dust_drag")
        
        ParticleReset()
        ParticleType("smoke")
        ParticleColor(0.5, 0.5, 0.5)
        ParticleDrag(dustDrag)
        ParticleGravity(dustGravity)
        ParticleAlpha(1, 0, "linear")
        ParticleRadius(dustSize / 2, dustSize)
        
        for i = 1, dustAmount do
            local offset = {
                (math.random() - 0.5) * size,
                (math.random() - 0.5) * size,
                (math.random() - 0.5) * size
            }
            local dustPos = {
                position[1] + offset[1],
                position[2] + offset[2], 
                position[3] + offset[3]
            }
            local velocity = {
                (math.random() - 0.5) * 0.4,
                math.random() * 0.2,
                (math.random() - 0.5) * 0.4
            }
            SpawnParticle(dustPos, velocity, dustLife)
        end
    end
}

-- Performance Management Module
PcombPerformance = {
    frameTime = 0,
    lastFrameTime = 0,
    frameCount = 0,
    fpsUpdateTime = 0,
    
    init = function()
        PcombPerformance.lastFrameTime = GetTime()
        sharedState.performance.fps = 60
    end,
    
    update = function(dt)
        -- Update FPS tracking
        PcombPerformance.frameCount = PcombPerformance.frameCount + 1
        local currentTime = GetTime()
        
        if currentTime - PcombPerformance.fpsUpdateTime > 1.0 then
            sharedState.performance.fps = PcombPerformance.frameCount
            PcombPerformance.frameCount = 0
            PcombPerformance.fpsUpdateTime = currentTime
        end
        
        -- Performance scaling based on FPS
        local globalPriority = GetInt("savegame.mod.pcomb.global.priority")
        local targetFPS = 30
        
        if globalPriority == 1 then targetFPS = 45 -- Performance priority
        elseif globalPriority == 2 then targetFPS = 30 -- Quality priority  
        else targetFPS = 20 end -- Maximum priority
        
        if sharedState.performance.fps < targetFPS then
            local scale = math.max(0.1, GetFloat("savegame.mod.pcomb.global.performance_scale") * 0.95)
            SetFloat("savegame.mod.pcomb.global.performance_scale", scale)
        elseif sharedState.performance.fps > targetFPS + 10 then
            local scale = math.min(1.0, GetFloat("savegame.mod.pcomb.global.performance_scale") * 1.02)
            SetFloat("savegame.mod.pcomb.global.performance_scale", scale)
        end
        
        PcombPerformance.lastFrameTime = currentTime
    end,
    
    shouldProcessEffect = function()
        local scale = GetFloat("savegame.mod.pcomb.global.performance_scale")
        return math.random() < scale
    end,
    
    getEffectQuality = function()
        local scale = GetFloat("savegame.mod.pcomb.global.performance_scale")
        if scale > 0.8 then return "high"
        elseif scale > 0.5 then return "medium"
        else return "low" end
    end
}

-- Pause Menu Integration
local pauseMenuEnabled = false
local pauseMenuButtons = {
    {name = "PRGD System", key = "savegame.mod.pcomb.prgd.enabled"},
    {name = "IBSIT System", key = "savegame.mod.pcomb.ibsit.enabled"},
    {name = "MBCS System", key = "savegame.mod.pcomb.mbcs.enabled"},
    {name = "Debug Mode", key = "savegame.mod.pcomb.global.debug"}
}

-- Main Teardown Callbacks
function init()
    PcombCore.init()
end

function tick(dt)
    -- Update performance tracking
    PcombPerformance.update(dt)
    
    -- Handle pause menu
    if PauseMenuButton("Physics Combo") then
        pauseMenuEnabled = not pauseMenuEnabled
        SetPaused(false)
    end
    
    -- Only process physics if systems are running
    if not pauseMenuEnabled then
        -- Check for break events
        if HasKey("game.break") then
            local breaksize = GetFloat("game.break.size")
            local breakpoint = {
                GetFloat("game.break.x"),
                GetFloat("game.break.y"), 
                GetFloat("game.break.z")
            }
            
            -- Process break event through unified system
            if PcombPerformance.shouldProcessEffect() then
                local analysisData = PcombDetection.analyzeBreakEvent(breakpoint, breaksize)
                PcombEffects.processEffects(analysisData)
                
                sharedState.performance.bodiesProcessed = sharedState.performance.bodiesProcessed + #analysisData.affectedBodies
            end
        end
        
        -- Check for explosion events
        if HasKey("game.explosion") then
            local explosionSize = GetFloat("game.explosion.strength") * 2.2
            local explosionPoint = {
                GetFloat("game.explosion.x"),
                GetFloat("game.explosion.y"),
                GetFloat("game.explosion.z")
            }
            
            -- Process explosion as a break event
            if PcombPerformance.shouldProcessEffect() then
                local analysisData = PcombDetection.analyzeBreakEvent(explosionPoint, explosionSize)
                PcombEffects.processEffects(analysisData)
            end
        end
    end
end

function update(dt)
    -- Update system configurations periodically
    PcombCore.updateSystems()
end

function draw(dt)
    -- Draw pause menu if enabled
    if pauseMenuEnabled then
        UiTranslate(UiCenter(), UiMiddle())
        UiAlign("center middle")
        
        -- Background
        UiPush()
        UiColor(0, 0, 0, 0.8)
        UiImageBox("ui/common/box-solid-6.png", 400, 300, 6, 6)
        UiPop()
        
        -- Title
        UiPush()
        UiTranslate(0, -100)
        UiFont("bold.ttf", 28)
        UiColor(1, 1, 1)
        UiText("Physics Combination Mod")
        UiPop()
        
        -- System toggles
        for i, button in ipairs(pauseMenuButtons) do
            UiPush()
            UiTranslate(0, -50 + (i - 1) * 40)
            UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
            
            local isEnabled = GetBool(button.key)
            if isEnabled then
                UiColor(0.2, 0.8, 0.2)
            else
                UiColor(0.8, 0.2, 0.2)
            end
            
            if UiTextButton(button.name .. " (" .. (isEnabled and "ON" or "OFF") .. ")", 300, 35) then
                SetBool(button.key, not isEnabled)
            end
            UiPop()
        end
        
        -- Performance info
        UiPush()
        UiTranslate(0, 80)
        UiFont("regular.ttf", 18)
        UiColor(0.8, 0.8, 0.8)
        UiText("FPS: " .. sharedState.performance.fps)
        UiTranslate(0, 20)
        UiText("Bodies Processed: " .. sharedState.performance.bodiesProcessed)
        UiTranslate(0, 20)
        UiText("Performance Scale: " .. string.format("%.2f", GetFloat("savegame.mod.pcomb.global.performance_scale")))
        UiPop()
        
        -- Close button
        UiPush()
        UiTranslate(0, 120)
        UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
        if UiTextButton("Close", 100, 35) then
            pauseMenuEnabled = false
        end
        UiPop()
    end
    
    -- Debug information
    if GetBool("savegame.mod.pcomb.global.debug") then
        UiPush()
        UiTranslate(20, 20)
        UiAlign("left top")
        UiFont("regular.ttf", 16)
        UiColor(1, 1, 0)
        UiText("Physics Combo Debug")
        UiTranslate(0, 20)
        UiText("FPS: " .. sharedState.performance.fps)
        UiTranslate(0, 15)
        UiText("PRGD: " .. (systems.prgd.enabled and "ON" or "OFF"))
        UiTranslate(0, 15)
        UiText("IBSIT: " .. (systems.ibsit.enabled and "ON" or "OFF"))
        UiTranslate(0, 15)
        UiText("MBCS: " .. (systems.mbcs.enabled and "ON" or "OFF"))
        UiTranslate(0, 15)
        UiText("Bodies: " .. sharedState.performance.bodiesProcessed)
        UiPop()
    end
end