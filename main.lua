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
    
    analyzeGravityCollapse = function(breakpoint, breaksize)
        local collapseCandidates = {}
        
        -- Query for bodies that might need gravity collapse analysis
        local min = {breakpoint[1] - breaksize * 2, breakpoint[2] - breaksize * 2, breakpoint[3] - breaksize * 2}
        local max = {breakpoint[1] + breaksize * 2, breakpoint[2] + breaksize * 2, breakpoint[3] + breaksize * 2}
        
        QueryRequire("physical dynamic large")
        local bodies = QueryAabbBodies(min, max)
        
        for i = 1, #bodies do
            local body = bodies[i]
            if IsBodyActive(body) and not IsBodyBroken(body) then
                local collapseData = PcombDetection.analyzeBodySupport(body, breakpoint)
                if collapseData.needsCollapse then
                    collapseCandidates[body] = collapseData
                end
            end
        end
        
        return collapseCandidates
    end,
    
    analyzeBodySupport = function(body, impactPoint)
        local bodyTransform = GetBodyTransform(body)
        local bodyPos = bodyTransform.pos
        local bodyMass = GetBodyMass(body)
        
        -- Get body bounds for support analysis
        local bounds = GetBodyBounds(body)
        if not bounds then return {needsCollapse = false} end
        
        -- Calculate center of mass and support points
        local centerOfMass = GetBodyCenterOfMass(body)
        local comWorldPos = TransformToParentPoint(bodyTransform, centerOfMass)
        
        -- Get material properties for this body
        local materialName = PcombDetection.getBodyMaterial(body)
        local effectiveMass, materialProps = PcombMaterials.calculateEffectiveMass(body, materialName)
        
        -- Multi-directional support analysis
        local supportAnalysis = PcombDetection.analyzeMultiDirectionalSupport(body, bounds, materialName)
        
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
        
        -- Determine if collapse is needed
        local needsCollapse = false
        local collapseStrength = 0
        
        -- Multiple collapse criteria
        if stabilityRatio < materialAdjustedThreshold * 0.6 or 
           supportAreaRatio < materialAdjustedThreshold * 0.4 or
           collapseProbability > 0.3 or
           stressFactor > materialProps.strength * 0.8 then
            
            needsCollapse = true
            collapseStrength = math.max(
                (materialAdjustedThreshold - stabilityRatio) / materialAdjustedThreshold,
                (materialAdjustedThreshold - supportAreaRatio) / materialAdjustedThreshold,
                collapseProbability,
                stressFactor / materialProps.strength
            )
            collapseStrength = math.min(collapseStrength, 1.0)
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
            collapseProbability = collapseProbability
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
                local nearbyBounds = GetBodyBounds(nearbyBody)
                if nearbyBounds and nearbyBounds[5] >= bounds[2] - 0.1 then
                    -- Body is at or above our base level
                    table.insert(supportingBodies, nearbyBody)
                end
            end
        end
        
        return supportingBodies
    end,
    
    calculateOverlapArea = function(bounds1, bounds2)
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
        for body, collapseData in pairs(collapseCandidates) do
            if collapseData.needsCollapse and IsBodyActive(body) then
                PcombEffects.applyGravityCollapse(body, collapseData)
            end
        end
    end,
    
    applyGravityCollapse = function(body, collapseData)
        local collapseStrength = collapseData.collapseStrength
        local centerOfMass = collapseData.centerOfMass
        local bodyMass = collapseData.effectiveMass or collapseData.bodyMass
        local materialProps = collapseData.materialProps
        
        -- Material-specific gravity force calculation
        local baseGravity = 9.81
        local materialMultiplier = GetFloat("savegame.mod.pcomb.ibsit.gravity_force")
        
        -- Adjust gravity based on material properties
        -- Brittle materials (low collapse resistance) collapse more dramatically
        local materialFactor = 1 + (1 - materialProps.collapseResistance) * 2.0
        local gravityForce = bodyMass * baseGravity * collapseStrength * materialMultiplier * materialFactor
        
        -- Apply downward force at center of mass
        ApplyBodyImpulse(body, centerOfMass, {0, -gravityForce, 0})
        
        -- Material-specific instability (brittle materials are more unstable)
        local instability = collapseStrength * (1 - materialProps.collapseResistance) * 0.5
        local randomX = (math.random() - 0.5) * instability * bodyMass
        local randomZ = (math.random() - 0.5) * instability * bodyMass
        
        if instability > 0.1 then
            ApplyBodyImpulse(body, centerOfMass, {randomX, 0, randomZ})
        end
        
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