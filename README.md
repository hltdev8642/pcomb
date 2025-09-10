# Physics Combination Mod (PComb)

**A unified physics enhancement mod for Teardown that combines three powerful destruction systems into one seamless experience.**

## Overview

The Physics Combination Mod merges three acclaimed Teardown physics mods into a single, optimized system:

- **Progressive Destruction (PRGD)** - Advanced crumbling, dust, violence, and environmental effects
- **Impact Based Structural Integrity (IBSIT)** - Realistic material-specific damage and structural analysis  
- **Mass Based Collateral System (MBCS)** - Proximity-based structural collapse triggered by mass

All systems work together intelligently with unified performance management and dual user interfaces.

## Key Features

### 🏗️ **Progressive Destruction System**
- **Realistic Crumbling**: Progressive structural deterioration over time
- **Dynamic Dust Clouds**: Material-specific particle effects with physics simulation
- **Enhanced Explosions**: Improved blast effects with realistic debris patterns
- **Environmental Forces**: Wind, gravity, and directional force systems
- **Physics Violence**: Enhanced object interactions and collision dynamics
- **Fire Systems**: Spreading fire damage with realistic burn patterns
- **Joint Analysis**: Structural joint failure under stress conditions

### 🔧 **Structural Integrity System**  
- **Material-Specific Damage**: Wood, stone, and metal react differently to impacts
- **Momentum Analysis**: Physics-based damage calculation using velocity and mass
- **Gravity Collapse**: Realistic gravitational structural failure
- **Audio Feedback**: Contextual sound effects for different collapse types
- **Haptic Feedback**: Controller vibration for structural impacts
- **Debris Cleanup**: Automatic removal of small debris for performance
- **FPS Optimization**: Dynamic quality adjustment based on performance

### ⚖️ **Mass Collateral System**
- **Proximity Triggers**: Heavy objects trigger collapse in nearby structures
- **Distance Calculation**: Configurable range for mass-based effects
- **Static Interaction**: Integration with world geometry and fixed structures
- **Threshold Management**: Precise control over what mass levels trigger effects

### 🎛️ **Unified Control Systems**
- **Dual Interface**: Configure from both mod manager and pause menu
- **Performance Presets**: One-click optimization for different hardware
- **Real-time Adjustments**: Change settings during gameplay
- **Individual System Control**: Enable/disable each physics system independently
- **Advanced Configuration**: Fine-tune every aspect of the physics simulation

## Installation

1. **Download** the Physics Combination Mod files
2. **Extract** to your Teardown mods directory:
   ```
   Steam/steamapps/common/Teardown/data/mods/pcomb/
   ```
3. **Launch** Teardown and enable "Physics Combination Mod" in the mod manager
4. **Configure** settings through Options → Mods → Physics Combination Mod

## Configuration Guide

### Performance Optimization

The mod includes three performance presets for different hardware:

#### 🚀 **Performance Mode (45+ FPS)**
- Optimized for lower-end hardware
- Reduced particle counts and effect quality
- Aggressive debris filtering
- Recommended for integrated graphics

#### ⚖️ **Quality Mode (30+ FPS)** *(Default)*
- Balanced experience for most systems
- Good visual quality with stable performance
- Moderate particle effects
- Recommended for mid-range hardware

#### 🔥 **Maximum Mode (20+ FPS)**
- Full visual quality and effects
- Maximum particle counts
- No performance limitations
- Recommended for high-end hardware

### Individual System Configuration

#### Progressive Destruction (PRGD)
```
Core Features:
├── Crumbling Effects       (Progressive structure deterioration)
├── Dust Particles         (Material-specific dust clouds)
├── Enhanced Explosions     (Improved blast and debris)
├── Force System           (Wind and environmental forces)
├── Fire Effects           (Spreading fire damage)
├── Physics Violence       (Enhanced collision dynamics)
└── Joint Breaking         (Realistic structural failure)

Performance Controls:
├── FPS Control            (Automatic adjustment)
├── Small Debris Filter    (Remove tiny pieces)
├── Low FPS Filter         (Reduce effects when needed)
└── Distance Based Filter  (Optimize distant effects)
```

#### Structural Integrity (IBSIT)
```
Material Analysis:
├── Wood Damage            (Configurable multiplier)
├── Stone Damage           (Configurable multiplier)
├── Metal Damage           (Configurable multiplier)
└── Momentum Threshold     (Minimum force for analysis)

Advanced Features:
├── Gravity Collapse       (Realistic structural failure)
├── Particle Effects       (Material-specific visuals)
├── Sound Effects          (Audio feedback)
├── Haptic Feedback        (Controller vibration)
├── Debris Cleanup         (Automatic small debris removal)
└── FPS Optimization       (Performance scaling)
```

#### Mass Collateral (MBCS)
```
Proximity System:
├── Mass Threshold         (Minimum triggering mass)
├── Distance Threshold     (Triggering range)
└── Material Damage        (Collapse damage multipliers)

Technical Settings:
├── Static Integration     (World geometry interaction)
└── Trigger Sensitivity    (Fine-tune responsiveness)
```

## Usage Instructions

### Mod Manager Interface
1. **Access**: Options → Mods → Physics Combination Mod
2. **Navigate**: Use tabs for different systems (Global, PRGD, IBSIT, MBCS, Performance)
3. **Configure**: Adjust sliders and toggles for desired effects
4. **Apply**: Settings save automatically

### Pause Menu Interface
1. **Access**: Press Escape during gameplay → Physics Combo button
2. **Quick Toggle**: Enable/disable individual systems instantly
3. **Monitor**: View real-time FPS and performance metrics
4. **Debug**: Toggle debug mode for troubleshooting

### Performance Monitoring
- **FPS Display**: Real-time frame rate in debug mode
- **Body Count**: Number of objects being processed
- **Performance Scale**: Current automatic scaling factor
- **Active Systems**: Which physics systems are running

## Troubleshooting

### Performance Issues

**Low FPS (< 30)**
1. Switch to Performance Mode in settings
2. Disable MBCS system (highest performance impact)
3. Reduce particle amounts in PRGD and IBSIT
4. Enable all filtering options (SDF, LFF, DBF)

**Stuttering/Freezing**
1. Lower dust and particle amounts
2. Increase FPS target settings
3. Enable automatic FPS optimization
4. Disable force and violence systems

**Memory Issues**
1. Enable debris cleanup in IBSIT
2. Reduce debris lifetime settings
3. Lower crumble size in PRGD
4. Disable fire and explosion effects

### Visual Issues

**Missing Particles**
1. Check if particle effects are enabled
2. Verify particle quality isn't set to minimum
3. Increase dust amounts if too low
4. Check performance scaling factor

**No Sound Effects**
1. Verify sound effects enabled in IBSIT
2. Check volume levels aren't muted
3. Ensure audio files loaded correctly
4. Test with different material types

**Inconsistent Effects**
1. Check if systems are properly enabled
2. Verify momentum thresholds aren't too high
3. Test mass thresholds in MBCS
4. Enable debug mode to monitor processing

### Compatibility Issues

**Mod Conflicts**
- Disable other physics/destruction mods
- Check for conflicting particle systems
- Verify no API function overlaps
- Test with minimal mod setup

**Performance Conflicts**
- Lower settings if running multiple heavy mods
- Disable overlapping systems
- Monitor combined memory usage
- Use Performance Mode with multiple mods

## Technical Information

### System Requirements
- **Teardown**: Version 1.7.0 or later
- **RAM**: 8GB recommended (4GB minimum)
- **GPU**: Dedicated graphics recommended for Maximum Mode
- **CPU**: Multi-core processor for optimal performance

### File Structure
```
pcomb/
├── main.lua           (Core integration system)
├── options.lua        (Mod manager interface)
├── info.txt          (Mod metadata)
├── preview.jpg       (Mod thumbnail)
└── README.md         (This documentation)
```

### Performance Metrics
- **CPU Usage**: Moderate (scales with destruction amount)
- **Memory Usage**: 50-200MB additional (depends on settings)
- **GPU Impact**: Low to moderate (particle effects)
- **Storage**: < 1MB (no additional assets required)

### API Compliance
All functionality uses only official Teardown API functions:
- Physics simulation: Official body/shape functions
- Particle effects: Native particle system
- Audio system: Built-in sound functions
- UI system: Standard interface functions
- Configuration: Official registry functions

## Advanced Configuration

### Performance Tuning

**High-End Systems**
```lua
-- Maximum quality settings
savegame.mod.pcomb.global.priority = 3
savegame.mod.pcomb.prgd.dust_amount = 100
savegame.mod.pcomb.ibsit.particle_quality = 5
savegame.mod.pcomb.ibsit.dust_amount = 100
```

**Low-End Systems**
```lua
-- Performance optimized settings
savegame.mod.pcomb.global.priority = 1
savegame.mod.pcomb.prgd.dust_amount = 10
savegame.mod.pcomb.ibsit.particle_quality = 1
savegame.mod.pcomb.ibsit.dust_amount = 25
```

### Custom Presets

**Cinematic Mode** (Maximum visuals)
- Enable all effects
- Maximum particle counts
- Disable performance optimizations
- Enable debug mode for monitoring

**Gameplay Mode** (Balanced)
- Disable fire and violence for stability
- Moderate particle levels
- Enable smart performance scaling
- Focus on structural effects

**Minimal Mode** (Maximum performance)
- IBSIT only (most efficient)
- Minimum particle effects
- Aggressive filtering
- Performance priority

## Credits and Acknowledgments

This mod combines and enhances the work of the original mod creators:

- **Progressive Destruction**: Original PRGD system implementation
- **IBSIT Enhanced**: Advanced structural integrity analysis
- **Mass Based Collateral**: Proximity-based collapse mechanics

**Physics Combination Mod** integrates these systems with:
- Unified architecture and performance management
- Enhanced compatibility and optimization
- Improved user interfaces and configuration
- Advanced debugging and monitoring capabilities

## Version History

**Version 1.0.0** - Initial Release
- Complete integration of PRGD, IBSIT, and MBCS systems
- Dual interface system (mod manager + pause menu)
- Performance optimization and scaling
- Comprehensive configuration options
- Debug mode and monitoring tools

## Support and Feedback

For issues, suggestions, or questions:
1. Check troubleshooting section above
2. Enable debug mode to gather information
3. Test with minimal settings to isolate issues
4. Report through appropriate Teardown community channels

**Debug Information Template:**
```
System: [Windows/Mac/Linux]
Teardown Version: [e.g., 1.7.0]
Hardware: [CPU/GPU/RAM]
Settings: [Performance/Quality/Maximum]
Active Systems: [PRGD/IBSIT/MBCS enabled/disabled]
Issue: [Detailed description]
FPS: [Performance metrics]
```

---

*Enjoy enhanced physics destruction in Teardown with the unified power of three advanced physics systems!*