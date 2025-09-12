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

-- Material Properties Database for Enhanced Physics
PcombMaterials = {
    -- Material properties: density (kg/m³), compressive strength (MPa), collapse resistance factor (0-1)
    -- Lower collapse resistance = easier to collapse (glass = 0.1, concrete = 0.9)
    properties = {
        -- Glass materials (brittle, low density, very low collapse resistance)
        ["glass"] = {density = 2500, strength = 50, collapseResistance = 0.1, name = "Glass"},
        ["window"] = {density = 2500, strength = 45, collapseResistance = 0.15, name = "Window Glass"},
        
        -- Wood materials (medium density, medium strength, medium collapse resistance)
        ["wood"] = {density = 600, strength = 40, collapseResistance = 0.4, name = "Wood"},
        ["plank"] = {density = 650, strength = 35, collapseResistance = 0.45, name = "Plank"},
        ["log"] = {density = 700, strength = 50, collapseResistance = 0.5, name = "Log"},
        
        -- Stone/Concrete materials (high density, high strength, high collapse resistance)
        ["stone"] = {density = 2600, strength = 100, collapseResistance = 0.8, name = "Stone"},
        ["concrete"] = {density = 2400, strength = 30, collapseResistance = 0.7, name = "Concrete"},
        ["brick"] = {density = 1800, strength = 20, collapseResistance = 0.6, name = "Brick"},
        ["marble"] = {density = 2700, strength = 120, collapseResistance = 0.85, name = "Marble"},
        
        -- Metal materials (very high density, very high strength, very high collapse resistance)
        ["metal"] = {density = 7800, strength = 400, collapseResistance = 0.95, name = "Metal"},
        ["steel"] = {density = 7850, strength = 400, collapseResistance = 0.95, name = "Steel"},
        ["iron"] = {density = 7870, strength = 300, collapseResistance = 0.9, name = "Iron"},
        ["hardmetal"] = {density = 8000, strength = 500, collapseResistance = 0.98, name = "Hard Metal"},
        
        -- Plastic/Polymer materials (low density, low strength, low-medium collapse resistance)
        ["plastic"] = {density = 1200, strength = 60, collapseResistance = 0.3, name = "Plastic"},
        ["foliage"] = {density = 300, strength = 5, collapseResistance = 0.2, name = "Foliage"},
        
        -- Default fallback
        ["default"] = {density = 1000, strength = 20, collapseResistance = 0.5, name = "Default"}
    },
    
    -- Get material properties by material name
    getProperties = function(materialName)
        if not materialName then return PcombMaterials.properties["default"] end
        
        -- Try exact match first
        if PcombMaterials.properties[materialName] then
            return PcombMaterials.properties[materialName]
        end
        
        -- Try partial matches for variations
        for key, props in pairs(PcombMaterials.properties) do
            if string.find(materialName, key) or string.find(key, materialName) then
                return props
            end
        end
        
        return PcombMaterials.properties["default"]
    end,
    
    -- Calculate effective mass based on material properties
    calculateEffectiveMass = function(body, materialName)
        local baseMass = GetBodyMass(body)
        local materialProps = PcombMaterials.getProperties(materialName)
        
        -- Adjust mass based on material density vs default density
        local densityRatio = materialProps.density / 1000 -- Normalize to water density
        local effectiveMass = baseMass * densityRatio
        
        return effectiveMass, materialProps
    end,
    
    -- Calculate collapse probability based on material properties
    calculateCollapseProbability = function(materialName, loadRatio, stabilityRatio)
        local materialProps = PcombMaterials.getProperties(materialName)
        
        -- Ensure materialProps is valid
        if not materialProps or not materialProps.collapseResistance then
            materialProps = PcombMaterials.properties["default"]
        end
        
        -- Base collapse probability from load and stability
        local baseProbability = math.max(0, math.min(1, (loadRatio - stabilityRatio) / 0.5))
        
        -- Adjust by material collapse resistance
        local adjustedProbability = baseProbability * (1 - materialProps.collapseResistance)
        
        return math.max(0, math.min(1, adjustedProbability))
    end
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
        SetFloat("savegame.mod.pcomb.ibsit.collapse_threshold", 0.15)
        SetFloat("savegame.mod.pcomb.ibsit.gravity_force", 2.0)
        SetBool("savegame.mod.pcomb.ibsit.debris_cleanup", true)
        SetFloat("savegame.mod.pcomb.ibsit.cleanup_delay", 30.0)
        SetBool("savegame.mod.pcomb.ibsit.fps_optimization", true)
        SetInt("savegame.mod.pcomb.ibsit.target_fps", 30)
        SetFloat("savegame.mod.pcomb.ibsit.volume", 0.7)
        SetInt("savegame.mod.pcomb.ibsit.particle_quality", 2)
        
        -- Multi-directional analysis (enabled by default for better collapse detection)
        SetBool("savegame.mod.pcomb.materials.multi_directional", true)
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
    
    analyzeGravityCollapse = function(breakpoint, breaksize)
        local collapseCandidates = {}
        
        -- Query for bodies that might need gravity collapse analysis
        -- Use a larger search area and more inclusive query requirements
        local searchMultiplier = 3.0  -- Increased from 2.0 for better coverage
        local min = {breakpoint[1] - breaksize * searchMultiplier, 
                     breakpoint[2] - breaksize * searchMultiplier, 
                     breakpoint[3] - breaksize * searchMultiplier}
        local max = {breakpoint[1] + breaksize * searchMultiplier, 
                     breakpoint[2] + breaksize * searchMultiplier, 
                     breakpoint[3] + breaksize * searchMultiplier}
        
        -- Use more inclusive query to find all physical bodies
        QueryRequire("physical")
        local bodies = QueryAabbBodies(min, max)
        
        if GetBool("savegame.mod.pcomb.global.debug") then
            DebugPrint("Gravity collapse analysis: Found " .. #bodies .. " bodies in search area")
        end
        
        for i = 1, #bodies do
            local body = bodies[i]
            -- Include both active and inactive bodies that could potentially collapse
            -- Only exclude bodies that are already broken
            if not IsBodyBroken(body) then
                -- NEW: Proactively convert static bodies to dynamic before analysis
                -- This ensures all bodies can participate in physics simulation from the start
                if PcombDetection.isBodyStatic(body) then
                    local converted = PcombDetection.convertStaticToDynamic(body)
                    if not converted and GetBool("savegame.mod.pcomb.global.debug") then
                        DebugPrint("Failed to convert static body to dynamic: " .. tostring(body))
                    end
                end
                
                local bodyPos = GetBodyTransform(body).pos
                if bodyPos then
                    -- Check if body is within reasonable distance of breakpoint
                    local distance = VecLength(VecSub(bodyPos, breakpoint))
                    if distance <= breaksize * searchMultiplier then
                        local collapseData = PcombDetection.analyzeBodySupport(body, breakpoint)
                        if collapseData.needsCollapse then
                            collapseCandidates[body] = collapseData
                            
                            if GetBool("savegame.mod.pcomb.global.debug") then
                                DebugPrint("Body " .. tostring(body) .. " marked for collapse (distance: " .. 
                                          string.format("%.2f", distance) .. ")")
                            end
                        end
                    end
                end
            end
        end
        
        if GetBool("savegame.mod.pcomb.global.debug") then
            local collapseCount = 0
            for _ in pairs(collapseCandidates) do collapseCount = collapseCount + 1 end
            DebugPrint("Gravity collapse analysis complete: " .. collapseCount .. " bodies need collapse")
        end
        
        return collapseCandidates
    end,
    
    analyzeBodySupport = function(body, impactPoint)
        -- NEW: Convert static bodies to dynamic before analysis
        -- This ensures bodies can participate in physics simulation for collapse/impact
        if PcombDetection.isBodyStatic(body) then
            local converted = PcombDetection.convertStaticToDynamic(body)
            if not converted then
                -- If conversion failed, skip analysis for this body
                return {needsCollapse = false, conversionFailed = true}
            end
        end
        
        local bodyTransform = GetBodyTransform(body)
        local bodyPos = bodyTransform.pos
        local bodyMass = GetBodyMass(body)
        if not bodyMass then
            return {needsCollapse = false}
        end
        
        -- Get body bounds for support analysis
        local bounds = GetBodyBounds(body)
        if not bounds then return {needsCollapse = false} end
        
        -- Calculate center of mass and support points
        local centerOfMass = GetBodyCenterOfMass(body)
        local comWorldPos = TransformToParentPoint(bodyTransform, centerOfMass)
        
        -- Get material properties for this body
        local materialName = PcombDetection.getBodyMaterial(body)
        local effectiveMass, materialProps = PcombMaterials.calculateEffectiveMass(body, materialName)
        
        -- Multi-directional support analysis (conditional based on toggle)
        local supportAnalysis
        if GetBool("savegame.mod.pcomb.materials.multi_directional") then
            supportAnalysis = PcombDetection.analyzeMultiDirectionalSupport(body, bounds, materialName)
        else
            -- Fallback to basic support analysis when multi-directional is disabled
            local supportingBodies = PcombDetection.findSupportingBodies(body, bounds)
            local totalSupportMass = 0
            local totalSupportArea = 0
            
            for _, supportBody in ipairs(supportingBodies) do
                if IsBodyActive(supportBody) then
                    totalSupportMass = totalSupportMass + GetBodyMass(supportBody)
                    -- Estimate support area based on body bounds
                    local supportBounds = GetBodyBounds(supportBody)
                    if supportBounds then
                        local supportArea = (supportBounds[4] - supportBounds[1]) * (supportBounds[6] - supportBounds[3])
                        totalSupportArea = totalSupportArea + supportArea
                    end
                end
            end
            
            -- Create simplified support analysis structure
            supportAnalysis = {
                supportingBodies = supportingBodies,
                totalSupportMass = totalSupportMass,
                totalSupportArea = totalSupportArea,
                bodyBaseArea = (bounds[4] - bounds[1]) * (bounds[6] - bounds[3]),
                directionalSupport = {
                    below = {bodies = supportingBodies, mass = totalSupportMass, area = totalSupportArea},
                    above = {bodies = {}, mass = 0, area = 0},
                    sides = {bodies = {}, mass = 0, area = 0}
                }
            }
        end
        
        -- Calculate overall stability metrics
        local stabilityRatio = supportAnalysis.totalSupportMass / effectiveMass
        local supportAreaRatio = supportAnalysis.totalSupportArea / supportAnalysis.bodyBaseArea
        
        -- Material-specific collapse threshold adjustments
        local baseThreshold = GetFloat("savegame.mod.pcomb.ibsit.collapse_threshold")
        local materialAdjustedThreshold = baseThreshold * (1 - materialProps.collapseResistance * 0.3)
        
        -- Calculate load distribution and stress factors
        local loadFactor = PcombDetection.calculateLoadFactor(body, supportAnalysis.supportingBodies)
        local stressFactor = PcombDetection.calculateStressFactor(body, supportAnalysis)
        
        -- Enhanced collapse probability calculation
        local collapseProbability = PcombMaterials.calculateCollapseProbability(
            materialName, 
            loadFactor, 
            math.min(stabilityRatio, supportAreaRatio)
        )
        
        -- NEW: Minimum support area threshold based on body weight
        local minSupportAreaRatio = PcombDetection.calculateMinimumSupportArea(body, materialProps, effectiveMass)
        
        -- NEW: Check for minimal connections that shouldn't prevent collapse
        local hasMinimalSupport = PcombDetection.checkMinimalSupport(supportAnalysis, bounds, materialProps)
        
        -- NEW: Enhanced torque-based stability analysis
        local stabilityAnalysis = PcombDetection.checkRotationalStability(body, supportAnalysis, materialProps)
        
        -- NEW: Apply progressive failure if needed
        local progressiveFailureApplied = false
        if not stabilityAnalysis.isStable then
            progressiveFailureApplied = PcombDetection.applyProgressiveFailure(body, stabilityAnalysis, materialProps)
        end
        
        -- Enhanced collapse criteria with torque analysis
        local torqueBasedCollapse = false
        local torqueCollapseStrength = 0
        
        if not stabilityAnalysis.isStable then
            -- Calculate collapse strength based on torque ratio
            torqueCollapseStrength = math.max(0, 1 - stabilityAnalysis.torqueRatio)
            torqueBasedCollapse = true
            
            if GetBool("savegame.mod.pcomb.global.debug") then
                DebugPrint("Torque-based collapse detected: " .. stabilityAnalysis.collapseDirection .. 
                          " (ratio: " .. string.format("%.2f", stabilityAnalysis.torqueRatio) .. ")")
            end
        end
        
        -- Determine if collapse is needed
        local needsCollapse = false
        local collapseStrength = 0
        
        -- Multiple collapse criteria with improved weight consideration
        if stabilityRatio < materialAdjustedThreshold * 0.8 or 
           supportAreaRatio < minSupportAreaRatio or  -- Use minimum support area threshold
           collapseProbability > 0.2 or
           stressFactor > materialProps.strength * 0.6 or
           hasMinimalSupport or  -- Check for minimal connections
           torqueBasedCollapse then  -- NEW: Include torque-based collapse
           
            needsCollapse = true
            collapseStrength = math.max(
                (materialAdjustedThreshold - stabilityRatio) / materialAdjustedThreshold,
                (materialAdjustedThreshold - supportAreaRatio) / materialAdjustedThreshold,
                collapseProbability,
                stressFactor / materialProps.strength,
                torqueCollapseStrength  -- NEW: Include torque-based strength
            )
            collapseStrength = math.min(collapseStrength, 1.0)
        end
        
        -- Add debug output for collapse detection
        if GetBool("savegame.mod.pcomb.global.debug") then
            DebugPrint("Body collapse analysis for " .. tostring(body) .. ":")
            DebugPrint("  Material: " .. materialName .. " (resistance: " .. string.format("%.2f", materialProps.collapseResistance) .. ")")
            DebugPrint("  Stability ratio: " .. string.format("%.3f", stabilityRatio) .. " (threshold: " .. string.format("%.3f", materialAdjustedThreshold * 0.8) .. ")")
            DebugPrint("  Support area ratio: " .. string.format("%.3f", supportAreaRatio) .. " (min required: " .. string.format("%.3f", minSupportAreaRatio) .. ")")
            DebugPrint("  Collapse probability: " .. string.format("%.3f", collapseProbability) .. " (threshold: 0.2)")
            DebugPrint("  Stress factor: " .. string.format("%.3f", stressFactor) .. " (threshold: " .. string.format("%.3f", materialProps.strength * 0.6) .. ")")
            DebugPrint("  Has minimal support: " .. tostring(hasMinimalSupport))
            DebugPrint("  Torque-based collapse: " .. tostring(torqueBasedCollapse) .. " (strength: " .. string.format("%.3f", torqueCollapseStrength) .. ")")
            DebugPrint("  NEEDS COLLAPSE: " .. tostring(needsCollapse) .. " (strength: " .. string.format("%.3f", collapseStrength) .. ")")
            DebugPrint("---")
        end
        
        return {
            needsCollapse = needsCollapse,
            collapseStrength = collapseStrength,
            stabilityRatio = stabilityRatio,
            supportAreaRatio = supportAreaRatio,
            centerOfMass = comWorldPos,
            bodyMass = bodyMass,
            effectiveMass = effectiveMass,
            materialName = materialName,
            materialProps = materialProps,
            supportBodies = supportAnalysis.supportingBodies,
            loadFactor = loadFactor,
            stressFactor = stressFactor,
            collapseProbability = collapseProbability,
            -- NEW: Include torque analysis results
            stabilityAnalysis = stabilityAnalysis,
            progressiveFailureApplied = progressiveFailureApplied,
            torqueCollapseStrength = torqueCollapseStrength
        }
    end,
    
    findSupportingBodies = function(body, bounds)
        local supportingBodies = {}
        
        -- Look for bodies below this one
        local queryMin = {bounds[1] - 1, bounds[2] - 2, bounds[3] - 1}
        local queryMax = {bounds[4] + 1, bounds[2] + 0.5, bounds[6] + 1}
        
        QueryRequire("physical")
        local nearbyBodies = QueryAabbBodies(queryMin, queryMax)
        
        for _, nearbyBody in ipairs(nearbyBodies) do
            if nearbyBody ~= body and IsBodyActive(nearbyBody) then
                -- NEW: Proactively convert static supporting bodies to dynamic
                -- This ensures supporting bodies can participate in physics simulation
                if PcombDetection.isBodyStatic(nearbyBody) then
                    local converted = PcombDetection.convertStaticToDynamic(nearbyBody)
                    if not converted and GetBool("savegame.mod.pcomb.global.debug") then
                        DebugPrint("Failed to convert static supporting body to dynamic: " .. tostring(nearbyBody))
                    end
                end
                
                local nearbyBounds = GetBodyBounds(nearbyBody)
                if nearbyBounds and type(nearbyBounds) == "table" and #nearbyBounds >= 6 then
                    -- Validate bounds array before arithmetic operations
                    local boundsValid = true
                    for i = 1, 6 do
                        if not nearbyBounds[i] or type(nearbyBounds[i]) ~= "number" then
                            boundsValid = false
                            break
                        end
                    end
                    
                    if boundsValid and nearbyBounds[5] >= bounds[2] - 0.1 then
                        -- Body is at or above our base level
                        table.insert(supportingBodies, nearbyBody)
                    end
                end
            end
        end
        
        return supportingBodies
    end,
    
    calculateOverlapArea = function(bounds1, bounds2)
        -- Validate bounds before arithmetic operations
        if not bounds1 or type(bounds1) ~= "table" or #bounds1 < 6 or
           not bounds2 or type(bounds2) ~= "table" or #bounds2 < 6 then
            return 0
        end
        
        for i = 1, 6 do
            if not bounds1[i] or type(bounds1[i]) ~= "number" or
               not bounds2[i] or type(bounds2[i]) ~= "number" then
                return 0
            end
        end
        
        -- Calculate overlapping area between two bounding boxes
        local xOverlap = math.max(0, math.min(bounds1[4], bounds2[4]) - math.max(bounds1[1], bounds2[1]))
        local zOverlap = math.max(0, math.min(bounds1[6], bounds2[6]) - math.max(bounds1[3], bounds2[3]))
        
        return xOverlap * zOverlap
    end,
    
    getBodyVoxelCount = function(body)
        local count = 0
        local shapes = GetBodyShapes(body)
        for i = 1, #shapes do
            count = count + GetShapeVoxelCount(shapes[i])
        end
        return count
    end,
    
    getBodyMaterial = function(body)
        local shapes = GetBodyShapes(body)
        if #shapes == 0 then return "default" end
        
        -- Get material from the largest shape
        local largestShape = shapes[1]
        local maxVoxels = GetShapeVoxelCount(largestShape)
        
        for i = 2, #shapes do
            local voxelCount = GetShapeVoxelCount(shapes[i])
            if voxelCount > maxVoxels then
                largestShape = shapes[i]
                maxVoxels = voxelCount
            end
        end
        
        -- Get material at center of shape
        local bounds = GetShapeBounds(largestShape)
        if bounds then
            -- ADD: Validate bounds before arithmetic
            if type(bounds) == "table" and #bounds >= 6 then
                local allValid = true
                for j = 1, 6 do
                    if not bounds[j] or type(bounds[j]) ~= "number" then
                        allValid = false
                        break
                    end
                end
                if allValid then
                    local center = {
                        (bounds[1] + bounds[4]) / 2,  -- Now safe
                        (bounds[2] + bounds[5]) / 2,
                        (bounds[3] + bounds[6]) / 2
                    }
                    local _, _, _, _, _, material = GetShapeMaterialAtPosition(largestShape, center)
                    return material or "default"
                end
            end
        end
        
        return "default"
    end,
    
    analyzeMultiDirectionalSupport = function(body, bounds, materialName)
        local analysis = {
            supportingBodies = {},
            totalSupportMass = 0,
            totalSupportArea = 0,
            bodyBaseArea = 1.0,  -- Initialize to prevent errors
            directionalSupport = {
                below = {bodies = {}, mass = 0, area = 0},
                above = {bodies = {}, mass = 0, area = 0},
                sides = {bodies = {}, mass = 0, area = 0}
            }
        }
        
        -- ADD: Validate bounds before arithmetic
        if not bounds or type(bounds) ~= "table" or #bounds < 6 then
            return analysis  -- Return empty analysis if bounds are invalid
        end
        for i = 1, 6 do
            if not bounds[i] or type(bounds[i]) ~= "number" then
                return analysis  -- Skip if any bound is nil or not a number
            end
        end
        
        -- Now safe to perform arithmetic
        analysis.bodyBaseArea = (bounds[4] - bounds[1]) * (bounds[6] - bounds[3])
        
        -- Ensure bodyBaseArea is valid
        if not analysis.bodyBaseArea or analysis.bodyBaseArea <= 0 then
            analysis.bodyBaseArea = 1.0  -- Fallback to prevent division by zero
        end
        
        -- Query for nearby bodies in expanded area (now safe)
        local queryMin = {bounds[1] - 3, bounds[2] - 3, bounds[3] - 3}
        local queryMax = {bounds[4] + 3, bounds[5] + 3, bounds[6] + 3}
        
        QueryRequire("physical")
        local nearbyBodies = QueryAabbBodies(queryMin, queryMax)
        
        for _, nearbyBody in ipairs(nearbyBodies) do
            if nearbyBody ~= body and IsBodyActive(nearbyBody) then
                -- NEW: Proactively convert static bodies to dynamic before multi-directional analysis
                -- This ensures all bodies can participate in physics simulation
                if PcombDetection.isBodyStatic(nearbyBody) then
                    local converted = PcombDetection.convertStaticToDynamic(nearbyBody)
                    if not converted and GetBool("savegame.mod.pcomb.global.debug") then
                        DebugPrint("Failed to convert static body in multi-directional analysis to dynamic: " .. tostring(nearbyBody))
                    end
                end
                
                local nearbyBounds = GetBodyBounds(nearbyBody)
                if nearbyBounds then
                    local direction = PcombDetection.classifyBodyDirection(bounds, nearbyBounds)
                    local overlapArea = PcombDetection.calculateOverlapArea(bounds, nearbyBounds)
                    
                    if overlapArea > 0 then
                        local nearbyMass = GetBodyMass(nearbyBody)
                        local nearbyMaterial = PcombDetection.getBodyMaterial(nearbyBody)
                        local _, nearbyProps = PcombMaterials.calculateEffectiveMass(nearbyBody, nearbyMaterial)
                        
                        -- Material interaction factor (how well materials support each other)
                        local interactionFactor = PcombDetection.calculateMaterialInteraction(materialName, nearbyMaterial)
                        
                        table.insert(analysis.supportingBodies, nearbyBody)
                        analysis.totalSupportMass = analysis.totalSupportMass + (nearbyMass * interactionFactor)
                        analysis.totalSupportArea = analysis.totalSupportArea + (overlapArea * interactionFactor)
                        
                        -- Add to directional analysis
                        if direction == "below" then
                            table.insert(analysis.directionalSupport.below.bodies, nearbyBody)
                            analysis.directionalSupport.below.mass = analysis.directionalSupport.below.mass + (nearbyMass * interactionFactor)
                            analysis.directionalSupport.below.area = analysis.directionalSupport.below.area + (overlapArea * interactionFactor)
                        elseif direction == "above" then
                            table.insert(analysis.directionalSupport.above.bodies, nearbyBody)
                            analysis.directionalSupport.above.mass = analysis.directionalSupport.above.mass + (nearbyMass * interactionFactor)
                            analysis.directionalSupport.above.area = analysis.directionalSupport.above.area + (overlapArea * interactionFactor)
                        else
                            table.insert(analysis.directionalSupport.sides.bodies, nearbyBody)
                            analysis.directionalSupport.sides.mass = analysis.directionalSupport.sides.mass + (nearbyMass * interactionFactor)
                            analysis.directionalSupport.sides.area = analysis.directionalSupport.sides.area + (overlapArea * interactionFactor)
                        end
                    end
                end
            end
        end
        
        return analysis
    end,
    
    classifyBodyDirection = function(bounds1, bounds2)
        -- ADD: Validate bounds1 and bounds2
        if not bounds1 or type(bounds1) ~= "table" or #bounds1 < 6 or
           not bounds2 or type(bounds2) ~= "table" or #bounds2 < 6 then
            return "adjacent"  -- Default fallback
        end
        for i = 1, 6 do
            if not bounds1[i] or type(bounds1[i]) ~= "number" or
               not bounds2[i] or type(bounds2[i]) ~= "number" then
                return "adjacent"
            end
        end
        
        local center1 = {
            (bounds1[1] + bounds1[4]) / 2,  -- Now safe
            (bounds1[2] + bounds1[5]) / 2,
            (bounds1[3] + bounds1[6]) / 2
        }
        local center2 = {
            (bounds2[1] + bounds2[4]) / 2,
            (bounds2[2] + bounds2[5]) / 2,
            (bounds2[3] + bounds2[6]) / 2
        }
        
        local deltaY = center2[2] - center1[2]
        local deltaX = math.abs(center2[1] - center1[1])
        local deltaZ = math.abs(center2[3] - center1[3])
        
        -- Determine primary direction
        if deltaY > 1.0 then
            return "above"
        elseif deltaY < -1.0 then
            return "below"
        elseif deltaX > 0.5 or deltaZ > 0.5 then
            return "side"
        else
            return "adjacent"
        end
    end,
    
    calculateMaterialInteraction = function(material1, material2)
        local props1 = PcombMaterials.getProperties(material1)
        local props2 = PcombMaterials.getProperties(material2)
        
        -- Calculate interaction based on material compatibility
        -- Similar materials interact better (e.g., wood on wood, metal on metal)
        local densityDiff = math.abs(props1.density - props2.density) / math.max(props1.density, props2.density)
        local strengthDiff = math.abs(props1.strength - props2.strength) / math.max(props1.strength, props2.strength)
        
        -- Lower difference = better interaction
        local compatibility = 1 - (densityDiff * 0.3 + strengthDiff * 0.7)
        
        return math.max(0.1, compatibility) -- Minimum interaction factor
    end,
    
    calculateLoadFactor = function(body, supportingBodies)
        if #supportingBodies == 0 then return 1.0 end
        
        local bodyMass = GetBodyMass(body)
        if not bodyMass then
            return 1.0
        end
        local totalSupportMass = 0
        
        for _, supportBody in ipairs(supportingBodies) do
            if IsBodyActive(supportBody) then
                totalSupportMass = totalSupportMass + GetBodyMass(supportBody)
            end
        end
        
        -- Load factor = body mass / total supporting mass
        -- Higher values indicate more load relative to support
        return bodyMass / math.max(totalSupportMass, bodyMass * 0.1)
    end,
    
    calculateStressFactor = function(body, supportAnalysis)
        local bodyMass = GetBodyMass(body)
        if not bodyMass then
            return 0
        end
        local bodyBounds = GetBodyBounds(body)
        
        -- ADD: Validate bodyBounds to prevent nil arithmetic errors
        if not bodyBounds or type(bodyBounds) ~= "table" or #bodyBounds < 6 then
            return 0
        end
        for i = 1, 6 do
            if not bodyBounds[i] or type(bodyBounds[i]) ~= "number" then
                return 0
            end
        end
        
        -- Calculate stress based on mass distribution and support area
        local baseArea = (bodyBounds[4] - bodyBounds[1]) * (bodyBounds[6] - bodyBounds[3])
        local stressPerArea = bodyMass / math.max(baseArea, 0.1)
        
        -- Adjust for support quality
        local supportQuality = supportAnalysis.totalSupportArea / math.max(supportAnalysis.bodyBaseArea, 0.1)
        
        return stressPerArea / math.max(supportQuality, 0.1)
    end,
    
    -- NEW: Calculate minimum support area required based on body weight and material
    calculateMinimumSupportArea = function(body, materialProps, effectiveMass)
        local bodyBounds = GetBodyBounds(body)
        if not bodyBounds or type(bodyBounds) ~= "table" or #bodyBounds < 6 then
            return 0.1 -- Default minimum
        end
        
        local baseArea = (bodyBounds[4] - bodyBounds[1]) * (bodyBounds[6] - bodyBounds[3])
        if baseArea <= 0 then return 0.1 end
        
        -- Minimum support area scales with mass and material properties
        -- Heavier materials need more support, brittle materials need more stable support
        local massFactor = math.min(effectiveMass / 1000, 5) -- Cap at 5x for very heavy objects
        local materialFactor = 1 + (1 - materialProps.collapseResistance) * 0.5 -- Brittle materials need more support
        
        -- Minimum support area is 15-40% of base area depending on weight/material
        local minSupportRatio = 0.15 + (massFactor * materialFactor * 0.05)
        return math.min(minSupportRatio, 0.6) -- Cap at 60% to prevent impossible requirements
    end,
    
    -- NEW: Check if body has only minimal connections that shouldn't prevent collapse
    checkMinimalSupport = function(supportAnalysis, bounds, materialProps)
        if #supportAnalysis.supportingBodies == 0 then return true end
        
        -- Validate bounds array before arithmetic operations
        if not bounds or type(bounds) ~= "table" or #bounds < 6 then
            return true -- Assume minimal support if bounds are invalid
        end
        
        for i = 1, 6 do
            if not bounds[i] or type(bounds[i]) ~= "number" then
                return true -- Assume minimal support if bounds contain invalid values
            end
        end
        
        -- Calculate total support dimensions
        local totalSupportWidth = 0
        local totalSupportDepth = 0
        
        for _, supportBody in ipairs(supportAnalysis.supportingBodies) do
            if IsBodyActive(supportBody) then
                local supportBounds = GetBodyBounds(supportBody)
                if supportBounds and type(supportBounds) == "table" and #supportBounds >= 6 then
                    -- Validate supportBounds before arithmetic operations
                    local supportValid = true
                    for i = 1, 6 do
                        if not supportBounds[i] or type(supportBounds[i]) ~= "number" then
                            supportValid = false
                            break
                        end
                    end
                    
                    if supportValid then
                        -- Calculate overlap dimensions
                        local overlapWidth = math.max(0, math.min(bounds[4], supportBounds[4]) - math.max(bounds[1], supportBounds[1]))
                        local overlapDepth = math.max(0, math.min(bounds[6], supportBounds[6]) - math.max(bounds[3], supportBounds[3]))
                        
                        totalSupportWidth = totalSupportWidth + overlapWidth
                        totalSupportDepth = totalSupportDepth + overlapDepth
                    end
                end
            end
        end
        
        -- Body dimensions
        local bodyWidth = bounds[4] - bounds[1]
        local bodyDepth = bounds[6] - bounds[3]
        
        -- Check if support is minimal (less than 20% of body dimensions)
        local widthSupportRatio = totalSupportWidth / math.max(bodyWidth, 0.1)
        local depthSupportRatio = totalSupportDepth / math.max(bodyDepth, 0.1)
        
        -- If support is very minimal in either dimension, body should collapse
        local minimalThreshold = 0.2 -- 20% minimum support
        local isMinimalSupport = widthSupportRatio < minimalThreshold or depthSupportRatio < minimalThreshold
        
        -- Additional check: if total support area is less than 10% of body base area
        local bodyBaseArea = bodyWidth * bodyDepth
        local supportAreaRatio = supportAnalysis.totalSupportArea / math.max(bodyBaseArea, 0.1)
        local isVeryMinimalSupport = supportAreaRatio < 0.1
        
        return isMinimalSupport or isVeryMinimalSupport
    end,
    
    -- NEW: Check if a body is static and needs conversion to dynamic
    isBodyStatic = function(body)
        -- In Teardown, static bodies don't participate in physics simulation
        -- We can check this by seeing if the body has any dynamic behavior
        if not IsBodyActive(body) then return true end
        
        -- Check if body is marked as static (this is engine-specific)
        -- Try to detect static bodies by their behavior characteristics
        local velocity = GetBodyVelocity(body)
        local angularVelocity = GetBodyAngularVelocity(body)
        
        -- Static bodies typically have zero velocity and don't respond to forces
        -- Also check if body is kinematic (controlled by animation/script)
        local isKinematic = GetBodyMass(body) < 0.01 -- Very light bodies might be kinematic
        
        return (VecLength(velocity) < 0.001 and VecLength(angularVelocity) < 0.001) or isKinematic
    end,
    
    -- NEW: Convert a static body to dynamic so it can participate in physics
    convertStaticToDynamic = function(body)
        if not PcombDetection.isBodyStatic(body) then return false end
        
        -- NEW: Check body size threshold to avoid converting small debris
        local voxelCount = PcombDetection.getBodyVoxelCount(body)
        local sizeThreshold = GetInt("savegame.mod.pcomb.conversion.size_threshold") or 100  -- Configurable threshold, default 100 voxels
        
        if voxelCount < sizeThreshold then
            if GetBool("savegame.mod.pcomb.global.debug") then
                DebugPrint("Skipped conversion of small body: " .. tostring(body) .. " (voxels: " .. voxelCount .. ")")
            end
            return false
        end
        
        -- Enable physics simulation for this body
        SetBodyActive(body, true)
        SetBodyDynamic(body, true)
        -- Note: In Teardown, body mass is automatically calculated from shape properties
        -- and cannot be manually set. The engine handles this automatically.
        
        -- Reset any kinematic constraints that might prevent physics
        -- This ensures the body can now fall and interact with other bodies
        
        if GetBool("savegame.mod.pcomb.global.debug") then
            DebugPrint("Converted static body to dynamic: " .. tostring(body) .. " (voxels: " .. voxelCount .. ")")
        end
        
        return true
    end,
    
    -- Enhanced multi-body structure analysis with spatial partitioning
    analyzeMultiBodyStructure = function(seedBody, impactPoint)
        -- Initialize spatial partition if needed
        if not PcombDetection.spatialPartition.octree then
            PcombDetection.initSpatialPartition()
        end

        -- Use GetJointedBodies to find all connected bodies in the structure
        local jointedBodies = GetJointedBodies(seedBody)
        if not jointedBodies or #jointedBodies == 0 then
            -- Fallback to single body analysis
            return PcombDetection.analyzeBodySupport(seedBody, impactPoint)
        end

        -- Add the seed body to the structure
        local structureBodies = {seedBody}
        for _, body in ipairs(jointedBodies) do
            table.insert(structureBodies, body)
        end

        -- NEW: Use spatial partitioning to limit analysis to nearby bodies
        local nearbyBodies = PcombDetection.queryBodiesInRadius(impactPoint, 50, PcombDetection.spatialPartition.octree)
        local relevantBodies = {}

        -- Filter structure bodies to only include those in the nearby area
        for _, body in ipairs(structureBodies) do
            local bodyPos = GetBodyTransform(body).pos
            if bodyPos and VecLength(VecSub(bodyPos, impactPoint)) <= 50 then
                table.insert(relevantBodies, body)
            end
        end

        -- Use relevant bodies for analysis
        structureBodies = relevantBodies

        -- Analyze the entire multi-body structure with batch processing
        local structureAnalysis = PcombDetection.batchAnalyzeStructure(structureBodies, impactPoint)

        return structureAnalysis
    end,
    
    -- NEW: Calculate structural integrity based on base support percentage
    calculateStructuralIntegrity = function(structureAnalysis)
        if #structureAnalysis.bodies == 0 then return 0 end
        
        local totalBaseSupport = 0
        local totalBaseArea = 0
        
        -- Calculate base support for the entire structure
        for _, body in ipairs(structureAnalysis.bodies) do
            local bodyAnalysis = structureAnalysis.supportAnalysis[body]
            if bodyAnalysis then
                totalBaseSupport = totalBaseSupport + bodyAnalysis.supportAreaRatio
                totalBaseArea = totalBaseArea + 1 -- Normalize by body count
            end
        end
        
        -- Structural integrity is the average support ratio across all bodies
        local integrity = totalBaseArea > 0 and (totalBaseSupport / totalBaseArea) or 0
        
        -- Apply material-specific modifiers
        local materialModifier = 1.0
        for _, body in ipairs(structureAnalysis.bodies) do
            local bodyAnalysis = structureAnalysis.supportAnalysis[body]
            if bodyAnalysis and bodyAnalysis.materialProps then
                -- Brittle materials reduce overall integrity
                materialModifier = materialModifier * bodyAnalysis.materialProps.collapseResistance
            end
        end
        
        return math.max(0, math.min(1, integrity * materialModifier))
    end,
    
    -- NEW: Analyze force distribution across multi-body structure
    analyzeForceDistribution = function(structureAnalysis, impactPoint)
        local forceDistribution = {
            verticalForces = {},
            horizontalForces = {},
            torqueDistribution = {},
            stressPoints = {},
            weakPoints = {}
        }
        
        -- Calculate gravitational forces for each body
        for _, body in ipairs(structureAnalysis.bodies) do
            local bodyAnalysis = structureAnalysis.supportAnalysis[body]
            if bodyAnalysis then
                local bodyMass = bodyAnalysis.effectiveMass or bodyAnalysis.bodyMass
                local gravityForce = {0, -bodyMass * 9.81, 0}
                
                -- Calculate force distribution from center of mass
                local bodyCOM = bodyAnalysis.centerOfMass
                local distanceFromImpact = VecLength(VecSub(bodyCOM, impactPoint))
                
                -- Force magnitude decreases with distance from impact
                local distanceFactor = math.max(0.1, 1 - (distanceFromImpact / 20))
                local adjustedForce = {
                    gravityForce[1] * distanceFactor,
                    gravityForce[2] * distanceFactor,
                    gravityForce[3] * distanceFactor
                }
                
                forceDistribution.verticalForces[body] = adjustedForce
                
                -- Calculate horizontal forces based on structural connections
                local horizontalForce = PcombDetection.calculateHorizontalForces(body, structureAnalysis)
                forceDistribution.horizontalForces[body] = horizontalForce
                
                -- Calculate torque distribution
                local torqueDist = PcombDetection.calculateTorqueDistribution(body, structureAnalysis, impactPoint)
                forceDistribution.torqueDistribution[body] = torqueDist
                
                -- Identify stress points and weak points
                if bodyAnalysis.stressFactor and bodyAnalysis.stressFactor > 100 then
                    table.insert(forceDistribution.stressPoints, {
                        body = body,
                        stress = bodyAnalysis.stressFactor,
                        position = bodyCOM
                    })
                end
                
                if bodyAnalysis.collapseProbability and bodyAnalysis.collapseProbability > 0.5 then
                    table.insert(forceDistribution.weakPoints, {
                        body = body,
                        weakness = bodyAnalysis.collapseProbability,
                        position = bodyCOM
                    })
                end
            end
        end
        
        return forceDistribution
    end,
    
    -- NEW: Calculate horizontal forces based on structural connections
    calculateHorizontalForces = function(body, structureAnalysis)
        local horizontalForce = {0, 0, 0}
        
        -- Find connected bodies and calculate lateral forces
        for _, otherBody in ipairs(structureAnalysis.bodies) do
            if otherBody ~= body then
                local connectionForce = PcombDetection.calculateConnectionForce(body, otherBody)
                horizontalForce[1] = horizontalForce[1] + connectionForce[1]
                horizontalForce[2] = horizontalForce[2] + connectionForce[2]
                horizontalForce[3] = horizontalForce[3] + connectionForce[3]
            end
        end
        
        return horizontalForce
    end,
    
    -- NEW: Calculate forces between connected bodies
    calculateConnectionForce = function(body1, body2)
        local body1Transform = GetBodyTransform(body1)
        local body2Transform = GetBodyTransform(body2)
        
        if not body1Transform or not body2Transform then
            return {0, 0, 0}
        end
        
        local body1Pos = body1Transform.pos
        local body2Pos = body2Transform.pos
        
        -- Calculate distance and direction between bodies
        local direction = {
            body2Pos[1] - body1Pos[1],
            body2Pos[2] - body1Pos[2],
            body2Pos[3] - body1Pos[3]
        }
        
        local distance = VecLength(direction)
        if distance < 0.1 then return {0, 0, 0} end
        
        -- Normalize direction
        local normalizedDir = {
            direction[1] / distance,
            direction[2] / distance,
            direction[3] / distance
        }
        
        -- Calculate connection force based on body masses and distance
        local body1Mass = GetBodyMass(body1) or 0
        local body2Mass = GetBodyMass(body2) or 0
        local combinedMass = body1Mass + body2Mass
        
        if combinedMass == 0 then return {0, 0, 0} end
        
        -- Force magnitude based on gravitational attraction between bodies
        local forceMagnitude = (body1Mass * body2Mass) / (distance * distance) * 0.001
        
        return {
            normalizedDir[1] * forceMagnitude,
            normalizedDir[2] * forceMagnitude,
            normalizedDir[3] * forceMagnitude
        }
    end,
    
    -- NEW: Calculate torque distribution for multi-body analysis
    calculateTorque = function(force, centerOfMass, point)
        -- Calculate torque as cross product of lever arm and force
        -- Torque = r × F, where r is vector from center of mass to point
        local leverArm = {
            point[1] - centerOfMass[1],
            point[2] - centerOfMass[2],
            point[3] - centerOfMass[3]
        }
        
        -- Cross product: (leverArm × force)
        -- For 3D vectors A = (Ax, Ay, Az) and B = (Bx, By, Bz)
        -- A × B = (Ay*Bz - Az*By, Az*Bx - Ax*Bz, Ax*By - Ay*Bx)
        local torqueX = leverArm[2] * force[3] - leverArm[3] * force[2]
        local torqueY = leverArm[3] * force[1] - leverArm[1] * force[3]
        local torqueZ = leverArm[1] * force[2] - leverArm[2] * force[1]
        
        -- Return magnitude of torque vector
        return math.sqrt(torqueX*torqueX + torqueY*torqueY + torqueZ*torqueZ)
    end,
    
    calculateTorqueDistribution = function(body, structureAnalysis, impactPoint)
        local bodyAnalysis = structureAnalysis.supportAnalysis[body]
        if not bodyAnalysis then return {magnitude = 0, direction = {0, 0, 0}} end
        
        local bodyCOM = bodyAnalysis.centerOfMass
        local bodyMass = bodyAnalysis.effectiveMass or bodyAnalysis.bodyMass
        
        -- Calculate torque from gravitational force
        local gravityForce = {0, -bodyMass * 9.81, 0}
        local torqueMagnitude = PcombDetection.calculateTorque(gravityForce, bodyCOM, impactPoint)
        
        -- Calculate torque direction (simplified for 2D analysis)
        local torqueDirection = {0, 0, 0}
        if torqueMagnitude > 0 then
            local toImpact = {
                impactPoint[1] - bodyCOM[1],
                0, -- Ignore Y for horizontal torque
                impactPoint[3] - bodyCOM[3]
            }
            local magnitude = VecLength(toImpact)
            if magnitude > 0 then
                torqueDirection = {
                    toImpact[1] / magnitude,
                    0,
                    toImpact[3] / magnitude
                }
            end
        end
        
        return {
            magnitude = torqueMagnitude,
            direction = torqueDirection,
            centerOfMass = bodyCOM
        }
    end,
    
    -- NEW: Implement chain reaction collapse mechanics
    processChainReaction = function(structureAnalysis, impactPoint)
        if not structureAnalysis.needsCollapse then return end
        
        local processedBodies = {}
        local collapseQueue = {}
        
        -- Start with bodies that already need collapse
        for _, body in ipairs(structureAnalysis.chainReactionBodies) do
            table.insert(collapseQueue, body)
        end
        
        -- Process chain reactions
        while #collapseQueue > 0 do
            local currentBody = table.remove(collapseQueue, 1)
            
            if not processedBodies[currentBody] then
                processedBodies[currentBody] = true
                
                -- Apply collapse to current body
                local bodyAnalysis = structureAnalysis.supportAnalysis[currentBody]
                if bodyAnalysis then
                    PcombEffects.applyGravityCollapse(currentBody, bodyAnalysis)
                end
                
                -- Find bodies that might be affected by this collapse
                local affectedBodies = PcombDetection.findAffectedBodies(currentBody, structureAnalysis)
                
                for _, affectedBody in ipairs(affectedBodies) do
                    if not processedBodies[affectedBody] then
                        -- NEW: Proactively convert affected bodies to dynamic before analysis
                        -- This ensures chain reaction bodies can participate in physics simulation
                        if PcombDetection.isBodyStatic(affectedBody) then
                            local converted = PcombDetection.convertStaticToDynamic(affectedBody)
                            if not converted and GetBool("savegame.mod.pcomb.global.debug") then
                                DebugPrint("Failed to convert static affected body to dynamic: " .. tostring(affectedBody))
                            end
                        end
                        
                        -- Check if this body now needs to collapse due to the chain reaction
                        local updatedAnalysis = PcombDetection.analyzeBodySupport(affectedBody, impactPoint)
                        
                        if updatedAnalysis.needsCollapse then
                            table.insert(collapseQueue, affectedBody)
                            structureAnalysis.supportAnalysis[affectedBody] = updatedAnalysis
                        end
                    end
                end
            end
        end
        
        if GetBool("savegame.mod.pcomb.global.debug") then
            DebugPrint("Chain reaction processed " .. #processedBodies .. " bodies")
        end
    end,
    
    -- NEW: Find bodies affected by a collapsing body
    findAffectedBodies = function(collapsingBody, structureAnalysis)
        local affectedBodies = {}
        local collapsingBounds = GetBodyBounds(collapsingBody)
        
        if not collapsingBounds then return affectedBodies end
        
        -- Find bodies above or adjacent to the collapsing body
        for _, body in ipairs(structureAnalysis.bodies) do
            if body ~= collapsingBody then
                -- NEW: Proactively convert potentially affected bodies to dynamic
                -- This ensures affected bodies can participate in physics simulation
                if PcombDetection.isBodyStatic(body) then
                    local converted = PcombDetection.convertStaticToDynamic(body)
                    if not converted and GetBool("savegame.mod.pcomb.global.debug") then
                        DebugPrint("Failed to convert static affected body to dynamic: " .. tostring(body))
                    end
                end
                
                local bodyBounds = GetBodyBounds(body)
                if bodyBounds then
                    -- Validate bounds array before arithmetic operations
                    if type(bodyBounds) == "table" and #bodyBounds >= 6 then
                        local allValid = true
                        for i = 1, 6 do
                            if not bodyBounds[i] or type(bodyBounds[i]) ~= "number" then
                                allValid = false
                                break
                            end
                        end
                        
                        if allValid then
                            -- Check if body is above or adjacent to collapsing body
                            local verticalOverlap = math.min(collapsingBounds[5], bodyBounds[5]) - 
                                                  math.max(collapsingBounds[2], bodyBounds[2])
                            local horizontalDistance = PcombDetection.calculateHorizontalDistance(collapsingBounds, bodyBounds)
                            
                            -- Body is affected if it's above (positive vertical overlap) or very close horizontally
                            if verticalOverlap > 0 or horizontalDistance < 2.0 then
                                table.insert(affectedBodies, body)
                            end
                        end
                    end
                end
            end
        end
        
        return affectedBodies
    end,
    
    -- NEW: Calculate horizontal distance between two bounding boxes
    calculateHorizontalDistance = function(bounds1, bounds2)
        -- Validate bounds before arithmetic operations
        if not bounds1 or type(bounds1) ~= "table" or #bounds1 < 6 or
           not bounds2 or type(bounds2) ~= "table" or #bounds2 < 6 then
            return 0
        end
        
        for i = 1, 6 do
            if not bounds1[i] or type(bounds1[i]) ~= "number" or
               not bounds2[i] or type(bounds2[i]) ~= "number" then
                return 0
            end
        end
        
        -- Calculate minimum horizontal distance between two AABBs
        local dx = math.max(0, math.max(bounds1[1], bounds2[1]) - math.min(bounds1[4], bounds2[4]))
        local dz = math.max(0, math.max(bounds1[3], bounds2[3]) - math.min(bounds1[6], bounds2[6]))
        
        return math.sqrt(dx*dx + dz*dz)
    end,
    
    -- NEW: Spatial partitioning system for performance optimization
    spatialPartition = {
        octree = nil,
        maxBodiesPerNode = 8,
        maxDepth = 5
    },
    
    -- Initialize spatial partitioning
    initSpatialPartition = function()
        PcombDetection.spatialPartition.octree = PcombDetection.createOctreeNode(
            {-1000, -1000, -1000}, {1000, 1000, 1000}, 0
        )
    end,
    
    -- Create octree node
    createOctreeNode = function(minBounds, maxBounds, depth)
        return {
            minBounds = minBounds,
            maxBounds = maxBounds,
            depth = depth,
            bodies = {},
            children = nil,
            isLeaf = true
        }
    end,
    
    -- Insert body into octree
    insertBodyIntoOctree = function(body, node)
        if not node then return end
        
        local bodyPos = GetBodyTransform(body).pos
        if not bodyPos then return end
        
        -- Check if body is within this node's bounds
        if not PcombDetection.isPointInBounds(bodyPos, node.minBounds, node.maxBounds) then
            return
        end
        
        -- If node is leaf and not full, add body
        if node.isLeaf and #node.bodies < PcombDetection.spatialPartition.maxBodiesPerNode then
            table.insert(node.bodies, body)
            return
        end
        
        -- If node is leaf but full, subdivide
        if node.isLeaf then
            PcombDetection.subdivideOctreeNode(node)
        end
        
        -- Insert into appropriate child
        for i = 1, 8 do
            if node.children[i] then
                PcombDetection.insertBodyIntoOctree(body, node.children[i])
            end
        end
    end,
    
    -- Subdivide octree node into 8 children
    subdivideOctreeNode = function(node)
        if not node.isLeaf then return end
        
        local midX = (node.minBounds[1] + node.maxBounds[1]) / 2
        local midY = (node.minBounds[2] + node.maxBounds[2]) / 2
        local midZ = (node.minBounds[3] + node.maxBounds[3]) / 2
        
        node.children = {
            -- Bottom-front-left
            PcombDetection.createOctreeNode(
                {node.minBounds[1], node.minBounds[2], node.minBounds[3]},
                {midX, midY, midZ},
                node.depth + 1
            ),
            -- Bottom-front-right
            PcombDetection.createOctreeNode(
                {midX, node.minBounds[2], node.minBounds[3]},
                {node.maxBounds[1], midY, midZ},
                node.depth + 1
            ),
            -- Bottom-back-left
            PcombDetection.createOctreeNode(
                {node.minBounds[1], node.minBounds[2], midZ},
                {midX, midY, node.maxBounds[3]},
                node.depth + 1
            ),
            -- Bottom-back-right
            PcombDetection.createOctreeNode(
                {midX, node.minBounds[2], midZ},
                {node.maxBounds[1], midY, node.maxBounds[3]},
                node.depth + 1
            ),
            -- Top-front-left
            PcombDetection.createOctreeNode(
                {node.minBounds[1], midY, node.minBounds[3]},
                {midX, node.maxBounds[2], midZ},
                node.depth + 1
            ),
            -- Top-front-right
            PcombDetection.createOctreeNode(
                {midX, midY, node.minBounds[3]},
                {node.maxBounds[1], node.maxBounds[2], midZ},
                node.depth + 1
            ),
            -- Top-back-left
            PcombDetection.createOctreeNode(
                {node.minBounds[1], midY, midZ},
                {midX, node.maxBounds[2], node.maxBounds[3]},
                node.depth + 1
            ),
            -- Top-back-right
            PcombDetection.createOctreeNode(
                {midX, midY, midZ},
                {node.maxBounds[1], node.maxBounds[2], node.maxBounds[3]},
                node.depth + 1
            )
        }
        
        node.isLeaf = false
        
        -- Redistribute existing bodies to children
        local existingBodies = node.bodies
        node.bodies = {}
        
        for _, body in ipairs(existingBodies) do
            PcombDetection.insertBodyIntoOctree(body, node)
        end
    end,
    
    -- Check if point is within bounds
    isPointInBounds = function(point, minBounds, maxBounds)
        return point[1] >= minBounds[1] and point[1] <= maxBounds[1] and
               point[2] >= minBounds[2] and point[2] <= maxBounds[2] and
               point[3] >= minBounds[3] and point[3] <= maxBounds[3]
    end,
    
    -- Query bodies within radius using octree
    queryBodiesInRadius = function(center, radius, node)
        if not node then return {} end
        
        local result = {}
        
        -- Check if node's bounds intersect with query sphere
        if not PcombDetection.boundsIntersectSphere(node.minBounds, node.maxBounds, center, radius) then
            return result
        end
        
        -- If leaf node, check all bodies
        if node.isLeaf then
            for _, body in ipairs(node.bodies) do
                local bodyPos = GetBodyTransform(body).pos
                if bodyPos and VecLength(VecSub(bodyPos, center)) <= radius then
                    table.insert(result, body)
                end
            end
        else
            -- Recursively query children
            for i = 1, 8 do
                if node.children[i] then
                    local childResults = PcombDetection.queryBodiesInRadius(center, radius, node.children[i])
                    for _, body in ipairs(childResults) do
                        table.insert(result, body)
                    end
                end
            end
        end
        
        return result
    end,
    
    -- Check if AABB intersects with sphere
    boundsIntersectSphere = function(minBounds, maxBounds, center, radius)
        -- Validate bounds before arithmetic operations
        if not minBounds or type(minBounds) ~= "table" or #minBounds < 3 or
           not maxBounds or type(maxBounds) ~= "table" or #maxBounds < 3 or
           not center or type(center) ~= "table" or #center < 3 or
           not radius or type(radius) ~= "number" then
            return false
        end
        
        for i = 1, 3 do
            if not minBounds[i] or type(minBounds[i]) ~= "number" or
               not maxBounds[i] or type(maxBounds[i]) ~= "number" or
               not center[i] or type(center[i]) ~= "number" then
                return false
            end
        end
        
        local closest = {
            math.max(minBounds[1], math.min(center[1], maxBounds[1])),
            math.max(minBounds[2], math.min(center[2], maxBounds[2])),
            math.max(minBounds[3], math.min(center[3], maxBounds[3]))
        }
        
        local distance = VecLength(VecSub(closest, center))
        return distance <= radius
    end,
    
    -- NEW: Batch analyze structure for performance optimization
    batchAnalyzeStructure = function(structureBodies, impactPoint)
        local structureAnalysis = {
            bodies = structureBodies,
            totalMass = 0,
            centerOfMass = {0, 0, 0},
            supportAnalysis = {},
            structuralIntegrity = 1.0,
            collapseThreshold = 0.25, -- 25% base support threshold
            chainReactionBodies = {},
            forceDistribution = {}
        }

        -- Batch process bodies in chunks for performance
        local batchSize = 10
        local totalMass = 0
        local weightedCOM = {0, 0, 0}

        -- First pass: calculate total mass and center of mass
        for i = 1, #structureBodies, batchSize do
            local batchEnd = math.min(i + batchSize - 1, #structureBodies)

            for j = i, batchEnd do
                local body = structureBodies[j]
                local bodyMass = GetBodyMass(body) or 0
                local bodyCOM = GetBodyCenterOfMass(body)
                local bodyTransform = GetBodyTransform(body)
                local worldCOM = TransformToParentPoint(bodyTransform, bodyCOM)

                totalMass = totalMass + bodyMass
                weightedCOM[1] = weightedCOM[1] + (worldCOM[1] * bodyMass)
                weightedCOM[2] = weightedCOM[2] + (worldCOM[2] * bodyMass)
                weightedCOM[3] = weightedCOM[3] + (worldCOM[3] * bodyMass)
            end
        end

        if totalMass > 0 then
            structureAnalysis.centerOfMass = {
                weightedCOM[1] / totalMass,
                weightedCOM[2] / totalMass,
                weightedCOM[3] / totalMass
            }
        end
        structureAnalysis.totalMass = totalMass

        -- Second pass: analyze support for each body in batches
        for i = 1, #structureBodies, batchSize do
            local batchEnd = math.min(i + batchSize - 1, #structureBodies)

            for j = i, batchEnd do
                local body = structureBodies[j]
                -- NEW: Proactively convert static bodies to dynamic before analysis
                -- This ensures all bodies in the structure can participate in physics simulation
                if PcombDetection.isBodyStatic(body) then
                    local converted = PcombDetection.convertStaticToDynamic(body)
                    if not converted and GetBool("savegame.mod.pcomb.global.debug") then
                        DebugPrint("Failed to convert static body in structure to dynamic: " .. tostring(body))
                    end
                end
                
                local bodyAnalysis = PcombDetection.analyzeBodySupport(body, impactPoint)
                structureAnalysis.supportAnalysis[body] = bodyAnalysis

                -- Track bodies that need collapse
                if bodyAnalysis.needsCollapse then
                    table.insert(structureAnalysis.chainReactionBodies, body)
                end
            end
        end

        -- Calculate structural integrity based on base support
        structureAnalysis.structuralIntegrity = PcombDetection.calculateStructuralIntegrity(structureAnalysis)

        -- Analyze force distribution across the structure
        structureAnalysis.forceDistribution = PcombDetection.analyzeForceDistribution(structureAnalysis, impactPoint)

        -- Determine if the entire structure needs to collapse
        structureAnalysis.needsCollapse = structureAnalysis.structuralIntegrity < structureAnalysis.collapseThreshold

        if GetBool("savegame.mod.pcomb.global.debug") then
            DebugPrint("Batch multi-body analysis: " .. #structureBodies .. " bodies, integrity: " ..
                      string.format("%.2f", structureAnalysis.structuralIntegrity) ..
                      ", needs collapse: " .. tostring(structureAnalysis.needsCollapse))
        end

        return structureAnalysis
    end,
    
    -- NEW: Analyze weight distribution and calculate stability
    analyzeWeightDistribution = function(body, supportPoints)
        local bodyMass = GetBodyMass(body)
        local centerOfMass = GetBodyCenterOfMass(body)
        local gravityForce = {0, -bodyMass * 9.81, 0}  -- Gravity force vector
        
        -- Calculate torque from gravity around each potential pivot point
        local stabilityAnalysis = {
            pivotTorques = {},
            minStabilityTorque = math.huge,
            maxStabilityTorque = 0,
            centerOfMass = centerOfMass,
            totalWeightTorque = 0
        }
        
        for i, supportPoint in ipairs(supportPoints) do
            local torque = PcombDetection.calculateTorque(gravityForce, centerOfMass, supportPoint)
            stabilityAnalysis.pivotTorques[i] = {
                point = supportPoint,
                torque = torque
            }
            
            stabilityAnalysis.minStabilityTorque = math.min(stabilityAnalysis.minStabilityTorque, torque)
            stabilityAnalysis.maxStabilityTorque = math.max(stabilityAnalysis.maxStabilityTorque, torque)
        end
        
        -- Calculate total weight distribution torque (sum of all support torques)
        for _, pivotData in ipairs(stabilityAnalysis.pivotTorques) do
            stabilityAnalysis.totalWeightTorque = stabilityAnalysis.totalWeightTorque + pivotData.torque
        end
        
        return stabilityAnalysis
    end,
    
    -- NEW: Check rotational stability based on torque analysis
    checkRotationalStability = function(body, supportAnalysis, materialProps)
        if #supportAnalysis.supportingBodies == 0 then
            return {isStable = false, collapseDirection = "freefall", torqueRatio = 0}
        end
        
        -- Get support points from supporting bodies
        local supportPoints = {}
        for _, supportBody in ipairs(supportAnalysis.supportingBodies) do
            local supportBounds = GetBodyBounds(supportBody)
            if supportBounds and type(supportBounds) == "table" and #supportBounds >= 6 then
                -- Validate bounds array before arithmetic operations
                local boundsValid = true
                for i = 1, 6 do
                    if not supportBounds[i] or type(supportBounds[i]) ~= "number" then
                        boundsValid = false
                        break
                    end
                end
                
                if boundsValid then
                    -- Use the top surface of the supporting body as contact point
                    local contactPoint = {
                        (supportBounds[1] + supportBounds[4]) / 2,  -- Center X
                        supportBounds[5],  -- Top Y
                        (supportBounds[3] + supportBounds[6]) / 2   -- Center Z
                    }
                    table.insert(supportPoints, contactPoint)
                end
            end
        end
        
        if #supportPoints == 0 then
            return {isStable = false, collapseDirection = "freefall", torqueRatio = 0}
        end
        
        -- Analyze weight distribution
        local weightAnalysis = PcombDetection.analyzeWeightDistribution(body, supportPoints)
        
        -- Calculate stability metrics
        local bodyBounds = GetBodyBounds(body)
        if not bodyBounds or type(bodyBounds) ~= "table" or #bodyBounds < 6 then
            return {isStable = false, collapseDirection = "freefall", torqueRatio = 0}
        end
        
        -- Validate bounds array before arithmetic operations
        for i = 1, 6 do
            if not bodyBounds[i] or type(bodyBounds[i]) ~= "number" then
                return {isStable = false, collapseDirection = "freefall", torqueRatio = 0}
            end
        end
        
        local bodyHeight = bodyBounds[5] - bodyBounds[2]
        local bodyMass = GetBodyMass(body)
        
        -- Material-specific stability factors
        local materialStabilityFactor = materialProps.collapseResistance
        local brittlenessFactor = 1 - materialStabilityFactor  -- Brittle materials are less stable
        
        -- Calculate stability ratio: support torque vs weight torque
        local stabilityRatio = weightAnalysis.minStabilityTorque / (bodyMass * bodyHeight * brittlenessFactor)
        
        -- Determine if body is stable
        local stabilityThreshold = 0.3 * materialStabilityFactor  -- Lower threshold for brittle materials
        local isStable = stabilityRatio > stabilityThreshold
        
        -- Determine collapse direction based on weakest support
        local collapseDirection = "balanced"
        if not isStable then
            -- Find the direction with minimum support
            local minTorqueIndex = 1
            for i, pivotData in ipairs(weightAnalysis.pivotTorques) do
                if pivotData.torque < weightAnalysis.pivotTorques[minTorqueIndex].torque then
                    minTorqueIndex = i
                end
            end
            
            -- Determine collapse direction based on center of mass relative to support
            local weakestPoint = weightAnalysis.pivotTorques[minTorqueIndex].point
            local comToSupport = {
                weightAnalysis.centerOfMass[1] - weakestPoint[1],
                weightAnalysis.centerOfMass[3] - weakestPoint[3]
            }
            
            if math.abs(comToSupport[1]) > math.abs(comToSupport[2]) then
                collapseDirection = comToSupport[1] > 0 and "east" or "west"
            else
                collapseDirection = comToSupport[2] > 0 and "north" or "south"
            end
        end
        
        return {
            isStable = isStable,
            collapseDirection = collapseDirection,
            torqueRatio = stabilityRatio,
            weightAnalysis = weightAnalysis,
            materialFactor = brittlenessFactor
        }
    end,
    
    -- NEW: Implement progressive failure mechanics
    applyProgressiveFailure = function(body, stabilityAnalysis, materialProps)
        if stabilityAnalysis.isStable then return false end
        
        -- NEW: Check if weightAnalysis exists to prevent nil access errors
        if not stabilityAnalysis.weightAnalysis or not stabilityAnalysis.weightAnalysis.pivotTorques then
            return false
        end
        
        local bodyMass = GetBodyMass(body)
        local bodyBounds = GetBodyBounds(body)
        
        -- Validate bodyBounds to prevent nil arithmetic errors
        if not bodyBounds or type(bodyBounds) ~= "table" or #bodyBounds < 6 then
            return false
        end
        for i = 1, 6 do
            if not bodyBounds[i] or type(bodyBounds[i]) ~= "number" then
                return false
            end
        end
        
        local failureApplied = false
        
        -- Calculate failure strength based on material properties
        local baseFailureStrength = materialProps.strength * 1000  -- Convert MPa to appropriate units
        local materialFailureMultiplier = 1 - materialProps.collapseResistance
        
        -- Apply progressive damage to weakest connections
        for _, pivotData in ipairs(stabilityAnalysis.weightAnalysis.pivotTorques) do
            local connectionStrength = baseFailureStrength * materialFailureMultiplier
            local appliedTorque = pivotData.torque
            
            -- If torque exceeds connection strength, apply damage
            if appliedTorque > connectionStrength then
                -- Calculate damage amount based on torque excess
                local damageRatio = (appliedTorque - connectionStrength) / connectionStrength
                local damageAmount = math.min(damageRatio * 2.0, 5.0)  -- Cap damage
                
                -- Get bounds for damage position calculation
                local supportBounds = GetBodyBounds(supportBody)
                if supportBounds and type(supportBounds) == "table" and #supportBounds >= 6 then
                    -- Validate bounds array before arithmetic operations
                    local boundsValid = true
                    for i = 1, 6 do
                        if not supportBounds[i] or type(supportBounds[i]) ~= "number" then
                            boundsValid = false
                            break
                        end
                    end
                    
                    if boundsValid then
                        -- Apply damage at connection point
                        local woodDamage = damageAmount * GetInt("savegame.mod.pcomb.ibsit.wood_damage") / 100
                        local stoneDamage = damageAmount * GetInt("savegame.mod.pcomb.ibsit.stone_damage") / 100
                        local metalDamage = damageAmount * GetInt("savegame.mod.pcomb.ibsit.metal_damage") / 100
                        
                        MakeHole(pivotData.point, woodDamage, stoneDamage, metalDamage)
                        failureApplied = true
                        
                        if GetBool("savegame.mod.pcomb.global.debug") then
                            DebugPrint("Applied progressive failure damage: " .. damageAmount .. " at connection point")
                        end
                    end
                end
            end
        end
        
        return failureApplied
    end
}

-- Effects and Visual Systems Module
PcombEffects = {
    -- Track falling bodies for impact damage
    fallingBodies = {},
    
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
        
        -- Process impact damage for falling bodies
        PcombEffects.processImpactDamage()
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
        
        -- Process gravity collapse if enabled
        if GetBool("savegame.mod.pcomb.ibsit.gravity_collapse") then
            local collapseCandidates = PcombDetection.analyzeGravityCollapse(analysisData.position, analysisData.size)
            PcombEffects.processGravityCollapse(collapseCandidates)
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
            
            -- Validate bounds to prevent nil arithmetic errors
            if bounds and type(bounds) == "table" and #bounds >= 6 then
                local allValid = true
                for j = 1, 6 do
                    if not bounds[j] or type(bounds[j]) ~= "number" then
                        allValid = false
                        break
                    end
                end
                
                if allValid then
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
            end
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
            
            -- Validate shapeBounds to prevent nil arithmetic errors
            if shapeBounds and type(shapeBounds) == "table" and #shapeBounds >= 6 then
                local allValid = true
                for j = 1, 6 do
                    if not shapeBounds[j] or type(shapeBounds[j]) ~= "number" then
                        allValid = false
                        break
                    end
                end
                
                if allValid then
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
            end
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
    end,
    
    processGravityCollapse = function(collapseCandidates)
        -- NEW: Process multi-body structures first
        local processedStructures = {}
        
        for body, collapseData in pairs(collapseCandidates) do
            if collapseData.needsCollapse and IsBodyActive(body) then
                -- Check if this body is part of a larger structure
                local jointedBodies = GetJointedBodies(body)
                if jointedBodies and #jointedBodies > 0 then
                    -- This is part of a multi-body structure, analyze the whole thing
                    local structureKey = tostring(body) -- Use body pointer as key
                    
                    if not processedStructures[structureKey] then
                        local impactPoint = collapseData.centerOfMass or {0, 0, 0}
                        local structureAnalysis = PcombDetection.analyzeMultiBodyStructure(body, impactPoint)
                        
                        if structureAnalysis.needsCollapse then
                            -- Process the entire structure with chain reactions
                            PcombDetection.processChainReaction(structureAnalysis, impactPoint)
                            
                            -- Mark all bodies in this structure as processed
                            for _, structBody in ipairs(structureAnalysis.bodies) do
                                processedStructures[tostring(structBody)] = true
                            end
                        end
                    end
                else
                    -- Single body collapse (fallback)
                    PcombEffects.applyGravityCollapse(body, collapseData)
                end
            end
        end
    end,
    
    applyGravityCollapse = function(body, collapseData)
        -- NEW: Ensure body is dynamic before applying gravity forces
        -- This is a final safety check in case static conversion was missed earlier
        if PcombDetection.isBodyStatic(body) then
            local converted = PcombDetection.convertStaticToDynamic(body)
            if not converted then
                -- If conversion failed, skip gravity application
                if GetBool("savegame.mod.pcomb.global.debug") then
                    DebugPrint("Failed to convert static body for gravity collapse: " .. tostring(body))
                end
                return
            end
        end
        
        local collapseStrength = collapseData.collapseStrength
        local centerOfMass = collapseData.centerOfMass
        local bodyMass = collapseData.effectiveMass or collapseData.bodyMass
        if not bodyMass then
            return
        end
        local materialProps = collapseData.materialProps
        
        -- Material-specific gravity force calculation
        local baseGravity = 9.81
        local materialMultiplier = GetFloat("savegame.mod.pcomb.ibsit.gravity_force")
        
        -- Adjust gravity based on material properties
        -- Brittle materials (low collapse resistance) collapse more dramatically
        local materialFactor = 1 + (1 - materialProps.collapseResistance) * 2.0
        local gravityForce = bodyMass * baseGravity * collapseStrength * materialMultiplier * materialFactor
        
        -- NEW: Enhanced directional collapse based on torque analysis
        local directionalForces = {0, -gravityForce, 0}  -- Default downward force
        
        if collapseData.stabilityAnalysis and not collapseData.stabilityAnalysis.isStable then
            -- Apply directional forces based on collapse direction
            local collapseDirection = collapseData.stabilityAnalysis.collapseDirection
            local torqueStrength = collapseData.torqueCollapseStrength or 0.5
            
            -- Calculate directional force magnitude based on torque
            local directionalMagnitude = gravityForce * torqueStrength * 0.3
            
            if collapseDirection == "east" then
                directionalForces = {directionalMagnitude, -gravityForce, 0}
            elseif collapseDirection == "west" then
                directionalForces = {-directionalMagnitude, -gravityForce, 0}
            elseif collapseDirection == "north" then
                directionalForces = {0, -gravityForce, directionalMagnitude}
            elseif collapseDirection == "south" then
                directionalForces = {0, -gravityForce, -directionalMagnitude}
            end
            
            if GetBool("savegame.mod.pcomb.global.debug") then
                DebugPrint("Directional collapse: " .. collapseDirection .. 
                          " (torque strength: " .. string.format("%.2f", torqueStrength) .. ")")
            end
        end
        
        -- Apply the calculated forces
        ApplyBodyImpulse(body, centerOfMass, directionalForces)
        
        -- Material-specific instability (brittle materials are more unstable)
        local instability = collapseStrength * (1 - materialProps.collapseResistance) * 0.5
        local randomX = (math.random() - 0.5) * instability * bodyMass
        local randomZ = (math.random() - 0.5) * instability * bodyMass
        
        if instability > 0.1 then
            ApplyBodyImpulse(body, centerOfMass, {randomX, 0, randomZ})
        end
        
        -- NEW: Track this body as falling for impact damage
        PcombEffects.trackFallingBody(body, collapseData)
        
        -- Material-specific effects
        if materialProps.name == "Glass" or materialProps.name == "Window Glass" then
            -- Glass shatters more dramatically
            PcombEffects.createGlassShatterEffect(centerOfMass, collapseStrength)
        elseif materialProps.name == "Wood" or materialProps.name == "Plank" or materialProps.name == "Log" then
            -- Wood creaks and splinters
            PcombEffects.createWoodCollapseEffect(centerOfMass, collapseStrength)
        elseif materialProps.name == "Stone" or materialProps.name == "Concrete" or materialProps.name == "Brick" then
            -- Stone/concrete crumbles heavily
            PcombEffects.createStoneCollapseEffect(centerOfMass, collapseStrength)
        elseif materialProps.name == "Metal" or materialProps.name == "Steel" or materialProps.name == "Iron" then
            -- Metal groans and deforms
            PcombEffects.createMetalCollapseEffect(centerOfMass, collapseStrength)
        else
            -- Default dust effect
            PcombEffects.createCollapseDust(centerOfMass, collapseStrength)
        end
        
        -- Play material-specific collapse sound
        PcombEffects.playMaterialCollapseSound(centerOfMass, collapseStrength, materialProps.name)
    end,
    
    createCollapseDust = function(position, intensity)
        local dustCount = math.floor(intensity * 20) + 5
        
        for i = 1, dustCount do
            local offset = {
                (math.random() - 0.5) * 2,
                math.random() * 0.5,
                (math.random() - 0.5) * 2
            }
            local dustPos = VecAdd(position, offset)
            
            SpawnParticle(dustPos, {0, 0, 0}, 2.0)
        end
    end,
    
    playCollapseSound = function(position, intensity)
        -- Play appropriate collapse sound based on intensity
        if intensity > 0.7 then
            PlaySound(LoadSound("sound/structure_collapse_heavy.ogg"), position, 1.0)
        elseif intensity > 0.4 then
            PlaySound(LoadSound("sound/structure_collapse_medium.ogg"), position, 0.8)
        else
            PlaySound(LoadSound("sound/structure_collapse_light.ogg"), position, 0.6)
        end
    end,
    
    createGlassShatterEffect = function(position, intensity)
        local shardCount = math.floor(intensity * 30) + 10
        
        for i = 1, shardCount do
            local offset = {
                (math.random() - 0.5) * 3,
                math.random() * 1,
                (math.random() - 0.5) * 3
            }
            local shardPos = VecAdd(position, offset)
            
            -- Create glass shard particles
            SpawnParticle(shardPos, {
                (math.random() - 0.5) * 4,
                math.random() * 2,
                (math.random() - 0.5) * 4
            }, math.random() * 3)
        end
    end,
    
    createWoodCollapseEffect = function(position, intensity)
        local splinterCount = math.floor(intensity * 25) + 8
        
        for i = 1, splinterCount do
            local offset = {
                (math.random() - 0.5) * 2.5,
                math.random() * 0.8,
                (math.random() - 0.5) * 2.5
            }
            local splinterPos = VecAdd(position, offset)
            
            -- Create wood splinter particles
            SpawnParticle(splinterPos, {
                (math.random() - 0.5) * 3,
                math.random() * 1.5,
                (math.random() - 0.5) * 3
            }, math.random() * 2.5)
        end
    end,
    
    createStoneCollapseEffect = function(position, intensity)
        local debrisCount = math.floor(intensity * 20) + 5
        
        for i = 1, debrisCount do
            local offset = {
                (math.random() - 0.5) * 2,
                math.random() * 0.5,
                (math.random() - 0.5) * 2
            }
            local debrisPos = VecAdd(position, offset)
            
            -- Create stone debris particles (heavier, slower)
            SpawnParticle(debrisPos, {
                (math.random() - 0.5) * 2,
                math.random() * 1,
                (math.random() - 0.5) * 2
            }, math.random() * 4)
        end
    end,
    
    createMetalCollapseEffect = function(position, intensity)
        local sparkCount = math.floor(intensity * 15) + 5
        
        for i = 1, sparkCount do
            local offset = {
                (math.random() - 0.5) * 1.5,
                math.random() * 0.3,
                (math.random() - 0.5) * 1.5
            }
            local sparkPos = VecAdd(position, offset)
            
            -- Create metal spark/debris particles
            SpawnParticle(sparkPos, {
                (math.random() - 0.5) * 2.5,
                math.random() * 1.2,
                (math.random() - 0.5) * 2.5
            }, math.random() * 2)
        end
    end,
    
    playMaterialCollapseSound = function(position, intensity, materialName)
        local volume = GetFloat("savegame.mod.pcomb.ibsit.volume")
        
        if materialName == "Glass" or materialName == "Window Glass" then
            if intensity > 0.6 then
                PlaySound(LoadSound("sound/glass_shatter_heavy.ogg"), position, volume * 1.2)
            else
                PlaySound(LoadSound("sound/glass_shatter_light.ogg"), position, volume)
            end
        elseif materialName == "Wood" or materialName == "Plank" or materialName == "Log" then
            if intensity > 0.6 then
                PlaySound(LoadSound("sound/wood_break_heavy.ogg"), position, volume * 1.1)
            else
                PlaySound(LoadSound("sound/wood_break_light.ogg"), position, volume)
            end
        elseif materialName == "Stone" or materialName == "Concrete" or materialName == "Brick" then
            if intensity > 0.6 then
                PlaySound(LoadSound("sound/stone_crumble_heavy.ogg"), position, volume * 1.3)
            else
                PlaySound(LoadSound("sound/stone_crumble_light.ogg"), position, volume * 1.1)
            end
        elseif materialName == "Metal" or materialName == "Steel" or materialName == "Iron" then
            if intensity > 0.6 then
                PlaySound(LoadSound("sound/metal_groan_heavy.ogg"), position, volume * 1.4)
            else
                PlaySound(LoadSound("sound/metal_groan_light.ogg"), position, volume * 1.2)
            end
        else
            -- Default collapse sound
            PcombEffects.playCollapseSound(position, intensity)
        end
    end,
    
    -- NEW: Track falling body for impact damage calculation
    trackFallingBody = function(body, collapseData)
        -- NEW: Ensure body is dynamic before tracking for impact damage
        if PcombDetection.isBodyStatic(body) then
            local converted = PcombDetection.convertStaticToDynamic(body)
            if not converted then
                -- If conversion failed, don't track this body
                return
            end
        end
        
        if not IsBodyActive(body) then return end
        
        local bodyVelocity = GetBodyVelocity(body)
        local verticalVelocity = math.abs(bodyVelocity[2])
        if not verticalVelocity then
            return
        end

        -- Only track bodies with significant downward velocity
        if verticalVelocity > 2.0 then
            PcombEffects.fallingBodies[body] = {
                startTime = GetTime(),
                initialVelocity = bodyVelocity,
                initialPosition = GetBodyTransform(body).pos,
                materialProps = collapseData.materialProps,
                effectiveMass = collapseData.effectiveMass or collapseData.bodyMass,
                lastVelocity = bodyVelocity,
                maxVelocity = verticalVelocity,
                hasImpacted = false
            }
        end
    end,
    
    -- NEW: Process impact damage for tracked falling bodies
    processImpactDamage = function()
        local currentTime = GetTime()
        
        for body, fallData in pairs(PcombEffects.fallingBodies) do
            if not IsBodyActive(body) then
                -- Body was destroyed, remove from tracking
                PcombEffects.fallingBodies[body] = nil
            elseif not fallData.hasImpacted then
                local currentVelocity = GetBodyVelocity(body)
                local verticalVelocity = math.abs(currentVelocity[2])
                
                -- Update max velocity
                if verticalVelocity > fallData.maxVelocity then
                    fallData.maxVelocity = verticalVelocity
                end
                
                -- Check for impact (significant velocity reduction or direction change)
                local velocityChange = math.abs(verticalVelocity - math.abs(fallData.lastVelocity[2]))
                
                -- Detect impact: either velocity suddenly drops or body stops moving downward
                if velocityChange > 3.0 or (verticalVelocity < 1.0 and currentVelocity[2] > -0.5) then
                    -- Calculate impact force and apply damage
                    PcombEffects.applyImpactDamage(body, fallData, currentVelocity)
                    fallData.hasImpacted = true
                    
                    -- Remove from tracking after a short delay
                    fallData.removeTime = currentTime + 2.0
                else
                    fallData.lastVelocity = currentVelocity
                end
            elseif fallData.removeTime and currentTime > fallData.removeTime then
                -- Remove old impacted bodies
                PcombEffects.fallingBodies[body] = nil
            end
        end
    end,
    
    -- NEW: Apply damage based on impact force
    applyImpactDamage = function(body, fallData, impactVelocity)
        -- Check if impact damage is enabled
        if not GetBool("savegame.mod.pcomb.impact.enabled") then return end
        
        local impactPosition = GetBodyTransform(body).pos
        local impactForce = fallData.effectiveMass * fallData.maxVelocity
        if not fallData.effectiveMass then
            return
        end

        -- Apply configuration multiplier
        local configMultiplier = GetFloat("savegame.mod.pcomb.impact.multiplier") or 1.0
        impactForce = impactForce * configMultiplier
        
        -- Calculate damage based on impact force and material properties
        local baseDamage = math.min(impactForce / 1000, 10) -- Cap at 10 for balance
        
        -- Material-specific damage multipliers
        local materialMultiplier = 1.0
        if fallData.materialProps.name == "Stone" or fallData.materialProps.name == "Concrete" then
            materialMultiplier = 1.5 -- Stone hits harder
        elseif fallData.materialProps.name == "Metal" or fallData.materialProps.name == "Steel" then
            materialMultiplier = 1.3 -- Metal hits hard
        elseif fallData.materialProps.name == "Glass" then
            materialMultiplier = 0.7 -- Glass breaks on impact, less damage to others
        elseif fallData.materialProps.name == "Wood" then
            materialMultiplier = 1.0 -- Wood is moderate
        end
        
        local finalDamage = baseDamage * materialMultiplier
        
        -- Use configurable impact radius
        local configRadius = GetFloat("savegame.mod.pcomb.impact.radius") or 2.0
        local impactRadius = math.max(finalDamage * 0.5, configRadius) -- Damage radius based on impact force
        
        QueryRequire("physical")
        local nearbyBodies = QueryAabbBodies(
            impactPosition[1] - impactRadius, impactPosition[2] - impactRadius, impactPosition[3] - impactRadius,
            impactPosition[1] + impactRadius, impactPosition[2] + impactRadius, impactPosition[3] + impactRadius
        )
        
        for _, nearbyBody in ipairs(nearbyBodies) do
            if nearbyBody ~= body and IsBodyActive(nearbyBody) then
                -- Calculate damage based on distance from impact
                local bodyPos = GetBodyTransform(nearbyBody).pos
                local distance = VecLength(VecSub(bodyPos, impactPosition))
                local distanceFactor = math.max(0, 1 - (distance / impactRadius))
                
                if distanceFactor > 0.1 then
                    local damageToApply = finalDamage * distanceFactor
                    
                    -- Apply damage to shapes in the body
                    local shapes = GetBodyShapes(nearbyBody)
                    for _, shape in ipairs(shapes) do
                        local shapeBounds = GetShapeBounds(shape)
                        if shapeBounds then
                            -- Calculate damage position within shape bounds
                            local damagePos = {
                                shapeBounds[1] + (shapeBounds[4] - shapeBounds[1]) * math.random(),
                                shapeBounds[2] + (shapeBounds[5] - shapeBounds[2]) * math.random(),
                                shapeBounds[3] + (shapeBounds[6] - shapeBounds[3]) * math.random()
                            }
                            
                            -- Apply damage based on material
                            local woodDamage = damageToApply * GetInt("savegame.mod.pcomb.ibsit.wood_damage") / 100
                            local stoneDamage = damageToApply * GetInt("savegame.mod.pcomb.ibsit.stone_damage") / 100
                            local metalDamage = damageToApply * GetInt("savegame.mod.pcomb.ibsit.metal_damage") / 100
                            
                            MakeHole(damagePos, woodDamage, stoneDamage, metalDamage)
                        end
                    end
                    
                    -- Create impact effects
                    PcombEffects.createImpactEffects(impactPosition, finalDamage, fallData.materialProps.name)
                    
                    -- Play impact sound
                    PcombEffects.playImpactSound(impactPosition, finalDamage, fallData.materialProps.name)
                end
            end
        end
    end,
    
    -- NEW: Create visual effects for impacts
    createImpactEffects = function(position, intensity, materialName)
        local effectCount = math.floor(intensity * 5) + 3
        
        for i = 1, effectCount do
            local offset = {
                (math.random() - 0.5) * 2,
                math.random() * 0.5,
                (math.random() - 0.5) * 2
            }
            local effectPos = VecAdd(position, offset)
            
            -- Material-specific impact particles
            if materialName == "Stone" or materialName == "Concrete" then
                -- Stone/concrete creates dust and debris
                SpawnParticle(effectPos, {
                    (math.random() - 0.5) * 3,
                    math.random() * 2,
                    (math.random() - 0.5) * 3
                }, math.random() * 3)
            elseif materialName == "Metal" or materialName == "Steel" then
                -- Metal creates sparks
                SpawnParticle(effectPos, {
                    (math.random() - 0.5) * 2,
                    math.random() * 1.5,
                    (math.random() - 0.5) * 2
                }, math.random() * 2)
            elseif materialName == "Wood" then
                -- Wood creates splinters
                SpawnParticle(effectPos, {
                    (math.random() - 0.5) * 2.5,
                    math.random() * 1.8,
                    (math.random() - 0.5) * 2.5
                }, math.random() * 2.5)
            else
                -- Default impact dust
                SpawnParticle(effectPos, {
                    (math.random() - 0.5) * 2,
                    math.random() * 1.2,
                    (math.random() - 0.5) * 2
                }, math.random() * 2)
            end
        end
    end,
    
    -- NEW: Play impact sound based on material and intensity
    playImpactSound = function(position, intensity, materialName)
        local volume = GetFloat("savegame.mod.pcomb.ibsit.volume")
        
        if materialName == "Stone" or materialName == "Concrete" then
            if intensity > 3 then
                PlaySound(LoadSound("sound/impact_stone_heavy.ogg"), position, volume * 1.2)
            else
                PlaySound(LoadSound("sound/impact_stone_light.ogg"), position, volume)
            end
        elseif materialName == "Metal" or materialName == "Steel" then
            if intensity > 3 then
                PlaySound(LoadSound("sound/impact_metal_heavy.ogg"), position, volume * 1.3)
            else
                PlaySound(LoadSound("sound/impact_metal_light.ogg"), position, volume * 1.1)
            end
        elseif materialName == "Wood" then
            if intensity > 3 then
                PlaySound(LoadSound("sound/impact_wood_heavy.ogg"), position, volume * 1.1)
            else
                PlaySound(LoadSound("sound/impact_wood_light.ogg"), position, volume)
            end
        elseif materialName == "Glass" then
            PlaySound(LoadSound("sound/impact_glass.ogg"), position, volume * 0.9)
        else
            -- Default impact sound
            if intensity > 3 then
                PlaySound(LoadSound("sound/impact_heavy.ogg"), position, volume)
            else
                PlaySound(LoadSound("sound/impact_light.ogg"), position, volume * 0.8)
            end
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

-- Conversion settings for pause menu
local pauseMenuSliders = {
    {
        name = "Size Threshold",
        key = "savegame.mod.pcomb.conversion.size_threshold",
        min = 0.1,
        max = 5.0,
        format = "%.1f",
        multiplier = 10
    }
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
            
            -- Read current state
            local isEnabled = GetBool(button.key)
            local buttonClicked = false
            
            if isEnabled then
                UiColor(0.2, 0.8, 0.2)
            else
                UiColor(0.8, 0.2, 0.2)
            end
            
            if UiTextButton(button.name .. " (" .. (isEnabled and "ON" or "OFF") .. ")", 300, 35) then
                buttonClicked = true
                -- Toggle the value
                local newValue = not isEnabled
                SetBool(button.key, newValue)
                -- Update local state for immediate visual feedback
                isEnabled = newValue
            end
            
            -- Update button appearance immediately if clicked
            if buttonClicked then
                if isEnabled then
                    UiColor(0.2, 0.8, 0.2)
                else
                    UiColor(0.8, 0.2, 0.2)
                end
                -- Redraw button with updated state (this ensures immediate visual feedback)
                UiText(button.name .. " (" .. (isEnabled and "ON" or "OFF") .. ")")
            end
            
            UiPop()
        end
        
        -- Conversion settings sliders
        for i, slider in ipairs(pauseMenuSliders) do
            UiPush()
            UiTranslate(0, -50 + (#pauseMenuButtons - 1) * 40 + i * 60)
            UiAlign("left top")
            UiFont("regular.ttf", 16)
            UiColor(1, 1, 1)
            UiText(slider.name)
            UiTranslate(0, 25)
            
            -- Get current value
            local currentValue = GetFloat(slider.key)
            local displayValue = currentValue * (slider.multiplier or 1)
            local newDisplayValue = UiSlider("ui/common/dot.png", "x", displayValue, slider.min * (slider.multiplier or 1), slider.max * (slider.multiplier or 1))
            local newValue = newDisplayValue / (slider.multiplier or 1)
            
            if newValue ~= currentValue then
                SetFloat(slider.key, newValue)
            end
            
            -- Display current value
            UiTranslate(320, -6)
            UiText(string.format(slider.format, newValue))
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