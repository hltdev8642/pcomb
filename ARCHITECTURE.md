-- PHYSICS COMBINATION MOD - UNIFIED ARCHITECTURE DESIGN
-- Combines Progressive Destruction, IBSIT, and MBCS into a cohesive physics system

--[[
ARCHITECTURE OVERVIEW:

1. MODULAR SYSTEM DESIGN:
   - Each subsystem (PRGD, IBSIT, MBCS) operates independently
   - Systems can be enabled/disabled individually
   - Cross-system communication through unified event system
   - Shared configuration management

2. LAYERED PROCESSING:
   Layer 1 (Detection): IBSIT + MBCS collision and integrity detection
   Layer 2 (Processing): Unified damage calculation and physics processing
   Layer 3 (Effects): PRGD particles, sounds, visual effects
   Layer 4 (Cleanup): Performance optimization and debris management

3. DUAL OPTIONS SYSTEM:
   - options.lua: Full featured mod manager interface
   - Pause menu: Simplified in-game toggles and quick settings

4. UNIFIED CONFIGURATION:
   All settings use "savegame.mod.pcomb." prefix with subsystem identifiers:
   - "savegame.mod.pcomb.prgd.*" for Progressive Destruction settings
   - "savegame.mod.pcomb.ibsit.*" for IBSIT settings  
   - "savegame.mod.pcomb.mbcs.*" for MBCS settings
   - "savegame.mod.pcomb.global.*" for unified system settings

5. PERFORMANCE MANAGEMENT:
   - Intelligent priority system
   - FPS-based dynamic adjustment
   - Coroutine-based processing
   - Memory-efficient particle management

6. SYSTEM INTEGRATION POINTS:
   - Shared body tracking and analysis
   - Unified particle system
   - Consolidated debris management
   - Cross-system event broadcasting

IMPLEMENTATION STRATEGY:

1. Core Systems Module (core.lua)
   - System initialization and management
   - Configuration handling
   - Cross-system communication

2. Detection Module (detection.lua)
   - IBSIT structural integrity detection
   - MBCS mass-based proximity detection
   - Unified collision processing

3. Effects Module (effects.lua)
   - PRGD particle and visual effects
   - Sound and haptic feedback
   - Force and wind systems

4. Performance Module (performance.lua)
   - FPS monitoring and optimization
   - Debris cleanup and management
   - Memory optimization

5. Options Module (options.lua)
   - Comprehensive mod manager interface
   - System configuration UI
   - Settings persistence

6. Pause Menu Module (pause.lua)
   - In-game quick settings
   - System toggles
   - Real-time adjustments

API COMPLIANCE:
- Uses only official Teardown API functions
- No global function invention
- Proper use of Teardown's callback system
- Official UI system integration

BACKWARDS COMPATIBILITY:
- Maintains original mod functionality
- Preserves configuration options
- Supports incremental migration
--]]