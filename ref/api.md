<div>

</div>

# Teardown scripting API (1.7.0)

## Teardown scripting

Teardown uses Lua version 5.1 as scripting language. The Lua 5.1
reference manual can be found [here](https://www.lua.org/manual/5.1/).
Each Teardown script runs in its own Lua context and can only interact
with the engine and other scripts through API functions and the
registry. The registry is a database of hierarchical global variables
that is used both internally in the engine, for communication between
scripts and as a way to save persistent data.

The Teardown API uses only native lua types. Handles to objects are
plain Lua numbers. Vector types are represented as plain Lua tables, and
so on. Each script has up-to 6 OPTIONAL callback functions that will be
called by the game engine.

 Function 

 Description

function init()

Called once at load time

function tick(dt)

Called exactly once per frame. The time step is variable but always
between 0.0 and 0.0333333

function update(dt) 

Called at a fixed update rate, but at the most two times per frame. Time
step is always 0.0166667 (60 updates per second). Depending on frame
rate it might not be called at all for a particular frame.

function draw()

Called when the 2D overlay is being draw, after the scene but before the
standard HUD. Ui functions can only be used from this callback.

function render(dt)

Called exactly once per frame, right before things are actually drawn to
the screen.

function postUpdate() 

Called like update, but after physics. Because update can trigger
physics updates, it can be necessary to do some additional calculations
afterwards. This is usually used by animators.

------------------------------------------------------------------------

## Parameters

Scripts can have parameters defined in the level XML file. These serve
as input to a specific instance of the script and can be used to
configure various options and parameters of the script. While these
parameters can be read at any time in the script, it\'s recommended to
copy them to a global variable in or outside the init function.

[GetIntParam](#GetIntParam) [GetFloatParam](#GetFloatParam)
[GetBoolParam](#GetBoolParam) [GetStringParam](#GetStringParam)
[GetColorParam](#GetColorParam)

------------------------------------------------------------------------

## Script control

General functions that control the operation and flow of the script.

 Physical input 

 Description

esc

Escape key

tab

Tab key

lmb

Left mouse button

rmb

Right mouse button

mmb

Middle mouse button

uparrow

Up arrow key

downarrow

Down arrow key

leftarrow

Left arrow key

rightarrow

Right arrow key

f1-f12

Function keys

backspace

Backspace key

alt

Alt key

delete

Delete key

home

Home key

end

End key

pgup

Pgup key

pgdown

Pgdown key

insert

Insert key

space

Space bar

shift

Shift key

ctrl

Ctrl key

return

Return key

any

Any key or button

a,b,c,\...

Latin, alphabetical keys a through z

0-9

Digits, zero to nine

mousedx

Mouse horizontal diff. Only valid in InputValue.

mousedy

Mouse vertical diff. Only valid in InputValue.

mousewheel

Mouse wheel. Only valid in InputValue.

 Logical input 

 Description

up

Move forward / Accelerate

down

Move backward / Brake

left

Move left

right

Move right

interact

Interact

flashlight

Flashlight

jump

Jump

crouch

Crouch

usetool

Use tool

grab

Grab

handbrake

Handbrake

map

Map

pause

Pause game (escape)

vehicleraise

Raise vehicle parts

vehiclelower

Lower vehicle parts

vehicleaction

Vehicle action

camerax

Camera x movement, scaled by sensitivity. Only valid in InputValue.

cameray

Camera y movement, scaled by sensitivity. Only valid in InputValue.

tool_group_prev

Switch to previous tool group

tool_group_next

Switch to next tool group

extra0

Extra action 0

extra1

Extra action 1

extra2

Extra action 2

extra3

Extra action 3

extra4

Extra action 4

extra5

Extra action 5

extra6

Extra action 6

photomode

Photomode

zoom

Zoom

menu_left

Menu left

menu_right

Menu right

menu_up

Menu up

menu_down

Menu down

menu_next

Menu next

menu_prev

Menu prev

menu_accept

Menu accept

menu_cancel

Menu cancel

[GetVersion](#GetVersion) [HasVersion](#HasVersion) [GetTime](#GetTime)
[GetTimeStep](#GetTimeStep) [InputLastPressedKey](#InputLastPressedKey)
[InputPressed](#InputPressed) [InputReleased](#InputReleased)
[InputDown](#InputDown) [InputValue](#InputValue)
[InputClear](#InputClear)
[InputResetOnTransition](#InputResetOnTransition)
[LastInputDevice](#LastInputDevice) [SetValue](#SetValue)
[SetValueInTable](#SetValueInTable) [PauseMenuButton](#PauseMenuButton)
[HasFile](#HasFile) [StartLevel](#StartLevel) [SetPaused](#SetPaused)
[Restart](#Restart) [Menu](#Menu)

------------------------------------------------------------------------

## Registry

The Teardown engine uses a global key/value-pair registry that scripts
can read and write. The engine exposes a lot of internal information
through the registry, but it can also be used as way for scripts to
communicate with each other.

The registry is a hierarchical node structure and can store a value in
each node (parent nodes can also have a value). The values can be of
type floating point number, integer, boolean or string, but all types
are automatically converted if another type is requested. Some registry
nodes are reserved and used for special purposes.

Registry node names may only contain the characters a-z, numbers 0-9,
dot, dash and underscore.

 Key

 Description

options

reserved for game settings (write protected from mods)

game

reserved for the game engine internals (see documentation)

savegame

used for persistent game data (write protected for mods)

savegame.mod

used for persistent mod data. Use only alphanumeric character for key
name.

level

not reserved, but recommended for level specific entries and script
communication

[ClearKey](#ClearKey) [ListKeys](#ListKeys) [HasKey](#HasKey)
[SetInt](#SetInt) [GetInt](#GetInt) [SetFloat](#SetFloat)
[GetFloat](#GetFloat) [SetBool](#SetBool) [GetBool](#GetBool)
[SetString](#SetString) [GetString](#GetString)
[GetEventCount](#GetEventCount) [GetEvent](#GetEvent)
[SetColor](#SetColor) [GetColor](#GetColor)
[GetTranslatedStringByKey](#GetTranslatedStringByKey)
[HasTranslationByKey](#HasTranslationByKey)
[LoadLanguageTable](#LoadLanguageTable)
[GetUserNickname](#GetUserNickname)

------------------------------------------------------------------------

## Vector math

Vector math is used in Teardown scripts to represent 3D positions,
directions, rotations and transforms. The base types are vectors,
quaternions and transforms. Vectors and quaternions are indexed tables
with three and four components. Transforms are tables consisting of one
vector (pos) and one quaternion (rot)

[Vec](#Vec) [VecCopy](#VecCopy) [VecStr](#VecStr)
[VecLength](#VecLength) [VecNormalize](#VecNormalize)
[VecScale](#VecScale) [VecAdd](#VecAdd) [VecSub](#VecSub)
[VecDot](#VecDot) [VecCross](#VecCross) [VecLerp](#VecLerp)
[Quat](#Quat) [QuatCopy](#QuatCopy) [QuatAxisAngle](#QuatAxisAngle)
[QuatDeltaNormals](#QuatDeltaNormals)
[QuatDeltaVectors](#QuatDeltaVectors) [QuatEuler](#QuatEuler)
[QuatAlignXZ](#QuatAlignXZ) [GetQuatEuler](#GetQuatEuler)
[QuatLookAt](#QuatLookAt) [QuatSlerp](#QuatSlerp) [QuatStr](#QuatStr)
[QuatRotateQuat](#QuatRotateQuat) [QuatRotateVec](#QuatRotateVec)
[Transform](#Transform) [TransformCopy](#TransformCopy)
[TransformStr](#TransformStr)
[TransformToParentTransform](#TransformToParentTransform)
[TransformToLocalTransform](#TransformToLocalTransform)
[TransformToParentVec](#TransformToParentVec)
[TransformToLocalVec](#TransformToLocalVec)
[TransformToParentPoint](#TransformToParentPoint)
[TransformToLocalPoint](#TransformToLocalPoint)

------------------------------------------------------------------------

## Entity

An Entity is the basis of most objects in the Teardown engine (bodies,
shapes, lights, locations, etc). All entities can have tags, which is a
way to store custom properties on entities for scripting purposes. Some
tags are also reserved for engine use. See documentation for details.

[FindEntity](#FindEntity) [FindEntities](#FindEntities)
[GetEntityChildren](#GetEntityChildren)
[GetEntityParent](#GetEntityParent) [SetTag](#SetTag)
[RemoveTag](#RemoveTag) [HasTag](#HasTag) [GetTagValue](#GetTagValue)
[ListTags](#ListTags) [GetDescription](#GetDescription)
[SetDescription](#SetDescription) [Delete](#Delete)
[IsHandleValid](#IsHandleValid) [GetEntityType](#GetEntityType)
[GetProperty](#GetProperty) [SetProperty](#SetProperty)

------------------------------------------------------------------------

## Body

A body represents a rigid body in the scene. It can be either static or
dynamic. Only dynamic bodies are affected by physics.

[FindBody](#FindBody) [FindBodies](#FindBodies)
[GetBodyTransform](#GetBodyTransform)
[SetBodyTransform](#SetBodyTransform) [GetBodyMass](#GetBodyMass)
[IsBodyDynamic](#IsBodyDynamic) [SetBodyDynamic](#SetBodyDynamic)
[SetBodyVelocity](#SetBodyVelocity) [GetBodyVelocity](#GetBodyVelocity)
[GetBodyVelocityAtPos](#GetBodyVelocityAtPos)
[SetBodyAngularVelocity](#SetBodyAngularVelocity)
[GetBodyAngularVelocity](#GetBodyAngularVelocity)
[IsBodyActive](#IsBodyActive) [SetBodyActive](#SetBodyActive)
[ApplyBodyImpulse](#ApplyBodyImpulse) [GetBodyShapes](#GetBodyShapes)
[GetBodyVehicle](#GetBodyVehicle) [GetBodyBounds](#GetBodyBounds)
[GetBodyCenterOfMass](#GetBodyCenterOfMass)
[IsBodyVisible](#IsBodyVisible) [IsBodyBroken](#IsBodyBroken)
[IsBodyJointedToStatic](#IsBodyJointedToStatic)
[DrawBodyOutline](#DrawBodyOutline)
[DrawBodyHighlight](#DrawBodyHighlight)
[GetBodyClosestPoint](#GetBodyClosestPoint)
[ConstrainVelocity](#ConstrainVelocity)
[ConstrainAngularVelocity](#ConstrainAngularVelocity)
[ConstrainPosition](#ConstrainPosition)
[ConstrainOrientation](#ConstrainOrientation)
[GetWorldBody](#GetWorldBody)

------------------------------------------------------------------------

## Shape

A shape is a voxel object and always owned by a body. A single body may
contain multiple shapes. The transform of shape is expressed in the
parent body coordinate system.

[FindShape](#FindShape) [FindShapes](#FindShapes)
[GetShapeLocalTransform](#GetShapeLocalTransform)
[SetShapeLocalTransform](#SetShapeLocalTransform)
[GetShapeWorldTransform](#GetShapeWorldTransform)
[GetShapeBody](#GetShapeBody) [GetShapeJoints](#GetShapeJoints)
[GetShapeLights](#GetShapeLights) [GetShapeBounds](#GetShapeBounds)
[SetShapeEmissiveScale](#SetShapeEmissiveScale)
[SetShapeDensity](#SetShapeDensity)
[GetShapeMaterialAtPosition](#GetShapeMaterialAtPosition)
[GetShapeMaterialAtIndex](#GetShapeMaterialAtIndex)
[GetShapeSize](#GetShapeSize) [GetShapeVoxelCount](#GetShapeVoxelCount)
[IsShapeVisible](#IsShapeVisible) [IsShapeBroken](#IsShapeBroken)
[DrawShapeOutline](#DrawShapeOutline)
[DrawShapeHighlight](#DrawShapeHighlight)
[SetShapeCollisionFilter](#SetShapeCollisionFilter)
[GetShapeCollisionFilter](#GetShapeCollisionFilter)
[CreateShape](#CreateShape) [ClearShape](#ClearShape)
[ResizeShape](#ResizeShape) [SetShapeBody](#SetShapeBody)
[CopyShapeContent](#CopyShapeContent)
[CopyShapePalette](#CopyShapePalette)
[GetShapePalette](#GetShapePalette)
[GetShapeMaterial](#GetShapeMaterial) [SetBrush](#SetBrush)
[DrawShapeLine](#DrawShapeLine) [DrawShapeBox](#DrawShapeBox)
[ExtrudeShape](#ExtrudeShape) [TrimShape](#TrimShape)
[SplitShape](#SplitShape) [MergeShape](#MergeShape)
[IsShapeDisconnected](#IsShapeDisconnected)
[IsStaticShapeDetached](#IsStaticShapeDetached)
[GetShapeClosestPoint](#GetShapeClosestPoint)
[IsShapeTouching](#IsShapeTouching)

------------------------------------------------------------------------

## Location

Locations are transforms placed in the editor as markers. Location
transforms are always expressed in world space coordinates.

[FindLocation](#FindLocation) [FindLocations](#FindLocations)
[GetLocationTransform](#GetLocationTransform)

------------------------------------------------------------------------

## Joint

Joints are used to physically connect two shapes. There are several
types of joints and they are typically placed in the editor. When
destruction occurs, joints may be transferred to new shapes, detached or
completely disabled.

[FindJoint](#FindJoint) [FindJoints](#FindJoints)
[IsJointBroken](#IsJointBroken) [GetJointType](#GetJointType)
[GetJointOtherShape](#GetJointOtherShape)
[GetJointShapes](#GetJointShapes) [SetJointMotor](#SetJointMotor)
[SetJointMotorTarget](#SetJointMotorTarget)
[GetJointLimits](#GetJointLimits) [GetJointMovement](#GetJointMovement)
[GetJointedBodies](#GetJointedBodies)
[DetachJointFromShape](#DetachJointFromShape)
[GetRopeNumberOfPoints](#GetRopeNumberOfPoints)
[GetRopePointPosition](#GetRopePointPosition)
[GetRopeBounds](#GetRopeBounds) [BreakRope](#BreakRope)

------------------------------------------------------------------------

## Animation

An animator manages a prefab hierarchy using a matching skeleton and a
set of animation sequences. These animations are processed sequentially,
generating a \"blend-tree.\"

There are two types of animations: looping and single-shot. Looping
animations must be called every frame to keep them active; otherwise,
they will stop. In contrast, single-shot animations are triggered once
and will play to completion.

Single-shot animations are automatically processed after all looping
animations, but they can be executed earlier if necessary. To ensure
that single-shot animations are processed in the correct order within
the blend-tree, an instance API is available.

Inverse Kinematics (IK) can be used, typically as the final step, to
control specific parts of the skeleton, such as reaching for an object.

[SetAnimatorPositionIK](#SetAnimatorPositionIK)
[SetAnimatorTransformIK](#SetAnimatorTransformIK)
[GetBoneChainLength](#GetBoneChainLength) [FindAnimator](#FindAnimator)
[FindAnimators](#FindAnimators)
[GetAnimatorTransform](#GetAnimatorTransform)
[GetAnimatorAdjustTransformIK](#GetAnimatorAdjustTransformIK)
[SetAnimatorTransform](#SetAnimatorTransform)
[MakeRagdoll](#MakeRagdoll) [UnRagdoll](#UnRagdoll)
[PlayAnimation](#PlayAnimation) [PlayAnimationLoop](#PlayAnimationLoop)
[PlayAnimationInstance](#PlayAnimationInstance)
[StopAnimationInstance](#StopAnimationInstance)
[PlayAnimationFrame](#PlayAnimationFrame)
[BeginAnimationGroup](#BeginAnimationGroup)
[EndAnimationGroup](#EndAnimationGroup)
[PlayAnimationInstances](#PlayAnimationInstances)
[GetAnimationClipNames](#GetAnimationClipNames)
[GetAnimationClipDuration](#GetAnimationClipDuration)
[SetAnimationClipFade](#SetAnimationClipFade)
[SetAnimationClipSpeed](#SetAnimationClipSpeed)
[TrimAnimationClip](#TrimAnimationClip)
[GetAnimationClipLoopPosition](#GetAnimationClipLoopPosition)
[GetAnimationInstancePosition](#GetAnimationInstancePosition)
[SetAnimationClipLoopPosition](#SetAnimationClipLoopPosition)
[SetBoneRotation](#SetBoneRotation) [SetBoneLookAt](#SetBoneLookAt)
[RotateBone](#RotateBone) [GetBoneNames](#GetBoneNames)
[GetBoneBody](#GetBoneBody)
[GetBoneWorldTransform](#GetBoneWorldTransform)
[GetBoneBindPoseTransform](#GetBoneBindPoseTransform)

------------------------------------------------------------------------

## Light

Light sources can be of several differnt types and configured in the
editor. If a light source is owned by a shape, the intensity of the
light source is scaled by the emissive scale of that shape. If the
parent shape breaks, the emissive scale is set to zero and the light
source is disabled. A light source without a parent shape will always
emit light, unless exlicitly disabled by a script.

[FindLight](#FindLight) [FindLights](#FindLights)
[SetLightEnabled](#SetLightEnabled) [SetLightColor](#SetLightColor)
[SetLightIntensity](#SetLightIntensity)
[GetLightTransform](#GetLightTransform) [GetLightShape](#GetLightShape)
[IsLightActive](#IsLightActive)
[IsPointAffectedByLight](#IsPointAffectedByLight)
[GetFlashlight](#GetFlashlight) [SetFlashlight](#SetFlashlight)

------------------------------------------------------------------------

## Trigger

Triggers can be placed in the scene and queried by scripts to see if
something is within a certain part of the scene.

[FindTrigger](#FindTrigger) [FindTriggers](#FindTriggers)
[GetTriggerTransform](#GetTriggerTransform)
[SetTriggerTransform](#SetTriggerTransform)
[GetTriggerBounds](#GetTriggerBounds)
[IsBodyInTrigger](#IsBodyInTrigger)
[IsVehicleInTrigger](#IsVehicleInTrigger)
[IsShapeInTrigger](#IsShapeInTrigger)
[IsPointInTrigger](#IsPointInTrigger)
[IsPointInBoundaries](#IsPointInBoundaries)
[IsTriggerEmpty](#IsTriggerEmpty)
[GetTriggerDistance](#GetTriggerDistance)
[GetTriggerClosestPoint](#GetTriggerClosestPoint)

------------------------------------------------------------------------

## Screen

Screens display the content of UI scripts and can be made interactive.

[FindScreen](#FindScreen) [FindScreens](#FindScreens)
[SetScreenEnabled](#SetScreenEnabled)
[IsScreenEnabled](#IsScreenEnabled) [GetScreenShape](#GetScreenShape)

------------------------------------------------------------------------

## Vehicle

Vehicles are set up in the editor and consists of multiple parts owned
by a vehicle entity.

[FindVehicle](#FindVehicle) [FindVehicles](#FindVehicles)
[GetVehicleTransform](#GetVehicleTransform)
[GetVehicleExhaustTransforms](#GetVehicleExhaustTransforms)
[GetVehicleVitalTransforms](#GetVehicleVitalTransforms)
[GetVehicleBodies](#GetVehicleBodies) [GetVehicleBody](#GetVehicleBody)
[GetVehicleHealth](#GetVehicleHealth)
[GetVehicleParams](#GetVehicleParams)
[SetVehicleParam](#SetVehicleParam)
[GetVehicleDriverPos](#GetVehicleDriverPos)
[GetVehicleSteering](#GetVehicleSteering)
[GetVehicleDrive](#GetVehicleDrive) [DriveVehicle](#DriveVehicle)

------------------------------------------------------------------------

## Player

The player functions expose certain information about the player.

[GetPlayerPos](#GetPlayerPos) [GetPlayerAimInfo](#GetPlayerAimInfo)
[GetPlayerPitch](#GetPlayerPitch) [GetPlayerYaw](#GetPlayerYaw)
[SetPlayerPitch](#SetPlayerPitch) [GetPlayerCrouch](#GetPlayerCrouch)
[GetPlayerTransform](#GetPlayerTransform)
[SetPlayerTransform](#SetPlayerTransform)
[ClearPlayerRig](#ClearPlayerRig)
[SetPlayerRigLocationLocalTransform](#SetPlayerRigLocationLocalTransform)
[SetPlayerRigTransform](#SetPlayerRigTransform)
[GetPlayerRigTransform](#GetPlayerRigTransform)
[GetPlayerRigLocationWorldTransform](#GetPlayerRigLocationWorldTransform)
[SetPlayerRigTags](#SetPlayerRigTags)
[GetPlayerRigHasTag](#GetPlayerRigHasTag)
[GetPlayerRigTagValue](#GetPlayerRigTagValue)
[SetPlayerGroundVelocity](#SetPlayerGroundVelocity)
[GetPlayerEyeTransform](#GetPlayerEyeTransform)
[GetPlayerCameraTransform](#GetPlayerCameraTransform)
[SetPlayerCameraOffsetTransform](#SetPlayerCameraOffsetTransform)
[SetPlayerSpawnTransform](#SetPlayerSpawnTransform)
[SetPlayerSpawnHealth](#SetPlayerSpawnHealth)
[SetPlayerSpawnTool](#SetPlayerSpawnTool)
[GetPlayerVelocity](#GetPlayerVelocity)
[SetPlayerVehicle](#SetPlayerVehicle)
[SetPlayerAnimator](#SetPlayerAnimator)
[GetPlayerAnimator](#GetPlayerAnimator)
[SetPlayerVelocity](#SetPlayerVelocity)
[GetPlayerVehicle](#GetPlayerVehicle)
[IsPlayerGrounded](#IsPlayerGrounded)
[GetPlayerGroundContact](#GetPlayerGroundContact)
[GetPlayerGrabShape](#GetPlayerGrabShape)
[GetPlayerGrabBody](#GetPlayerGrabBody)
[ReleasePlayerGrab](#ReleasePlayerGrab)
[GetPlayerGrabPoint](#GetPlayerGrabPoint)
[GetPlayerPickShape](#GetPlayerPickShape)
[GetPlayerPickBody](#GetPlayerPickBody)
[GetPlayerInteractShape](#GetPlayerInteractShape)
[GetPlayerInteractBody](#GetPlayerInteractBody)
[SetPlayerScreen](#SetPlayerScreen) [GetPlayerScreen](#GetPlayerScreen)
[SetPlayerHealth](#SetPlayerHealth) [GetPlayerHealth](#GetPlayerHealth)
[SetPlayerRegenerationState](#SetPlayerRegenerationState)
[RespawnPlayer](#RespawnPlayer)
[GetPlayerWalkingSpeed](#GetPlayerWalkingSpeed)
[SetPlayerWalkingSpeed](#SetPlayerWalkingSpeed)
[GetPlayerParam](#GetPlayerParam) [SetPlayerParam](#SetPlayerParam)
[SetPlayerHidden](#SetPlayerHidden) [RegisterTool](#RegisterTool)
[GetToolBody](#GetToolBody)
[GetToolHandPoseLocalTransform](#GetToolHandPoseLocalTransform)
[GetToolHandPoseWorldTransform](#GetToolHandPoseWorldTransform)
[SetToolHandPoseLocalTransform](#SetToolHandPoseLocalTransform)
[GetToolLocationLocalTransform](#GetToolLocationLocalTransform)
[GetToolLocationWorldTransform](#GetToolLocationWorldTransform)
[SetToolTransform](#SetToolTransform)
[SetToolAllowedZoom](#SetToolAllowedZoom)
[SetToolTransformOverride](#SetToolTransformOverride)
[SetToolOffset](#SetToolOffset)

------------------------------------------------------------------------

## Sound

Sound functions are used for playing sounds or loops in the world. There
sound functions are alwyas positioned and will be affected by acoustics
simulation. If you want to play dry sounds without acoustics you should
use UiSound and UiSoundLoop in the User Interface section.

[LoadSound](#LoadSound) [UnloadSound](#UnloadSound)
[LoadLoop](#LoadLoop) [UnloadLoop](#UnloadLoop)
[SetSoundLoopUser](#SetSoundLoopUser) [PlaySound](#PlaySound)
[PlaySoundForUser](#PlaySoundForUser) [StopSound](#StopSound)
[IsSoundPlaying](#IsSoundPlaying) [GetSoundProgress](#GetSoundProgress)
[SetSoundProgress](#SetSoundProgress) [PlayLoop](#PlayLoop)
[GetSoundLoopProgress](#GetSoundLoopProgress)
[SetSoundLoopProgress](#SetSoundLoopProgress) [PlayMusic](#PlayMusic)
[StopMusic](#StopMusic) [IsMusicPlaying](#IsMusicPlaying)
[SetMusicPaused](#SetMusicPaused) [GetMusicProgress](#GetMusicProgress)
[SetMusicProgress](#SetMusicProgress) [SetMusicVolume](#SetMusicVolume)
[SetMusicLowPass](#SetMusicLowPass)

------------------------------------------------------------------------

## Sprite

Sprites are 2D images in PNG or JPG format that can be drawn into the
world. Sprites can be drawn with ot without depth test (occluded by
geometry). Sprites will not be affected by lighting but they will go
through post processing. If you want to display positioned information
to the player as an overlay, you probably want to use the Ui functions
in combination with UiWorldToPixel instead.

[LoadSprite](#LoadSprite) [DrawSprite](#DrawSprite)

------------------------------------------------------------------------

## Scene queries

Query the level in various ways.

[QueryRequire](#QueryRequire) [QueryInclude](#QueryInclude)
[QueryRejectAnimator](#QueryRejectAnimator)
[QueryRejectVehicle](#QueryRejectVehicle)
[QueryRejectBody](#QueryRejectBody)
[QueryRejectBodies](#QueryRejectBodies)
[QueryRejectShape](#QueryRejectShape)
[QueryRejectShapes](#QueryRejectShapes) [QueryRaycast](#QueryRaycast)
[QueryRaycastRope](#QueryRaycastRope)
[QueryClosestPoint](#QueryClosestPoint)
[QueryAabbShapes](#QueryAabbShapes) [QueryAabbBodies](#QueryAabbBodies)
[QueryPath](#QueryPath) [CreatePathPlanner](#CreatePathPlanner)
[DeletePathPlanner](#DeletePathPlanner)
[PathPlannerQuery](#PathPlannerQuery) [AbortPath](#AbortPath)
[GetPathState](#GetPathState) [GetPathLength](#GetPathLength)
[GetPathPoint](#GetPathPoint) [GetLastSound](#GetLastSound)
[IsPointInWater](#IsPointInWater) [GetWindVelocity](#GetWindVelocity)

------------------------------------------------------------------------

## Particles

Functions to configure and emit particles, used for fire, smoke and
other visual effects. There are two types of particles in Teardown -
plain particles and smoke particles. Plain particles are simple
billboard particles simulated with gravity and velocity that can be used
for fire, debris, rain, snow and such. Smoke particles are only intended
for smoke and they are simulated with fluid dynamics internally and
rendered with some special tricks to get a more smoke-like appearance.

All functions in the particle API, except for SpawnParticle modify
properties in the particle state, which is then used when emitting
particles, so the idea is to set up a state, and then emit one or
several particles using that state.

Most properties in the particle state can be either constant or animated
over time. Supply a single argument for constant, two argument for
linear interpolation, and optionally a third argument for other types of
interpolation. There are also fade in and fade out parameters that fade
from and to zero.

[ParticleReset](#ParticleReset) [ParticleType](#ParticleType)
[ParticleTile](#ParticleTile) [ParticleColor](#ParticleColor)
[ParticleRadius](#ParticleRadius) [ParticleAlpha](#ParticleAlpha)
[ParticleGravity](#ParticleGravity) [ParticleDrag](#ParticleDrag)
[ParticleEmissive](#ParticleEmissive)
[ParticleRotation](#ParticleRotation)
[ParticleStretch](#ParticleStretch) [ParticleSticky](#ParticleSticky)
[ParticleCollide](#ParticleCollide) [ParticleFlags](#ParticleFlags)
[SpawnParticle](#SpawnParticle)

------------------------------------------------------------------------

## Spawning

The spawn API can be used to add entities into the existing scenes. You
can spawn existing prefab XML files or generate XML and pass it in as a
lua string.

[Spawn](#Spawn) [SpawnLayer](#SpawnLayer)

------------------------------------------------------------------------

## Miscellaneous

Functions of peripheral nature that doesn\'t fit in anywhere else

[Shoot](#Shoot) [Paint](#Paint) [PaintRGBA](#PaintRGBA)
[MakeHole](#MakeHole) [Explosion](#Explosion) [SpawnFire](#SpawnFire)
[GetFireCount](#GetFireCount) [QueryClosestFire](#QueryClosestFire)
[QueryAabbFireCount](#QueryAabbFireCount)
[RemoveAabbFires](#RemoveAabbFires)
[GetCameraTransform](#GetCameraTransform)
[SetCameraTransform](#SetCameraTransform)
[RequestFirstPerson](#RequestFirstPerson)
[RequestThirdPerson](#RequestThirdPerson)
[SetCameraOffsetTransform](#SetCameraOffsetTransform)
[AttachCameraTo](#AttachCameraTo) [SetPivotClipBody](#SetPivotClipBody)
[ShakeCamera](#ShakeCamera) [SetCameraFov](#SetCameraFov)
[SetCameraDof](#SetCameraDof) [PointLight](#PointLight)
[SetTimeScale](#SetTimeScale)
[SetEnvironmentDefault](#SetEnvironmentDefault)
[SetEnvironmentProperty](#SetEnvironmentProperty)
[GetEnvironmentProperty](#GetEnvironmentProperty)
[SetPostProcessingDefault](#SetPostProcessingDefault)
[SetPostProcessingProperty](#SetPostProcessingProperty)
[GetPostProcessingProperty](#GetPostProcessingProperty)
[DrawLine](#DrawLine) [DebugLine](#DebugLine) [DebugCross](#DebugCross)
[DebugTransform](#DebugTransform) [DebugWatch](#DebugWatch)
[DebugPrint](#DebugPrint) [RegisterListenerTo](#RegisterListenerTo)
[UnregisterListener](#UnregisterListener) [TriggerEvent](#TriggerEvent)
[LoadHaptic](#LoadHaptic) [CreateHaptic](#CreateHaptic)
[PlayHaptic](#PlayHaptic)
[PlayHapticDirectional](#PlayHapticDirectional)
[HapticIsPlaying](#HapticIsPlaying) [SetToolHaptic](#SetToolHaptic)
[StopHaptic](#StopHaptic) [SetVehicleHealth](#SetVehicleHealth)
[QueryRaycastWater](#QueryRaycastWater) [AddHeat](#AddHeat)
[GetGravity](#GetGravity) [SetGravity](#SetGravity)
[SetPlayerOrientation](#SetPlayerOrientation)
[GetPlayerOrientation](#GetPlayerOrientation)
[GetPlayerUp](#GetPlayerUp) [GetFps](#GetFps)

------------------------------------------------------------------------

## User Interface

The user interface functions are used for drawing interactive 2D
graphics and can only be called from the draw function of a script. The
ui functions are designed with the immediate mode gui paradigm in mind
and uses a cursor and state stack. Pushing and popping the stack is
cheap and designed to be called often.

[UiMakeInteractive](#UiMakeInteractive) [UiPush](#UiPush)
[UiPop](#UiPop) [UiWidth](#UiWidth) [UiHeight](#UiHeight)
[UiCenter](#UiCenter) [UiMiddle](#UiMiddle) [UiColor](#UiColor)
[UiColorFilter](#UiColorFilter) [UiResetColor](#UiResetColor)
[UiTranslate](#UiTranslate) [UiRotate](#UiRotate) [UiScale](#UiScale)
[UiGetScale](#UiGetScale) [UiClipRect](#UiClipRect)
[UiWindow](#UiWindow) [UiGetCurrentWindow](#UiGetCurrentWindow)
[UiIsInCurrentWindow](#UiIsInCurrentWindow)
[UiIsRectFullyClipped](#UiIsRectFullyClipped)
[UiIsInClipRegion](#UiIsInClipRegion)
[UiIsFullyClipped](#UiIsFullyClipped) [UiSafeMargins](#UiSafeMargins)
[UiCanvasSize](#UiCanvasSize) [UiAlign](#UiAlign)
[UiTextAlignment](#UiTextAlignment) [UiModalBegin](#UiModalBegin)
[UiModalEnd](#UiModalEnd) [UiDisableInput](#UiDisableInput)
[UiEnableInput](#UiEnableInput) [UiReceivesInput](#UiReceivesInput)
[UiGetMousePos](#UiGetMousePos)
[UiGetCanvasMousePos](#UiGetCanvasMousePos)
[UiIsMouseInRect](#UiIsMouseInRect) [UiWorldToPixel](#UiWorldToPixel)
[UiPixelToWorld](#UiPixelToWorld) [UiGetCursorPos](#UiGetCursorPos)
[UiBlur](#UiBlur) [UiFont](#UiFont) [UiFontHeight](#UiFontHeight)
[UiText](#UiText) [UiTextDisableWildcards](#UiTextDisableWildcards)
[UiTextUniformHeight](#UiTextUniformHeight)
[UiGetTextSize](#UiGetTextSize) [UiMeasureText](#UiMeasureText)
[UiGetSymbolsCount](#UiGetSymbolsCount)
[UiTextSymbolsSub](#UiTextSymbolsSub) [UiWordWrap](#UiWordWrap)
[UiTextLineSpacing](#UiTextLineSpacing) [UiTextOutline](#UiTextOutline)
[UiTextShadow](#UiTextShadow) [UiRect](#UiRect)
[UiRectOutline](#UiRectOutline) [UiRoundedRect](#UiRoundedRect)
[UiRoundedRectOutline](#UiRoundedRectOutline) [UiCircle](#UiCircle)
[UiCircleOutline](#UiCircleOutline) [UiFillImage](#UiFillImage)
[UiImage](#UiImage) [UiUnloadImage](#UiUnloadImage)
[UiHasImage](#UiHasImage) [UiGetImageSize](#UiGetImageSize)
[UiImageBox](#UiImageBox) [UiSound](#UiSound)
[UiSoundLoop](#UiSoundLoop) [UiMute](#UiMute)
[UiButtonImageBox](#UiButtonImageBox)
[UiButtonHoverColor](#UiButtonHoverColor)
[UiButtonPressColor](#UiButtonPressColor)
[UiButtonPressDist](#UiButtonPressDist)
[UiButtonTextHandling](#UiButtonTextHandling)
[UiTextButton](#UiTextButton) [UiImageButton](#UiImageButton)
[UiBlankButton](#UiBlankButton) [UiSlider](#UiSlider)
[UiSliderHoverColorFilter](#UiSliderHoverColorFilter)
[UiSliderThumbSize](#UiSliderThumbSize) [UiGetScreen](#UiGetScreen)
[UiNavComponent](#UiNavComponent)
[UiIgnoreNavigation](#UiIgnoreNavigation)
[UiResetNavigation](#UiResetNavigation)
[UiNavSkipUpdate](#UiNavSkipUpdate)
[UiIsComponentInFocus](#UiIsComponentInFocus)
[UiNavGroupBegin](#UiNavGroupBegin) [UiNavGroupEnd](#UiNavGroupEnd)
[UiNavGroupSize](#UiNavGroupSize) [UiForceFocus](#UiForceFocus)
[UiFocusedComponentId](#UiFocusedComponentId)
[UiFocusedComponentRect](#UiFocusedComponentRect)
[UiGetItemSize](#UiGetItemSize) [UiAutoTranslate](#UiAutoTranslate)
[UiBeginFrame](#UiBeginFrame) [UiResetFrame](#UiResetFrame)
[UiFrameOccupy](#UiFrameOccupy) [UiEndFrame](#UiEndFrame)
[UiFrameSkipItem](#UiFrameSkipItem) [UiGetFrameNo](#UiGetFrameNo)
[UiGetLanguage](#UiGetLanguage) [UiSetCursorState](#UiSetCursorState)

------------------------------------------------------------------------

[]{#GetIntParam}

### GetIntParam {#getintparam .function}

``` funcdef
value = GetIntParam(name, default)
```

Arguments\
[name]{.argname} [(string)]{.argtype} -- Parameter name\
[default]{.argname} [(number)]{.argtype} -- Default parameter value\

Return value\
[value]{.retname} [(number)]{.argtype} -- Parameter value\

```lua
function init()
    --Retrieve blinkcount parameter, or set to 5 if omitted
    local parameterBlinkCount = GetIntParam("blinkcount", 5)
    DebugPrint(parameterBlinkCount)
end
```

------------------------------------------------------------------------

[]{#GetFloatParam}

### GetFloatParam {#getfloatparam .function}

``` funcdef
value = GetFloatParam(name, default)
```

Arguments\
[name]{.argname} [(string)]{.argtype} -- Parameter name\
[default]{.argname} [(number)]{.argtype} -- Default parameter value\

Return value\
[value]{.retname} [(number)]{.argtype} -- Parameter value\

```lua
function init()
    --Retrieve speed parameter, or set to 10.0 if omitted
    local parameterSpeed = GetFloatParam("speed", 10.0)
    DebugPrint(parameterSpeed)
end
```

------------------------------------------------------------------------

[]{#GetBoolParam}

### GetBoolParam {#getboolparam .function}

``` funcdef
value = GetBoolParam(name, default)
```

Arguments\
[name]{.argname} [(string)]{.argtype} -- Parameter name\
[default]{.argname} [(boolean)]{.argtype} -- Default parameter value\

Return value\
[value]{.retname} [(boolean)]{.argtype} -- Parameter value\

```lua
function init()
    --Retrieve playsound parameter, or false if omitted
    local parameterPlaySound = GetBoolParam("playsound", false)
    DebugPrint(parameterPlaySound)
end
```

------------------------------------------------------------------------

[]{#GetStringParam}

### GetStringParam {#getstringparam .function}

``` funcdef
value = GetStringParam(name, default)
```

Arguments\
[name]{.argname} [(string)]{.argtype} -- Parameter name\
[default]{.argname} [(string)]{.argtype} -- Default parameter value\

Return value\
[value]{.retname} [(string)]{.argtype} -- Parameter value\

```lua
function init()
    --Retrieve mode parameter, or "idle" if omitted
    local parameterMode = GetStringParam("mode", "idle")
    DebugPrint(parameterMode)
end
```

------------------------------------------------------------------------

[]{#GetColorParam}

### GetColorParam {#getcolorparam .function}

``` funcdef
value = GetColorParam(name, default)
```

Arguments\
[name]{.argname} [(string)]{.argtype} -- Parameter name\
[default]{.argname} [(number)]{.argtype} -- Default parameter value\

Return value\
[value]{.retname} [(number)]{.argtype} -- Parameter value\

```lua
function init()
    --Retrieve color parameter, or set to 0.39, 0.39, 0.39 if omitted
    local color_r, color_g, color_b = GetColorParam("color", 0.39, 0.39, 0.39)
    DebugPrint(color_r .. " " .. color_g .. " " .. color_b)
end
```

------------------------------------------------------------------------

[]{#GetVersion}

### GetVersion {#getversion .function}

``` funcdef
version = GetVersion()
```

Arguments\
[none]{.argname}

Return value\
[version]{.retname} [(string)]{.argtype} -- Dot separated string of
current version of the game\

```lua
function init()
    local v = GetVersion()
    --v is "0.5.0"
    DebugPrint(v)
end
```

------------------------------------------------------------------------

[]{#HasVersion}

### HasVersion {#hasversion .function}

``` funcdef
match = HasVersion(version)
```

Arguments\
[version]{.argname} [(string)]{.argtype} -- Reference version\

Return value\
[match]{.retname} [(boolean)]{.argtype} -- True if current version is at
least provided one\

```lua
function init()
    if HasVersion("1.5.0") then
        --conditional code that only works on 0.6.0 or above
        DebugPrint("New version")
    else
        --legacy code that works on earlier versions
        DebugPrint("Earlier version")
    end
end
```

------------------------------------------------------------------------

[]{#GetTime}

### GetTime {#gettime .function}

``` funcdef
time = GetTime()
```

Arguments\
[none]{.argname}

Return value\
[time]{.retname} [(number)]{.argtype} -- The time in seconds since level
was started\

Returns running time of this script. If called from update, this returns
the simulated time, otherwise it returns wall time.

```lua
function update()
    local t = GetTime()
    DebugPrint(t)
end
```

------------------------------------------------------------------------

[]{#GetTimeStep}

### GetTimeStep {#gettimestep .function}

``` funcdef
dt = GetTimeStep()
```

Arguments\
[none]{.argname}

Return value\
[dt]{.retname} [(number)]{.argtype} -- The timestep in seconds\

Returns timestep of the last frame. If called from update, this returns
the simulation time step, which is always one 60th of a second
(0.0166667). If called from tick or draw it returns the actual time
since last frame.

```lua
function tick()
    local dt = GetTimeStep()
    DebugPrint("tick dt: " .. dt)
end

function update()
    local dt = GetTimeStep()
    DebugPrint("update dt: " .. dt)
end
```

------------------------------------------------------------------------

[]{#InputLastPressedKey}

### InputLastPressedKey {#inputlastpressedkey .function}

``` funcdef
name = InputLastPressedKey()
```

Arguments\
[none]{.argname}

Return value\
[name]{.retname} [(string)]{.argtype} -- Name of last pressed key, empty
if no key is pressed\

```lua
function tick()
    local name = InputLastPressedKey()
    if string.len(name) > 0 then
        DebugPrint(name) 
    end
end
```

------------------------------------------------------------------------

[]{#InputPressed}

### InputPressed {#inputpressed .function}

``` funcdef
pressed = InputPressed(input)
```

Arguments\
[input]{.argname} [(string)]{.argtype} -- The input identifier\

Return value\
[pressed]{.retname} [(boolean)]{.argtype} -- True if input was pressed
during last frame\

```lua
function tick()
    if InputPressed("interact") then
        DebugPrint("interact")
    end
end
```

------------------------------------------------------------------------

[]{#InputReleased}

### InputReleased {#inputreleased .function}

``` funcdef
pressed = InputReleased(input)
```

Arguments\
[input]{.argname} [(string)]{.argtype} -- The input identifier\

Return value\
[pressed]{.retname} [(boolean)]{.argtype} -- True if input was released
during last frame\

```lua
function tick()
    if InputReleased("interact") then
        DebugPrint("interact")
    end
end
```

------------------------------------------------------------------------

[]{#InputDown}

### InputDown {#inputdown .function}

``` funcdef
pressed = InputDown(input)
```

Arguments\
[input]{.argname} [(string)]{.argtype} -- The input identifier\

Return value\
[pressed]{.retname} [(boolean)]{.argtype} -- True if input is currently
held down\

```lua
function tick()
    if InputDown("interact") then
        DebugPrint("interact")
    end
end
```

------------------------------------------------------------------------

[]{#InputValue}

### InputValue {#inputvalue .function}

``` funcdef
value = InputValue(input)
```

Arguments\
[input]{.argname} [(string)]{.argtype} -- The input identifier\

Return value\
[value]{.retname} [(number)]{.argtype} -- Depends on input type\

```lua
local scrollPos = 0
function tick()
    scrollPos = scrollPos + InputValue("mousewheel")
    DebugPrint(scrollPos)
end
```

------------------------------------------------------------------------

[]{#InputClear}

### InputClear {#inputclear .function}

``` funcdef
InputClear()
```

Arguments\
[none]{.argname}

Return value\
[none]{.retname}

All player input is \"forgotten\" by the game after calling this
function

```lua
function update()
    -- Prints '2' because InputClear() allows the game to "forget" the player's input
    if InputDown("interact") then
        InputClear()
        if InputDown("interact") then
            DebugPrint(1)
        else
            DebugPrint(2)
        end
    end
end
```

------------------------------------------------------------------------

[]{#InputResetOnTransition}

### InputResetOnTransition {#inputresetontransition .function}

``` funcdef
InputResetOnTransition()
```

Arguments\
[none]{.argname}

Return value\
[none]{.retname}

This function will reset everything we need to reset during state
transition

```lua
function update()
    if InputDown("interact") then
        -- In this form, you won't be able to notice the result of the function; you need a specific context
        InputResetOnTransition()
    end
end
```

------------------------------------------------------------------------

[]{#LastInputDevice}

### LastInputDevice {#lastinputdevice .function}

``` funcdef
value = LastInputDevice()
```

Arguments\
[none]{.argname}

Return value\
[value]{.retname} [(number)]{.argtype} -- Last device id\

Returns the last input device id. 0 - none, 1 - mouse, 2 - gamepad

```lua
#include "ui/ui_helpers.lua"

function update()
    if LastInputDevice() == UI_DEVICE_GAMEPAD then
        DebugPrint("Last input was from gamepad")
    elseif LastInputDevice() == UI_DEVICE_MOUSE then
        DebugPrint("Last input was mouse & keyboard")
    elseif LastInputDevice() == UI_DEVICE_TOUCHSCREEN then
        DebugPrint("Last input was touchscreen")
    end
end
```

------------------------------------------------------------------------

[]{#SetValue}

### SetValue {#setvalue .function}

``` funcdef
SetValue(variable, value, [transition], [time])
```

Arguments\
[variable]{.argname} [(string)]{.argtype} -- Name of number variable in
the global context\
[value]{.argname} [(number)]{.argtype} -- The new value\
[transition]{.argname} [(string, optional)]{.argtype} -- Transition
type. See description.\
[time]{.argname} [(number, optional)]{.argtype} -- Transition time
(seconds)\

Return value\
[none]{.retname}

Set value of a number variable in the global context with an optional
transition. If a transition is provided the value will animate from
current value to the new value during the transition time. Transition
can be one of the following:

 Transition 

 Description

linear

Linear transition

cosine

Slow at beginning and end

easein

Slow at beginning

easeout

Slow at end

bounce

Bounce and overshoot new value

```lua
myValue = 0
function tick()
    --This will change the value of myValue from 0 to 1 in a linear fasion over 0.5 seconds
    SetValue("myValue", 1, "linear", 0.5)
    DebugPrint(myValue)
end
```

------------------------------------------------------------------------

[]{#SetValueInTable}

### SetValueInTable {#setvalueintable .function}

``` funcdef
SetValueInTable(tableId, memberName, newValue, type, length)
```

Arguments\
[tableId]{.argname} [(table)]{.argtype} -- Id of the table\
[memberName]{.argname} [(string)]{.argtype} -- Name of the member\
[newValue]{.argname} [(number)]{.argtype} -- New value\
[type]{.argname} [(string)]{.argtype} -- Transition type\
[length]{.argname} [(number)]{.argtype} -- Transition length\

Return value\
[none]{.retname}

Chages the value of a table member in time according to specified args.
Works similar to SetValue but for global variables of trivial types

```lua
local t = {}
function init()
    SetValueInTable(t, "score", 1, "number", 1)
end
function update()
    if InputPressed("interact") then
        SetValueInTable(t, "score", t.score + 1, "number", 1)
        DebugPrint(t.score)
    end
end
```

------------------------------------------------------------------------

[]{#PauseMenuButton}

### PauseMenuButton {#pausemenubutton .function}

``` funcdef
clicked = PauseMenuButton(title, [location])
```

Arguments\
[title]{.argname} [(string)]{.argtype} -- Text on button\
[location]{.argname} [(string, optional)]{.argtype} -- Button location.
If \"bottom_bar\" - bottom bar, if \"main_bottom\" - below \"Main menu\"
button, if \"main_top\" - above \"Main menu\" button. Default
\"bottom_bar\".\

Return value\
[clicked]{.retname} [(boolean)]{.argtype} -- True if clicked, false
otherwise\

Calling this function will add a button on the bottom bar or in the main
pause menu (center of the screen) when the game is paused. Identified by
\'location\' parameter, it can be below \"Main menu\" button (by passing
\"main_bottom\" value)or above (by passing \"main_top\"). A primary
button will be placed in the main pause menu if this function is called
from a playable mod. There can be only one primary button. Use this as a
way to bring up mod settings or other user interfaces while the game is
running. Call this function every frame from the tick function for as
long as the pause menu button should still be visible. Only one button
per script is allowed. Consecutive calls replace button added in
previous calls.

```lua
function tick()

    -- Primary button which will be placed in the main pause menu below "Main menu" button
    if PauseMenuButton("Back to Hub", "main_bottom") then
        StartLevel("hub", "level/hub.xml")
    end

    -- Primary button which will be placed in the main pause menu above "Main menu" button
    if PauseMenuButton("Back to Hub", "main_top") then
        StartLevel("hub", "level/hub.xml")
    end
    
    -- Button will be placed in the bottom bar of the pause menu
    if PauseMenuButton("MyMod Settings") then
        visible = true
    end
end

function draw()
    if visible then
        UiMakeInteractive()
    end
end

```

------------------------------------------------------------------------

[]{#HasFile}

### HasFile {#hasfile .function}

``` funcdef
exists = HasFile(path)
```

Arguments\
[path]{.argname} [(string)]{.argtype} -- Path to file\

Return value\
[exists]{.retname} [(boolean)]{.argtype} -- True if file exists\

Checks that file exists on the specified path. It is preferable to use
UiHasImage whenever possible - it has better performance

```lua
local file = "gfx/circle.png"

function draw()
    if HasFile(image) then
        DebugPrint("file " .. file .. " exists")
    end
end
```

------------------------------------------------------------------------

[]{#StartLevel}

### StartLevel {#startlevel .function}

``` funcdef
StartLevel(mission, path, [layers], [passThrough])
```

Arguments\
[mission]{.argname} [(string)]{.argtype} -- An identifier of your
choice\
[path]{.argname} [(string)]{.argtype} -- Path to level XML file\
[layers]{.argname} [(string, optional)]{.argtype} -- Active layers.
Default is no layers.\
[passThrough]{.argname} [(boolean, optional)]{.argtype} -- If set,
loading screen will have no text and music will keep playing\

Return value\
[none]{.retname}

Start a level

```lua
function init()
    --Start level with no active layers
    StartLevel("level1", "MOD/level1.xml")

    --Start level with two layers
    StartLevel("level1", "MOD/level1.xml", "vehicles targets")
end
```

------------------------------------------------------------------------

[]{#SetPaused}

### SetPaused {#setpaused .function}

``` funcdef
SetPaused(paused)
```

Arguments\
[paused]{.argname} [(boolean)]{.argtype} -- True if game should be
paused\

Return value\
[none]{.retname}

Set paused state of the game

```lua
function tick()
    if InputPressed("interact") then
        --Pause game and bring up pause menu on HUD
        SetPaused(true)
    end
end
```

------------------------------------------------------------------------

[]{#Restart}

### Restart {#restart .function}

``` funcdef
Restart()
```

Arguments\
[none]{.argname}

Return value\
[none]{.retname}

Restart level

```lua
function tick()
    if InputPressed("interact") then
        Restart()
    end
end
```

------------------------------------------------------------------------

[]{#Menu}

### Menu {#menu .function}

``` funcdef
Menu()
```

Arguments\
[none]{.argname}

Return value\
[none]{.retname}

Go to main menu

```lua
function tick()
    if InputPressed("interact") then
        Menu()
    end
end
```

------------------------------------------------------------------------

[]{#ClearKey}

### ClearKey {#clearkey .function}

``` funcdef
ClearKey(key)
```

Arguments\
[key]{.argname} [(string)]{.argtype} -- Registry key to clear\

Return value\
[none]{.retname}

Remove registry node, including all child nodes.

```lua
function init()
    --If the registry looks like this:
    --  score
    --      levels
    --          level1 = 5
    --          level2 = 4

    ClearKey("score.levels")

    --Afterwards, the registry will look like this:
    --  score
end
```

------------------------------------------------------------------------

[]{#ListKeys}

### ListKeys {#listkeys .function}

``` funcdef
children = ListKeys(parent)
```

Arguments\
[parent]{.argname} [(string)]{.argtype} -- The parent registry key\

Return value\
[children]{.retname} [(table)]{.argtype} -- Indexed table of strings
with child keys\

List all child keys of a registry node.

```lua
--If the registry looks like this:
--  game
--      tool
--          steroid
--          rifle
--          ...

function init()
    local list = ListKeys("game.tool")
    for i=1, #list do
        DebugPrint(list[i])
    end
end

--This will output:
--steroid
--rifle
-- ...
```

------------------------------------------------------------------------

[]{#HasKey}

### HasKey {#haskey .function}

``` funcdef
exists = HasKey(key)
```

Arguments\
[key]{.argname} [(string)]{.argtype} -- Registry key\

Return value\
[exists]{.retname} [(boolean)]{.argtype} -- True if key exists\

Returns true if the registry contains a certain key

```lua
function init()
    DebugPrint(HasKey("score.levels"))
    DebugPrint(HasKey("game.tool.rifle"))
end
```

------------------------------------------------------------------------

[]{#SetInt}

### SetInt {#setint .function}

``` funcdef
SetInt(key, value)
```

Arguments\
[key]{.argname} [(string)]{.argtype} -- Registry key\
[value]{.argname} [(number)]{.argtype} -- Desired value\

Return value\
[none]{.retname}

```lua
function init()
    SetInt("score.levels.level1", 4)
    DebugPrint(GetInt("score.levels.level1"))
end
```

------------------------------------------------------------------------

[]{#GetInt}

### GetInt {#getint .function}

``` funcdef
value = GetInt(key)
```

Arguments\
[key]{.argname} [(string)]{.argtype} -- Registry key\

Return value\
[value]{.retname} [(number)]{.argtype} -- Integer value of registry node
or zero if not found\

```lua
function init()
    SetInt("score.levels.level1", 4)
    DebugPrint(GetInt("score.levels.level1"))
end
```

------------------------------------------------------------------------

[]{#SetFloat}

### SetFloat {#setfloat .function}

``` funcdef
SetFloat(key, value)
```

Arguments\
[key]{.argname} [(string)]{.argtype} -- Registry key\
[value]{.argname} [(number)]{.argtype} -- Desired value\

Return value\
[none]{.retname}

```lua
function init()
    SetFloat("level.time", 22.3)
    DebugPrint(GetFloat("level.time"))
end
```

------------------------------------------------------------------------

[]{#GetFloat}

### GetFloat {#getfloat .function}

``` funcdef
value = GetFloat(key)
```

Arguments\
[key]{.argname} [(string)]{.argtype} -- Registry key\

Return value\
[value]{.retname} [(number)]{.argtype} -- Float value of registry node
or zero if not found\

```lua
function init()
    SetFloat("level.time", 22.3)
    DebugPrint(GetFloat("level.time"))
end
```

------------------------------------------------------------------------

[]{#SetBool}

### SetBool {#setbool .function}

``` funcdef
SetBool(key, value)
```

Arguments\
[key]{.argname} [(string)]{.argtype} -- Registry key\
[value]{.argname} [(boolean)]{.argtype} -- Desired value\

Return value\
[none]{.retname}

```lua
function init()
    SetBool("level.robots.enabled", true)
    DebugPrint(GetBool("level.robots.enabled"))
end
```

------------------------------------------------------------------------

[]{#GetBool}

### GetBool {#getbool .function}

``` funcdef
value = GetBool(key)
```

Arguments\
[key]{.argname} [(string)]{.argtype} -- Registry key\

Return value\
[value]{.retname} [(boolean)]{.argtype} -- Boolean value of registry
node or false if not found\

```lua
function init()
    SetBool("level.robots.enabled", true)
    DebugPrint(GetBool("level.robots.enabled"))
end
```

------------------------------------------------------------------------

[]{#SetString}

### SetString {#setstring .function}

``` funcdef
SetString(key, value)
```

Arguments\
[key]{.argname} [(string)]{.argtype} -- Registry key\
[value]{.argname} [(string)]{.argtype} -- Desired value\

Return value\
[none]{.retname}

```lua
function init()
    SetString("level.name", "foo")
    DebugPrint(GetString("level.name"))
end
```

------------------------------------------------------------------------

[]{#GetString}

### GetString {#getstring .function}

``` funcdef
value = GetString(key)
```

Arguments\
[key]{.argname} [(string)]{.argtype} -- Registry key\

Return value\
[value]{.retname} [(string)]{.argtype} -- String value of registry node
or \"\" if not found\

```lua
function init()
    SetString("level.name", "foo")
    DebugPrint(GetString("level.name"))
end
```

------------------------------------------------------------------------

[]{#GetEventCount}

### GetEventCount {#geteventcount .function}

``` funcdef
value = GetEventCount(type)
```

Arguments\
[type]{.argname} [(string)]{.argtype} -- Event type\

Return value\
[value]{.retname} [(number)]{.argtype} -- Number of event available\

```lua
local count = GetEventCount("playerdead")
for i=1, count do
    local id, attacker = GetEvent("playerdead", i)
end
```

------------------------------------------------------------------------

[]{#GetEvent}

### GetEvent {#getevent .function}

``` funcdef
returnValues = GetEvent(type, index)
```

Arguments\
[type]{.argname} [(string)]{.argtype} -- Event type\
[index]{.argname} [(number)]{.argtype} -- Event index (starting with
one)\

Return value\
[returnValues]{.retname} [(varying)]{.argtype} -- Return values
depending on event type\

```lua
local count = GetEventCount("playerdead")
for i=1, count do
    local id, attacker = GetEvent("playerdead", i)
end
```

------------------------------------------------------------------------

[]{#SetColor}

### SetColor {#setcolor .function}

``` funcdef
SetColor(key, r, g, b, [a])
```

Arguments\
[key]{.argname} [(string)]{.argtype} -- Registry key\
[r]{.argname} [(number)]{.argtype} -- Desired red channel value\
[g]{.argname} [(number)]{.argtype} -- Desired green channel value\
[b]{.argname} [(number)]{.argtype} -- Desired blue channel value\
[a]{.argname} [(number, optional)]{.argtype} -- Desired alpha channel
value\

Return value\
[none]{.retname}

Sets the color registry key value

```lua
function init()
    SetColor("game.tool.wire.color", 1.0, 0.5, 0.3)
end
```

------------------------------------------------------------------------

[]{#GetColor}

### GetColor {#getcolor .function}

``` funcdef
r, g, b, a = GetColor(key)
```

Arguments\
[key]{.argname} [(string)]{.argtype} -- Registry key\

Return value\
[r]{.retname} [(number)]{.argtype} -- Desired red channel value\
[g]{.retname} [(number)]{.argtype} -- Desired green channel value\
[b]{.retname} [(number)]{.argtype} -- Desired blue channel value\
[a]{.retname} [(number)]{.argtype} -- Desired alpha channel value\

Returns the color registry key value

```lua
function init()
    SetColor("red", 1.0, 0.1, 0.1)
    color = GetColor("red")
    DebugPrint("RGBA: " .. color[1] .. " " .. color[2] .. " " .. color[3] .. " " .. color[4])
end
```

------------------------------------------------------------------------

[]{#GetTranslatedStringByKey}

### GetTranslatedStringByKey {#gettranslatedstringbykey .function}

``` funcdef
value = GetTranslatedStringByKey(key, [default])
```

Arguments\
[key]{.argname} [(string)]{.argtype} -- Translation key\
[default]{.argname} [(string, optional)]{.argtype} -- Default value\

Return value\
[value]{.retname} [(string)]{.argtype} -- Translation\

Returns the translation for the specified key from the translation
table. If the key is not found returns the default value

```lua
function init()
    DebugPrint(GetTranslatedStringByKey("TOOL_CAMERA"))
end
```

------------------------------------------------------------------------

[]{#HasTranslationByKey}

### HasTranslationByKey {#hastranslationbykey .function}

``` funcdef
value = HasTranslationByKey(key)
```

Arguments\
[key]{.argname} [(string)]{.argtype} -- Translation key\

Return value\
[value]{.retname} [(boolean)]{.argtype} -- True if translation exists\

Checks that translation for specified key exists

```lua
function init()
    DebugPrint(HasTranslationByKey("TOOL_CAMERA"))
end
```

------------------------------------------------------------------------

[]{#LoadLanguageTable}

### LoadLanguageTable {#loadlanguagetable .function}

``` funcdef
LoadLanguageTable(id)
```

Arguments\
[id]{.argname} [(number)]{.argtype} -- Language id (enum)\

Return value\
[none]{.retname}

Loads the language table for specified language id for further
localization. Possible id values are:\

 Id 

 Language

0 

English

1 

French

2 

Spanish

3 

Italian

4 

German

5 

Simplified Chinese

6 

Japenese

7 

Russian

8 

Polish

```lua
function init()
    -- loads the english localization table
    LoadLanguageTable(0) 
end
```

------------------------------------------------------------------------

[]{#GetUserNickname}

### GetUserNickname {#getusernickname .function}

``` funcdef
value = GetUserNickname([id])
```

Arguments\
[id]{.argname} [(number, optional)]{.argtype} -- User id\

Return value\
[value]{.retname} [(string)]{.argtype} -- User nickname\

Returns the user nickname with the specified id. If id is not specified,
returns nickname for user with id \'0\'

```lua
function init()
    DebugPrint(GetUserNickname(0))
end
```

------------------------------------------------------------------------

[]{#Vec}

### Vec {#vec .function}

``` funcdef
vec = Vec([x], [y], [z])
```

Arguments\
[x]{.argname} [(number, optional)]{.argtype} -- X value\
[y]{.argname} [(number, optional)]{.argtype} -- Y value\
[z]{.argname} [(number, optional)]{.argtype} -- Z value\

Return value\
[vec]{.retname} [(TVec)]{.argtype} -- New vector\

Create new vector and optionally initializes it to the provided values.
A Vec is equivalent to a regular lua table with three numbers.

```lua
function init()
    --These are equivalent
    local a1 = Vec()
    local a2 = {0, 0, 0}
    DebugPrint("a1 == a2: " .. tostring(VecStr(a1) == VecStr(a2)))

    --These are equivalent
    local b1 = Vec(0, 1, 0)
    local b2 = {0, 1, 0}
    DebugPrint("b1 == b2: " .. tostring(VecStr(b1) == VecStr(b2)))
end
```

------------------------------------------------------------------------

[]{#VecCopy}

### VecCopy {#veccopy .function}

``` funcdef
new = VecCopy(org)
```

Arguments\
[org]{.argname} [(TVec)]{.argtype} -- A vector\

Return value\
[new]{.retname} [(TVec)]{.argtype} -- Copy of org vector\

Vectors should never be assigned like regular numbers. Since they are
implemented with lua tables assignment means two references pointing to
the same data. Use this function instead.

```lua
function init()
    --Do this to assign a vector
    local right1 = Vec(1, 2, 3)
    local right2 = VecCopy(right1)

    --Never do this unless you REALLY know what you're doing
    local wrong1 = Vec(1, 2, 3)
    local wrong2 = wrong1
end
```

------------------------------------------------------------------------

[]{#VecStr}

### VecStr {#vecstr .function}

``` funcdef
str = VecStr(vector)
```

Arguments\
[vector]{.argname} [(TVec)]{.argtype} -- Vector\

Return value\
[str]{.retname} [(string)]{.argtype} -- String representation\

Returns the string representation of vector

```lua
function init()
    local v = Vec(0, 10, 0)
    DebugPrint(VecStr(v))
end
```

------------------------------------------------------------------------

[]{#VecLength}

### VecLength {#veclength .function}

``` funcdef
length = VecLength(vec)
```

Arguments\
[vec]{.argname} [(TVec)]{.argtype} -- A vector\

Return value\
[length]{.retname} [(number)]{.argtype} -- Length (magnitude) of the
vector\

```lua
function init()
    local v = Vec(1,1,0)
    local l = VecLength(v)
    --l now equals 1.4142
    DebugPrint(l)
end
```

------------------------------------------------------------------------

[]{#VecNormalize}

### VecNormalize {#vecnormalize .function}

``` funcdef
norm = VecNormalize(vec)
```

Arguments\
[vec]{.argname} [(TVec)]{.argtype} -- A vector\

Return value\
[norm]{.retname} [(TVec)]{.argtype} -- A vector of length 1.0\

If the input vector is of zero length, the function returns {0,0,1}

```lua
function init()
    local v = Vec(0,3,0)
    local n = VecNormalize(v)
    --n now equals {0,1,0}
    DebugPrint(VecStr(n))
end
```

------------------------------------------------------------------------

[]{#VecScale}

### VecScale {#vecscale .function}

``` funcdef
norm = VecScale(vec, scale)
```

Arguments\
[vec]{.argname} [(TVec)]{.argtype} -- A vector\
[scale]{.argname} [(number)]{.argtype} -- A scale factor\

Return value\
[norm]{.retname} [(TVec)]{.argtype} -- A scaled version of input vector\

```lua
function init()
    local v = Vec(1,2,3)
    local n = VecScale(v, 2)
    --n now equals {2,4,6}
    DebugPrint(VecStr(n))
end
```

------------------------------------------------------------------------

[]{#VecAdd}

### VecAdd {#vecadd .function}

``` funcdef
c = VecAdd(a, b)
```

Arguments\
[a]{.argname} [(TVec)]{.argtype} -- Vector\
[b]{.argname} [(TVec)]{.argtype} -- Vector\

Return value\
[c]{.retname} [(TVec)]{.argtype} -- New vector with sum of a and b\

```lua
function init()
    local a = Vec(1,2,3)
    local b = Vec(3,0,0)
    local c = VecAdd(a, b)
    --c now equals {4,2,3}
    DebugPrint(VecStr(c))
end
```

------------------------------------------------------------------------

[]{#VecSub}

### VecSub {#vecsub .function}

``` funcdef
c = VecSub(a, b)
```

Arguments\
[a]{.argname} [(TVec)]{.argtype} -- Vector\
[b]{.argname} [(TVec)]{.argtype} -- Vector\

Return value\
[c]{.retname} [(TVec)]{.argtype} -- New vector representing a-b\

```lua
function init()
    local a = Vec(1,2,3)
    local b = Vec(3,0,0)
    local c = VecSub(a, b)
    --c now equals {-2,2,3}
    DebugPrint(VecStr(c))
end
```

------------------------------------------------------------------------

[]{#VecDot}

### VecDot {#vecdot .function}

``` funcdef
c = VecDot(a, b)
```

Arguments\
[a]{.argname} [(TVec)]{.argtype} -- Vector\
[b]{.argname} [(TVec)]{.argtype} -- Vector\

Return value\
[c]{.retname} [(number)]{.argtype} -- Dot product of a and b\

```lua
function init()
    local a = Vec(1,2,3)
    local b = Vec(3,1,0)
    local c = VecDot(a, b)
    --c now equals 5
    DebugPrint(c)
end
```

------------------------------------------------------------------------

[]{#VecCross}

### VecCross {#veccross .function}

``` funcdef
c = VecCross(a, b)
```

Arguments\
[a]{.argname} [(TVec)]{.argtype} -- Vector\
[b]{.argname} [(TVec)]{.argtype} -- Vector\

Return value\
[c]{.retname} [(TVec)]{.argtype} -- Cross product of a and b (also
called vector product)\

```lua
function init()
    local a = Vec(1,0,0)
    local b = Vec(0,1,0)
    local c = VecCross(a, b)
    --c now equals {0,0,1}
    DebugPrint(VecStr(c))
end
```

------------------------------------------------------------------------

[]{#VecLerp}

### VecLerp {#veclerp .function}

``` funcdef
c = VecLerp(a, b, t)
```

Arguments\
[a]{.argname} [(TVec)]{.argtype} -- Vector\
[b]{.argname} [(TVec)]{.argtype} -- Vector\
[t]{.argname} [(number)]{.argtype} -- fraction (usually between 0.0 and
1.0)\

Return value\
[c]{.retname} [(TVec)]{.argtype} -- Linearly interpolated vector between
a and b, using t\

```lua
function init()
    local a = Vec(2,0,0)
    local b = Vec(0,4,2)
    local t = 0.5
    
    --These two are equivalent
    local c1 = VecLerp(a, b, t)
    local c2 = VecAdd(VecScale(a, 1-t), VecScale(b, t))
    
    --c1 and c2 now equals {1, 2, 1}
    DebugPrint("c1" .. VecStr(c1) .. " == c2" .. VecStr(c2))
end
```

------------------------------------------------------------------------

[]{#Quat}

### Quat {#quat .function}

``` funcdef
quat = Quat([x], [y], [z], [w])
```

Arguments\
[x]{.argname} [(number, optional)]{.argtype} -- X value\
[y]{.argname} [(number, optional)]{.argtype} -- Y value\
[z]{.argname} [(number, optional)]{.argtype} -- Z value\
[w]{.argname} [(number, optional)]{.argtype} -- W value\

Return value\
[quat]{.retname} [(TQuat)]{.argtype} -- New quaternion\

Create new quaternion and optionally initializes it to the provided
values. Do not attempt to initialize a quaternion with raw values unless
you know what you are doing. Use QuatEuler or QuatAxisAngle instead. If
no arguments are given, a unit quaternion will be created: {0, 0, 0, 1}.
A quaternion is equivalent to a regular lua table with four numbers.

```lua
function init()
    --These are equivalent
    local a1 = Quat()
    local a2 = {0, 0, 0, 1}

    DebugPrint(QuatStr(a1) == QuatStr(a2))
end
```

------------------------------------------------------------------------

[]{#QuatCopy}

### QuatCopy {#quatcopy .function}

``` funcdef
new = QuatCopy(org)
```

Arguments\
[org]{.argname} [(TQuat)]{.argtype} -- Quaternion\

Return value\
[new]{.retname} [(TQuat)]{.argtype} -- Copy of org quaternion\

Quaternions should never be assigned like regular numbers. Since they
are implemented with lua tables assignment means two references pointing
to the same data. Use this function instead.

```lua
function init()
    --Do this to assign a quaternion
    local right1 = QuatEuler(0, 90, 0)
    local right2 = QuatCopy(right1)

    --Never do this unless you REALLY know what you're doing
    local wrong1 = QuatEuler(0, 90, 0)
    local wrong2 = wrong1
end
```

------------------------------------------------------------------------

[]{#QuatAxisAngle}

### QuatAxisAngle {#quataxisangle .function}

``` funcdef
quat = QuatAxisAngle(axis, angle)
```

Arguments\
[axis]{.argname} [(TVec)]{.argtype} -- Rotation axis, unit vector\
[angle]{.argname} [(number)]{.argtype} -- Rotation angle in degrees\

Return value\
[quat]{.retname} [(TQuat)]{.argtype} -- New quaternion\

Create a quaternion representing a rotation around a specific axis

```lua
function init()
    --Create quaternion representing rotation 30 degrees around Y axis
    local q = QuatAxisAngle(Vec(0,1,0), 30)
    DebugPrint(QuatStr(q))
end
```

------------------------------------------------------------------------

[]{#QuatDeltaNormals}

### QuatDeltaNormals {#quatdeltanormals .function}

``` funcdef
quat = QuatDeltaNormals(normal0, normal1)
```

Arguments\
[normal0]{.argname} [(TVec)]{.argtype} -- Unit vector\
[normal1]{.argname} [(TVec)]{.argtype} -- Unit vector\

Return value\
[quat]{.retname} [(TQuat)]{.argtype} -- New quaternion\

Create a quaternion representing a rotation between the input normals

```lua
function init()
    --Create quaternion representing a rotation between x-axis and y-axis
    local q = QuatDeltaNormals(Vec(1,0,0), Vec(0,1,0))
end
```

------------------------------------------------------------------------

[]{#QuatDeltaVectors}

### QuatDeltaVectors {#quatdeltavectors .function}

``` funcdef
quat = QuatDeltaVectors(vector0, vector1)
```

Arguments\
[vector0]{.argname} [(TVec)]{.argtype} -- Vector\
[vector1]{.argname} [(TVec)]{.argtype} -- Vector\

Return value\
[quat]{.retname} [(TQuat)]{.argtype} -- New quaternion\

Create a quaternion representing a rotation between the input vectors
that doesn\'t need to be of unit-length

```lua
function init()
    --Create quaternion representing a rotation between two non-unit vectors aligned along x-axis and y-axis
    local q = QuatDeltaVectors(Vec(10,0,0), Vec(0,5,0))
end
```

------------------------------------------------------------------------

[]{#QuatEuler}

### QuatEuler {#quateuler .function}

``` funcdef
quat = QuatEuler(x, y, z)
```

Arguments\
[x]{.argname} [(number)]{.argtype} -- Angle around X axis in degrees,
sometimes also called roll or bank\
[y]{.argname} [(number)]{.argtype} -- Angle around Y axis in degrees,
sometimes also called yaw or heading\
[z]{.argname} [(number)]{.argtype} -- Angle around Z axis in degrees,
sometimes also called pitch or attitude\

Return value\
[quat]{.retname} [(TQuat)]{.argtype} -- New quaternion\

Create quaternion using euler angle notation. The order of applied
rotations uses the \"NASA standard aeroplane\" model:

1.  Rotation around Y axis (yaw or heading)
2.  Rotation around Z axis (pitch or attitude)
3.  Rotation around X axis (roll or bank)

```lua
function init()
    --Create quaternion representing rotation 30 degrees around Y axis and 25 degrees around Z axis
    local q = QuatEuler(0, 30, 25)
end
```

------------------------------------------------------------------------

[]{#QuatAlignXZ}

### QuatAlignXZ {#quatalignxz .function}

``` funcdef
quat = QuatAlignXZ(xAxis, zAxis)
```

Arguments\
[xAxis]{.argname} [(TVec)]{.argtype} -- X axis\
[zAxis]{.argname} [(TVec)]{.argtype} -- Z axis\

Return value\
[quat]{.retname} [(TQuat)]{.argtype} -- Quaternion\

Return the quaternion aligned to specified axes

```lua
function update()
    local laserSprite = LoadSprite("gfx/laser.png")
    local origin = Vec(0, 0, 0)
    local dir = Vec(1, 0, 0)
    local length = 10
    local hitPoint = VecAdd(origin, VecScale(dir, length))
    local t = Transform(VecLerp(origin, hitPoint, 0.5))
    local xAxis = VecNormalize(VecSub(hitPoint, origin))
    local zAxis = VecNormalize(VecSub(origin, GetCameraTransform().pos))
    t.rot = QuatAlignXZ(xAxis, zAxis)
    DrawSprite(laserSprite, t, length, 0.05+math.random()*0.01, 8, 4, 4, 1, true, true)
    DrawSprite(laserSprite, t, length, 0.5, 1.0, 0.3, 0.3, 1, true, true)
end
```

------------------------------------------------------------------------

[]{#GetQuatEuler}

### GetQuatEuler {#getquateuler .function}

``` funcdef
x, y, z = GetQuatEuler(quat)
```

Arguments\
[quat]{.argname} [(TQuat)]{.argtype} -- Quaternion\

Return value\
[x]{.retname} [(number)]{.argtype} -- Angle around X axis in degrees,
sometimes also called roll or bank\
[y]{.retname} [(number)]{.argtype} -- Angle around Y axis in degrees,
sometimes also called yaw or heading\
[z]{.retname} [(number)]{.argtype} -- Angle around Z axis in degrees,
sometimes also called pitch or attitude\

Return euler angles from quaternion. The order of rotations uses the
\"NASA standard aeroplane\" model:

1.  Rotation around Y axis (yaw or heading)
2.  Rotation around Z axis (pitch or attitude)
3.  Rotation around X axis (roll or bank)

```lua
function init()
    --Return euler angles from quaternion q
    q = QuatEuler(30, 45, 0)
    rx, ry, rz = GetQuatEuler(q)
    DebugPrint(rx .. " " .. ry .. " " .. rz)
end
```

------------------------------------------------------------------------

[]{#QuatLookAt}

### QuatLookAt {#quatlookat .function}

``` funcdef
quat = QuatLookAt(eye, target)
```

Arguments\
[eye]{.argname} [(TVec)]{.argtype} -- Vector representing the camera
location\
[target]{.argname} [(TVec)]{.argtype} -- Vector representing the point
to look at\

Return value\
[quat]{.retname} [(TQuat)]{.argtype} -- New quaternion\

Create a quaternion pointing the negative Z axis (forward) towards a
specific point, keeping the Y axis upwards. This is very useful for
creating camera transforms.

```lua
function init()
    local eye = Vec(0, 10, 0)
    local target = Vec(0, 1, 5)
    local rot = QuatLookAt(eye, target)
    SetCameraTransform(Transform(eye, rot))
end
```

------------------------------------------------------------------------

[]{#QuatSlerp}

### QuatSlerp {#quatslerp .function}

``` funcdef
c = QuatSlerp(a, b, t)
```

Arguments\
[a]{.argname} [(TQuat)]{.argtype} -- Quaternion\
[b]{.argname} [(TQuat)]{.argtype} -- Quaternion\
[t]{.argname} [(number)]{.argtype} -- fraction (usually between 0.0 and
1.0)\

Return value\
[c]{.retname} [(TQuat)]{.argtype} -- New quaternion\

Spherical, linear interpolation between a and b, using t. This is very
useful for animating between two rotations.

```lua
function init()
    local a = QuatEuler(0, 10, 0)
    local b = QuatEuler(0, 0, 45)

    --Create quaternion half way between a and b
    local q = QuatSlerp(a, b, 0.5)
    DebugPrint(QuatStr(q))
end
```

------------------------------------------------------------------------

[]{#QuatStr}

### QuatStr {#quatstr .function}

``` funcdef
str = QuatStr(quat)
```

Arguments\
[quat]{.argname} [(TQuat)]{.argtype} -- Quaternion\

Return value\
[str]{.retname} [(string)]{.argtype} -- String representation\

Returns the string representation of quaternion

```lua
function init()
    local q = QuatEuler(0, 10, 0)
    DebugPrint(QuatStr(q))
end
```

------------------------------------------------------------------------

[]{#QuatRotateQuat}

### QuatRotateQuat {#quatrotatequat .function}

``` funcdef
c = QuatRotateQuat(a, b)
```

Arguments\
[a]{.argname} [(TQuat)]{.argtype} -- Quaternion\
[b]{.argname} [(TQuat)]{.argtype} -- Quaternion\

Return value\
[c]{.retname} [(TQuat)]{.argtype} -- New quaternion\

Rotate one quaternion with another quaternion. This is mathematically
equivalent to c = a \* b using quaternion multiplication.

```lua
function init()
    local a = QuatEuler(0, 10, 0)
    local b = QuatEuler(0, 0, 45)
    local q = QuatRotateQuat(a, b)

    --q now represents a rotation first 10 degrees around
    --the Y axis and then 45 degrees around the Z axis.
    local x, y, z = GetQuatEuler(q)
    DebugPrint(x .. " " .. y .. " " .. z)
end

```

------------------------------------------------------------------------

[]{#QuatRotateVec}

### QuatRotateVec {#quatrotatevec .function}

``` funcdef
vec = QuatRotateVec(a, vec)
```

Arguments\
[a]{.argname} [(TQuat)]{.argtype} -- Quaternion\
[vec]{.argname} [(TVec)]{.argtype} -- Vector\

Return value\
[vec]{.retname} [(TVec)]{.argtype} -- Rotated vector\

Rotate a vector by a quaternion

```lua
function init()
    local q = QuatEuler(0, 10, 0)
    local v = Vec(1, 0, 0)
    local r = QuatRotateVec(q, v)
    
    --r is now vector a rotated 10 degrees around the Y axis
    DebugPrint(VecStr(r))
end
```

------------------------------------------------------------------------

[]{#Transform}

### Transform {#transform .function}

``` funcdef
transform = Transform([pos], [rot])
```

Arguments\
[pos]{.argname} [(TVec, optional)]{.argtype} -- Vector representing
transform position\
[rot]{.argname} [(TQuat, optional)]{.argtype} -- Quaternion representing
transform rotation\

Return value\
[transform]{.retname} [(TTransform)]{.argtype} -- New transform\

A transform is a regular lua table with two entries: pos and rot, a
vector and quaternion representing transform position and rotation.

```lua
function init()
    --Create transform located at {0, 0, 0} with no rotation
    local t1 = Transform()

    --Create transform located at {10, 0, 0} with no rotation
    local t2 = Transform(Vec(10, 0,0))

    --Create transform located at {10, 0, 0}, rotated 45 degrees around Y axis
    local t3 = Transform(Vec(10, 0,0), QuatEuler(0, 45, 0))

    DebugPrint(TransformStr(t1))
    DebugPrint(TransformStr(t2))
    DebugPrint(TransformStr(t3))
end
```

------------------------------------------------------------------------

[]{#TransformCopy}

### TransformCopy {#transformcopy .function}

``` funcdef
new = TransformCopy(org)
```

Arguments\
[org]{.argname} [(TTransform)]{.argtype} -- Transform\

Return value\
[new]{.retname} [(TTransform)]{.argtype} -- Copy of org transform\

Transforms should never be assigned like regular numbers. Since they are
implemented with lua tables assignment means two references pointing to
the same data. Use this function instead.

```lua
function init()
    --Do this to assign a quaternion
    local right1 = Transform(Vec(1,0,0), QuatEuler(0, 90, 0))
    local right2 = TransformCopy(right1)

    --Never do this unless you REALLY know what you're doing
    local wrong1 = Transform(Vec(1,0,0), QuatEuler(0, 90, 0))
    local wrong2 = wrong1
end
```

------------------------------------------------------------------------

[]{#TransformStr}

### TransformStr {#transformstr .function}

``` funcdef
str = TransformStr(transform)
```

Arguments\
[transform]{.argname} [(TTransform)]{.argtype} -- Transform\

Return value\
[str]{.retname} [(string)]{.argtype} -- String representation\

Returns the string representation of transform

```lua
function init()
    local eye = Vec(0, 10, 0)
    local target = Vec(0, 1, 5)
    local rot = QuatLookAt(eye, target)
    local t = Transform(eye, rot)
    DebugPrint(TransformStr(t))
end
```

------------------------------------------------------------------------

[]{#TransformToParentTransform}

### TransformToParentTransform {#transformtoparenttransform .function}

``` funcdef
transform = TransformToParentTransform(parent, child)
```

Arguments\
[parent]{.argname} [(TTransform)]{.argtype} -- Transform\
[child]{.argname} [(TTransform)]{.argtype} -- Transform\

Return value\
[transform]{.retname} [(TTransform)]{.argtype} -- New transform\

Transform child transform out of the parent transform. This is the
opposite of TransformToLocalTransform.

```lua
function init()
    local b = GetBodyTransform(body)
    local s = GetShapeLocalTransform(shape)

    --b represents the location of body in world space
    --s represents the location of shape in body space

    local w = TransformToParentTransform(b, s)

    --w now represents the location of shape in world space
    DebugPrint(TransformStr(w))
end
```

------------------------------------------------------------------------

[]{#TransformToLocalTransform}

### TransformToLocalTransform {#transformtolocaltransform .function}

``` funcdef
transform = TransformToLocalTransform(parent, child)
```

Arguments\
[parent]{.argname} [(TTransform)]{.argtype} -- Transform\
[child]{.argname} [(TTransform)]{.argtype} -- Transform\

Return value\
[transform]{.retname} [(TTransform)]{.argtype} -- New transform\

Transform one transform into the local space of another transform. This
is the opposite of TransformToParentTransform.

```lua
function init()
    local b = GetBodyTransform(body)
    local w = GetShapeWorldTransform(shape)

    --b represents the location of body in world space
    --w represents the location of shape in world space
    
    local s = TransformToLocalTransform(b, w)

    --s now represents the location of shape in body space.
    DebugPrint(TransformStr(s))
end
```

------------------------------------------------------------------------

[]{#TransformToParentVec}

### TransformToParentVec {#transformtoparentvec .function}

``` funcdef
r = TransformToParentVec(t, v)
```

Arguments\
[t]{.argname} [(TTransform)]{.argtype} -- Transform\
[v]{.argname} [(TVec)]{.argtype} -- Vector\

Return value\
[r]{.retname} [(TVec)]{.argtype} -- Transformed vector\

Transfom vector v out of transform t only considering rotation.

```lua
function init()
    local t = GetBodyTransform(body)
    local localUp = Vec(0, 1, 0)
    local up = TransformToParentVec(t, localUp)

    --up now represents the local body up direction in world space
    DebugPrint(VecStr(up))
end
```

------------------------------------------------------------------------

[]{#TransformToLocalVec}

### TransformToLocalVec {#transformtolocalvec .function}

``` funcdef
r = TransformToLocalVec(t, v)
```

Arguments\
[t]{.argname} [(TTransform)]{.argtype} -- Transform\
[v]{.argname} [(TVec)]{.argtype} -- Vector\

Return value\
[r]{.retname} [(TVec)]{.argtype} -- Transformed vector\

Transfom vector v into transform t only considering rotation.

```lua
function init()
    local t = GetBodyTransform(body)
    local localUp = Vec(0, 1, 0)
    local up = TransformToParentVec(t, localUp)

    --up now represents the local body up direction in world space
    DebugPrint(VecStr(up))
end
```

------------------------------------------------------------------------

[]{#TransformToParentPoint}

### TransformToParentPoint {#transformtoparentpoint .function}

``` funcdef
r = TransformToParentPoint(t, p)
```

Arguments\
[t]{.argname} [(TTransform)]{.argtype} -- Transform\
[p]{.argname} [(TVec)]{.argtype} -- Vector representing position\

Return value\
[r]{.retname} [(TVec)]{.argtype} -- Transformed position\

Transfom position p out of transform t.

```lua
function init()
    local t = GetBodyTransform(body)
    local bodyPoint = Vec(0, 0, -1)
    local p = TransformToParentPoint(t, bodyPoint)

    --p now represents the local body point {0, 0, -1 } in world space
    DebugPrint(VecStr(p))
end
```

------------------------------------------------------------------------

[]{#TransformToLocalPoint}

### TransformToLocalPoint {#transformtolocalpoint .function}

``` funcdef
r = TransformToLocalPoint(t, p)
```

Arguments\
[t]{.argname} [(TTransform)]{.argtype} -- Transform\
[p]{.argname} [(TVec)]{.argtype} -- Vector representing position\

Return value\
[r]{.retname} [(TVec)]{.argtype} -- Transformed position\

Transfom position p into transform t.

```lua
function init()
    local t = GetBodyTransform(body)
    local worldOrigo = Vec(0, 0, 0)
    local p = TransformToLocalPoint(t, worldOrigo)

    --p now represents the position of world origo in local body space
    DebugPrint(VecStr(p))
end
```

------------------------------------------------------------------------

[]{#FindEntity}

### FindEntity {#findentity .function}

``` funcdef
handle = FindEntity([tag], [global], [type])
```

Arguments\
[tag]{.argname} [(string, optional)]{.argtype} -- Tag name\
[global]{.argname} [(boolean, optional)]{.argtype} -- Search in entire
scene\
[type]{.argname} [(string, optional)]{.argtype} -- Entity type
(\"body\", \"shape\", \"light\", \"location\" etc.)\

Return value\
[handle]{.retname} [(number)]{.argtype} -- Handle to first entity with
specified tag or zero if not found\

Returns an entity with the specified tag and type. This is a universal
method that is an alternative to FindBody, FindShape, FindVehicle, etc.

```lua
function tick()
    --You may use this function in a similar way to other "Find functions" like FindBody, FindShape, FindVehicle, etc.
    local myCar = FindEntity("myCar", false, "vehicle")

    --If you do not specify the tag, the first element found will be returned
    local joint = FindEntity("", true, "joint")

    --If the type is not specified, the search will be performed for all types of entity
    local target = FindEntity("target", true)
end
```

------------------------------------------------------------------------

[]{#FindEntities}

### FindEntities {#findentities .function}

``` funcdef
list = FindEntities([tag], [global], [type])
```

Arguments\
[tag]{.argname} [(string, optional)]{.argtype} -- Tag name\
[global]{.argname} [(boolean, optional)]{.argtype} -- Search in entire
scene\
[type]{.argname} [(string, optional)]{.argtype} -- Entity type
(\"body\", \"shape\", \"light\", \"location\" etc.)\

Return value\
[list]{.retname} [(table)]{.argtype} -- Indexed table with handles to
all entities with specified tag\

Returns a list of entities with the specified tag and type. This is a
universal method that is an alternative to FindBody, FindShape,
FindVehicle, etc.

```lua
function tick()
    -- You may use this function in a similar way to other "Find functions" like FindBody, FindShape, FindVehicle, etc.
    local cars = FindEntities("car", false, "vehicle")

    -- You can get all the entities of the specified type by passing an empty string to the tag
    local allJoints = FindEntities("", true, "joint")

    -- If the type is not specified, the search will be performed for all types
    local allUnbreakables = FindEntities("unbreakable", true)
end
```

------------------------------------------------------------------------

[]{#GetEntityChildren}

### GetEntityChildren {#getentitychildren .function}

``` funcdef
list = GetEntityChildren(handle, [tag], [recursive], [type])
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Entity handle\
[tag]{.argname} [(string, optional)]{.argtype} -- Tag name\
[recursive]{.argname} [(boolean, optional)]{.argtype} -- Search
recursively\
[type]{.argname} [(string, optional)]{.argtype} -- Entity type
(\"body\", \"shape\", \"light\", \"location\" etc.)\

Return value\
[list]{.retname} [(table)]{.argtype} -- Indexed table with child
elements of the entity\

Returns child entities

```lua
function tick()
    local car = FindEntity("car", true, "vehicle")
    DebugWatch("car", car)

    local children = GetEntityChildren(entity, "", true, "wheel")
    for i = 1, #children do
        DebugWatch("wheel " .. tostring(i), children[i])
    end
end
```

------------------------------------------------------------------------

[]{#GetEntityParent}

### GetEntityParent {#getentityparent .function}

``` funcdef
handle = GetEntityParent(handle, [tag], [type])
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Entity handle\
[tag]{.argname} [(string, optional)]{.argtype} -- Tag name\
[type]{.argname} [(string, optional)]{.argtype} -- Entity type
(\"body\", \"shape\", \"light\", \"location\" etc.)\

Return value\
[handle]{.retname} [(number)]{.argtype} --\

```lua
function tick()
    local wheel = FindEntity("", true, "wheel")
    local vehicle = GetEntityParent(wheel,  "", "vehicle")
    DebugWatch("Wheel vehicle", GetEntityType(vehicle) .. " " .. tostring(vehicle))
end
```

------------------------------------------------------------------------

[]{#SetTag}

### SetTag {#settag .function}

``` funcdef
SetTag(handle, tag, [value])
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Entity handle\
[tag]{.argname} [(string)]{.argtype} -- Tag name\
[value]{.argname} [(string, optional)]{.argtype} -- Tag value\

Return value\
[none]{.retname}

```lua
function init()
    local handle = FindBody("body", true)
    --Add "special" tag to an entity
    SetTag(handle, "special")
    DebugPrint(HasTag(handle, "special"))

    --Add "team" tag to an entity and give it value "red"
    SetTag(handle, "team", "red")
    DebugPrint(HasTag(handle, "team"))
end
```

------------------------------------------------------------------------

[]{#RemoveTag}

### RemoveTag {#removetag .function}

``` funcdef
RemoveTag(handle, tag)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Entity handle\
[tag]{.argname} [(string)]{.argtype} -- Tag name\

Return value\
[none]{.retname}

Remove tag from an entity. If the tag had a value it is removed too.

```lua
function init()
    local handle = FindBody("body", true)
    --Add "special" tag to an entity
    SetTag(handle, "special")
    RemoveTag(handle, "special")
    DebugPrint(HasTag(handle, "special"))

    --Add "team" tag to an entity and give it value "red"
    SetTag(handle, "team", "red")
    DebugPrint(HasTag(handle, "team"))
end
```

------------------------------------------------------------------------

[]{#HasTag}

### HasTag {#hastag .function}

``` funcdef
exists = HasTag(handle, tag)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Entity handle\
[tag]{.argname} [(string)]{.argtype} -- Tag name\

Return value\
[exists]{.retname} [(boolean)]{.argtype} -- Returns true if entity has
tag\

```lua
function init()
    local handle = FindBody("body", true)
    --Add "special" tag to an entity
    SetTag(handle, "special")
    DebugPrint(HasTag(handle, "special"))

    --Add "team" tag to an entity and give it value "red"
    SetTag(handle, "team", "red")
    DebugPrint(HasTag(handle, "team"))
end
```

------------------------------------------------------------------------

[]{#GetTagValue}

### GetTagValue {#gettagvalue .function}

``` funcdef
value = GetTagValue(handle, tag)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Entity handle\
[tag]{.argname} [(string)]{.argtype} -- Tag name\

Return value\
[value]{.retname} [(string)]{.argtype} -- Returns the tag value, if any.
Empty string otherwise.\

```lua
function init()
    local handle = FindBody("body", true)

    --Add "team" tag to an entity and give it value "red"
    SetTag(handle, "team", "red")
    DebugPrint(GetTagValue(handle, "team"))
end
```

------------------------------------------------------------------------

[]{#ListTags}

### ListTags {#listtags .function}

``` funcdef
tags = ListTags(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Entity handle\

Return value\
[tags]{.retname} [(table)]{.argtype} -- Indexed table of tags on entity\

```lua
function init()
    local handle = FindBody("body", true)

    --Add "team" tag to an entity and give it value "red"
    SetTag(handle, "team", "red")
    
    --List all tags and their tag values for a particular entity
    local tags = ListTags(handle)
    for i=1, #tags do
        DebugPrint(tags[i] .. " " .. GetTagValue(handle, tags[i]))
    end
end
```

------------------------------------------------------------------------

[]{#GetDescription}

### GetDescription {#getdescription .function}

``` funcdef
description = GetDescription(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Entity handle\

Return value\
[description]{.retname} [(string)]{.argtype} -- The description string\

All entities can have an associated description. For bodies and shapes
this can be provided through the editor. This function retrieves that
description.

```lua
function init()
    local body = FindBody("body", true)
    DebugPrint(GetDescription(body))
end
```

------------------------------------------------------------------------

[]{#SetDescription}

### SetDescription {#setdescription .function}

``` funcdef
SetDescription(handle, description)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Entity handle\
[description]{.argname} [(string)]{.argtype} -- The description string\

Return value\
[none]{.retname}

All entities can have an associated description. The description for
bodies and shapes will show up on the HUD when looking at them.

```lua
function init()
    local body = FindBody("body", true)
    SetDescription(body, "Target object")
    DebugPrint(GetDescription(body))
end
```

------------------------------------------------------------------------

[]{#Delete}

### Delete {#delete .function}

``` funcdef
Delete(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Entity handle\

Return value\
[none]{.retname}

Remove an entity from the scene. All entities owned by this entity will
also be removed.

```lua
function init()
    local body = FindBody("body", true)
    --All shapes associated with body will also be removed
    Delete(body)
end
```

------------------------------------------------------------------------

[]{#IsHandleValid}

### IsHandleValid {#ishandlevalid .function}

``` funcdef
exists = IsHandleValid(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Entity handle\

Return value\
[exists]{.retname} [(boolean)]{.argtype} -- Returns true if the entity
pointed to by handle still exists\

```lua
function init()
    local body = FindBody("body", true)

    --valid is true if body still exists
    DebugPrint(IsHandleValid(body))
    Delete(body)

    --valid will now be false
    DebugPrint(IsHandleValid(body))
end
```

------------------------------------------------------------------------

[]{#GetEntityType}

### GetEntityType {#getentitytype .function}

``` funcdef
type = GetEntityType(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Entity handle\

Return value\
[type]{.retname} [(string)]{.argtype} -- Type name of the provided
entity\

Returns the type name of provided entity, for example \"body\",
\"shape\", \"light\", etc.

```lua
function init()
    local body = FindBody("body", true)
    DebugPrint(GetEntityType(body))
end
```

------------------------------------------------------------------------

[]{#GetProperty}

### GetProperty {#getproperty .function}

``` funcdef
value = GetProperty(handle, property)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Entity handle\
[property]{.argname} [(string)]{.argtype} -- Property name\

Return value\
[value]{.retname} [(any)]{.argtype} -- Property value\

 Entity type 

 Available params

Body

desc (string), dynamic (boolean), mass (number), transform, velocity
(vector(x, y, z)), angVelocity (vector(x, y, z)), active (boolean),
friction (number), restitution (number), frictionMode
(average\|minimum\|multiply\|maximum), restitutionMode
(average\|minimum\|multiply\|maximum)

Shape

density (number), strength (number), size (number), emissiveScale
(number), localTransform, worldTransform

Light

enabled (boolean), color (vector(r, g, b)), intensity (number),
transform, active (boolean), type (string), size (number), reach
(number), unshadowed (number), fogscale (number), fogiter (number),
glare (number)

Location

transform

Water

depth (number), wave (number), ripple (number), motion (number), foam
(number), color (vector(r, g, b))

Joint

type (string), size (number), rotstrength (number), rotspring (number);
only for ropes: slack (number), strength (number), maxstretch (number),
ropecolor (vector(r, g, b))

Vehicle

spring (number), damping (number), topspeed (number), acceleration
(number), strength (number), antispin (number), antiroll (number),
difflock (number), steerassist (number), friction (number),
smokeintensity (number), transform, brokenthreshold (number)

Wheel

drive (number), steer (number), travel (vector(x, y))

Screen

enabled (boolean), bulge (number), resolution (number, number), script
(string), interactive (boolean), emissive (number), fxraster (number),
fxca (number), fxnoise (number), fxglitch (number), size (vector(x, y))

Trigger

transform, type (string), size (vector(x, y, z)/number)

```lua
function tick()
    local body = FindBody("testbody", true)
    local isDynamic = GetProperty(body, "dynamic")
    DebugWatch("isDynamic", isDynamic)
end
```

------------------------------------------------------------------------

[]{#SetProperty}

### SetProperty {#setproperty .function}

``` funcdef
SetProperty(handle, property, value)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Entity handle\
[property]{.argname} [(string)]{.argtype} -- Property name\
[value]{.argname} [(any)]{.argtype} -- Property value\

Return value\
[none]{.retname}

 Entity type 

 Available params

Body

desc (string), dynamic (boolean), transform, velocity (vector(x, y, z)),
angVelocity (vector(x,y,z)), active (boolean), friction (number),
restitution (number), frictionMode
(average\|minimum\|multiply\|maximum), restitutionMode
(average\|minimum\|multiply\|maximum)

Shape

density (number), strength (number), emissiveScale (number),
localTransform

Light

enabled (boolean), color (vector(r, g, b)), intensity (number),
transform, size (number/vector(x,y)), reach (number), unshadowed
(number), fogscale (number), fogiter (number), glare (number)

Location

transform

Water

type (string), depth (number), wave (number), ripple (number), motion
(number), foam (number), color (vector(r, g, b))

Joint

size (number), rotstrength (number), rotspring (number); only for ropes:
slack (number), strength (number), maxstretch (number), ropecolor
(vector(r, g, b))

Vehicle

spring (number), damping (number), topspeed (number), acceleration
(number), strength (number), antispin (number), antiroll (number),
difflock (number), steerassist (number), friction (number),
smokeintensity (number), transform, brokenthreshold (number)

Wheel

drive (number), steer (number), travel (vector(x, y))

Screen

enabled (boolean), interactive (boolean), emissive (number), fxraster
(number), fxca (number), fxnoise (number), fxglitch (number)

Trigger

transform, size (vector(x, y, z)/number)

```lua
function tick()
    local light = FindLight("mylight", true)
    SetProperty(light, "intensity", math.abs(math.sin(GetTime())))
end
```

------------------------------------------------------------------------

[]{#FindBody}

### FindBody {#findbody .function}

``` funcdef
handle = FindBody([tag], [global])
```

Arguments\
[tag]{.argname} [(string, optional)]{.argtype} -- Tag name\
[global]{.argname} [(boolean, optional)]{.argtype} -- Search in entire
scene\

Return value\
[handle]{.retname} [(number)]{.argtype} -- Handle to first body with
specified tag or zero if not found\

```lua
function init()
    --Search for a body tagged "target" in script scope
    local target = FindBody("body")
    DebugPrint(target)

    --Search for a body tagged "escape" in entire scene
    local escape = FindBody("body", true)
    DebugPrint(escape)
end
```

------------------------------------------------------------------------

[]{#FindBodies}

### FindBodies {#findbodies .function}

``` funcdef
list = FindBodies([tag], [global])
```

Arguments\
[tag]{.argname} [(string, optional)]{.argtype} -- Tag name\
[global]{.argname} [(boolean, optional)]{.argtype} -- Search in entire
scene\

Return value\
[list]{.retname} [(table)]{.argtype} -- Indexed table with handles to
all bodies with specified tag\

```lua
function init()
    --Search for bodies tagged "target" in script scope
    local targets = FindBodies("target", true)
    for i=1, #targets do
        local target = targets[i]
        DebugPrint(target)
    end
end
```

------------------------------------------------------------------------

[]{#GetBodyTransform}

### GetBodyTransform {#getbodytransform .function}

``` funcdef
transform = GetBodyTransform(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Body handle\

Return value\
[transform]{.retname} [(TTransform)]{.argtype} -- Transform of the body\

```lua
function init()
    local handle = FindBody("target", true)
    local t = GetBodyTransform(handle)
    DebugPrint(TransformStr(t))
end
```

------------------------------------------------------------------------

[]{#SetBodyTransform}

### SetBodyTransform {#setbodytransform .function}

``` funcdef
SetBodyTransform(handle, transform)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Body handle\
[transform]{.argname} [(TTransform)]{.argtype} -- Desired transform\

Return value\
[none]{.retname}

```lua
function init()
    local handle = FindBody("body", true)

    --Move a body 1 meter upwards
    local t = GetBodyTransform(handle)
    t.pos = VecAdd(t.pos, Vec(0, 3, 0))
    SetBodyTransform(handle, t)
end
```

------------------------------------------------------------------------

[]{#GetBodyMass}

### GetBodyMass {#getbodymass .function}

``` funcdef
mass = GetBodyMass(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Body handle\

Return value\
[mass]{.retname} [(number)]{.argtype} -- Body mass. Static bodies always
return zero mass.\

```lua
function init()
    local handle = FindBody("body", true)

    --Move a body 1 meter upwards
    local mass = GetBodyMass(handle)
    DebugPrint(mass)
end
```

------------------------------------------------------------------------

[]{#IsBodyDynamic}

### IsBodyDynamic {#isbodydynamic .function}

``` funcdef
dynamic = IsBodyDynamic(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Body handle\

Return value\
[dynamic]{.retname} [(boolean)]{.argtype} -- Return true if body is
dynamic\

Check if body is dynamic. Note that something that was created static
may become dynamic due to destruction.

```lua
function init()
    local handle = FindBody("body", true)
    DebugPrint(IsBodyDynamic(handle))
end
```

------------------------------------------------------------------------

[]{#SetBodyDynamic}

### SetBodyDynamic {#setbodydynamic .function}

``` funcdef
SetBodyDynamic(handle, dynamic)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Body handle\
[dynamic]{.argname} [(boolean)]{.argtype} -- True for dynamic. False for
static.\

Return value\
[none]{.retname}

Change the dynamic state of a body. There is very limited use for this
function. In most situations you should leave it up to the engine to
decide. Use with caution.

```lua
function init()
    local handle = FindBody("body", true)
    SetBodyDynamic(handle, false)
    DebugPrint(IsBodyDynamic(handle))
end
```

------------------------------------------------------------------------

[]{#SetBodyVelocity}

### SetBodyVelocity {#setbodyvelocity .function}

``` funcdef
SetBodyVelocity(handle, velocity)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Body handle (should be a
dynamic body)\
[velocity]{.argname} [(TVec)]{.argtype} -- Vector with linear velocity\

Return value\
[none]{.retname}

This can be used for animating bodies with preserved physical
interaction, but in most cases you are better off with a motorized joint
instead.

```lua
function init()
    local handle = FindBody("body", true)
    local vel = Vec(0,10,0)
    SetBodyVelocity(handle, vel)
end
```

------------------------------------------------------------------------

[]{#GetBodyVelocity}

### GetBodyVelocity {#getbodyvelocity .function}

``` funcdef
velocity = GetBodyVelocity(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Body handle (should be a
dynamic body)\

Return value\
[velocity]{.retname} [(TVec)]{.argtype} -- Linear velocity as vector\

```lua
function init()
    handle = FindBody("body", true)
    local vel = Vec(0,10,0)
    SetBodyVelocity(handle, vel)
end

function tick()
    DebugPrint(VecStr(GetBodyVelocity(handle)))
end
```

------------------------------------------------------------------------

[]{#GetBodyVelocityAtPos}

### GetBodyVelocityAtPos {#getbodyvelocityatpos .function}

``` funcdef
velocity = GetBodyVelocityAtPos(handle, pos)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Body handle (should be a
dynamic body)\
[pos]{.argname} [(TVec)]{.argtype} -- World space point as vector\

Return value\
[velocity]{.retname} [(TVec)]{.argtype} -- Linear velocity on body at
pos as vector\

Return the velocity on a body taking both linear and angular velocity
into account.

```lua
function init()
    handle = FindBody("body", true)
    local vel = Vec(0,10,0)
    SetBodyVelocity(handle, vel)
end

function tick()
    DebugPrint(VecStr(GetBodyVelocityAtPos(handle, Vec(0, 0, 0))))
end
```

------------------------------------------------------------------------

[]{#SetBodyAngularVelocity}

### SetBodyAngularVelocity {#setbodyangularvelocity .function}

``` funcdef
SetBodyAngularVelocity(handle, angVel)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Body handle (should be a
dynamic body)\
[angVel]{.argname} [(TVec)]{.argtype} -- Vector with angular velocity\

Return value\
[none]{.retname}

This can be used for animating bodies with preserved physical
interaction, but in most cases you are better off with a motorized joint
instead.

```lua
function init()
    handle = FindBody("body", true)
    local angVel = Vec(0,100,0)
    SetBodyAngularVelocity(handle, angVel)
end
```

------------------------------------------------------------------------

[]{#GetBodyAngularVelocity}

### GetBodyAngularVelocity {#getbodyangularvelocity .function}

``` funcdef
angVel = GetBodyAngularVelocity(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Body handle (should be a
dynamic body)\

Return value\
[angVel]{.retname} [(TVec)]{.argtype} -- Angular velocity as vector\

```lua
function init()
    handle = FindBody("body", true)
    local angVel = Vec(0,100,0)
    SetBodyAngularVelocity(handle, angVel)
end

function tick()
    DebugPrint(VecStr(GetBodyAngularVelocity(handle)))
end
```

------------------------------------------------------------------------

[]{#IsBodyActive}

### IsBodyActive {#isbodyactive .function}

``` funcdef
active = IsBodyActive(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Body handle\

Return value\
[active]{.retname} [(boolean)]{.argtype} -- Return true if body is
active\

Check if body is body is currently simulated. For performance reasons,
bodies that don\'t move are taken out of the simulation. This function
can be used to query the active state of a specific body. Only dynamic
bodies can be active.

```lua
-- try to break the body to see the logs
function tick()
    handle = FindBody("body", true)
    if IsBodyActive(handle) then
        DebugPrint("Body is active")
    end
end
```

------------------------------------------------------------------------

[]{#SetBodyActive}

### SetBodyActive {#setbodyactive .function}

``` funcdef
SetBodyActive(handle, active)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Body handle\
[active]{.argname} [(boolean)]{.argtype} -- Set to tru if body should be
active (simulated)\

Return value\
[none]{.retname}

This function makes it possible to manually activate and deactivate
bodies to include or exclude in simulation. The engine normally handles
this automatically, so use with care.

```lua
function tick()
    handle = FindBody("body", true)

    -- Forces body to "sleep"
    SetBodyActive(handle, false)
    if IsBodyActive(handle) then
        DebugPrint("Body is active")
    end
end
```

------------------------------------------------------------------------

[]{#ApplyBodyImpulse}

### ApplyBodyImpulse {#applybodyimpulse .function}

``` funcdef
ApplyBodyImpulse(handle, position, impulse)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Body handle (should be a
dynamic body)\
[position]{.argname} [(TVec)]{.argtype} -- World space position as
vector\
[impulse]{.argname} [(TVec)]{.argtype} -- World space impulse as vector\

Return value\
[none]{.retname}

Apply impulse to dynamic body at position (give body a push).

```lua
function tick()
    handle = FindBody("body", true)

    local pos = Vec(0,1,0)
    local imp = Vec(0,0,10)
    ApplyBodyImpulse(handle, pos, imp)
end
```

------------------------------------------------------------------------

[]{#GetBodyShapes}

### GetBodyShapes {#getbodyshapes .function}

``` funcdef
list = GetBodyShapes(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Body handle\

Return value\
[list]{.retname} [(table)]{.argtype} -- Indexed table of shape handles\

Return handles to all shapes owned by a body

```lua
function init()
    handle = FindBody("body", true)

    local shapes = GetBodyShapes(handle)
    for i=1,#shapes do
        local shape = shapes[i]
        DebugPrint(shape)
    end
end
```

------------------------------------------------------------------------

[]{#GetBodyVehicle}

### GetBodyVehicle {#getbodyvehicle .function}

``` funcdef
handle = GetBodyVehicle(body)
```

Arguments\
[body]{.argname} [(number)]{.argtype} -- Body handle\

Return value\
[handle]{.retname} [(number)]{.argtype} -- Get parent vehicle for body,
or zero if not part of vehicle\

```lua
function init()
    handle = FindBody("body", true)

    local vehicle = GetBodyVehicle(handle)
    DebugPrint(vehicle)
end
```

------------------------------------------------------------------------

[]{#GetBodyBounds}

### GetBodyBounds {#getbodybounds .function}

``` funcdef
min, max = GetBodyBounds(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Body handle\

Return value\
[min]{.retname} [(TVec)]{.argtype} -- Vector representing the AABB lower
bound\
[max]{.retname} [(TVec)]{.argtype} -- Vector representing the AABB upper
bound\

Return the world space, axis-aligned bounding box for a body.

```lua
function init()
    handle = FindBody("body", true)

    local min, max = GetBodyBounds(handle)
    local boundsSize = VecSub(max, min)
    local center = VecLerp(min, max, 0.5)
    DebugPrint(VecStr(boundsSize) .. " " .. VecStr(center))
end
```

------------------------------------------------------------------------

[]{#GetBodyCenterOfMass}

### GetBodyCenterOfMass {#getbodycenterofmass .function}

``` funcdef
point = GetBodyCenterOfMass(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Body handle\

Return value\
[point]{.retname} [(TVec)]{.argtype} -- Vector representing local center
of mass in body space\

```lua
function init()
    handle = FindBody("body", true)
end

function tick()
    --Visualize center of mass on for body
    local com = GetBodyCenterOfMass(handle)
    local worldPoint = TransformToParentPoint(GetBodyTransform(handle), com)
    DebugCross(worldPoint)
end
```

------------------------------------------------------------------------

[]{#IsBodyVisible}

### IsBodyVisible {#isbodyvisible .function}

``` funcdef
visible = IsBodyVisible(handle, maxDist, [rejectTransparent])
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Body handle\
[maxDist]{.argname} [(number)]{.argtype} -- Maximum visible distance\
[rejectTransparent]{.argname} [(boolean, optional)]{.argtype} -- See
through transparent materials. Default false.\

Return value\
[visible]{.retname} [(boolean)]{.argtype} -- Return true if body is
visible\

This function does a very rudimetary check and will only return true if
the object is visible within 74 degrees of the camera\'s forward
direction, and only tests line-of-sight visibility for the corners and
center of the bounding box.

```lua
local handle = 0
function init()
    handle = FindBody("body", true)
end

function tick()
    if IsBodyVisible(handle, 25) then
        --Body is within 25 meters visible to the camera
        DebugPrint("visible")
    else
        DebugPrint("not visible")
    end
end
```

------------------------------------------------------------------------

[]{#IsBodyBroken}

### IsBodyBroken {#isbodybroken .function}

``` funcdef
broken = IsBodyBroken(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Body handle\

Return value\
[broken]{.retname} [(boolean)]{.argtype} -- Return true if body is
broken\

Determine if any shape of a body has been broken.

```lua
local handle = 0
function init()
    handle = FindBody("body", true)
end

function tick()
    DebugPrint(IsBodyBroken(handle))
end
```

------------------------------------------------------------------------

[]{#IsBodyJointedToStatic}

### IsBodyJointedToStatic {#isbodyjointedtostatic .function}

``` funcdef
result = IsBodyJointedToStatic(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Body handle\

Return value\
[result]{.retname} [(boolean)]{.argtype} -- Return true if body is in
any way connected to a static body\

Determine if a body is in any way connected to a static object, either
by being static itself or be being directly or indirectly jointed to
something static.

```lua
local handle = 0
function init()
    handle = FindBody("body", true)
end

function tick()
    DebugPrint(IsBodyJointedToStatic(handle))
end
```

------------------------------------------------------------------------

[]{#DrawBodyOutline}

### DrawBodyOutline {#drawbodyoutline .function}

``` funcdef
DrawBodyOutline(handle, [r], [g], [b], [a])
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Body handle\
[r]{.argname} [(number, optional)]{.argtype} -- Red\
[g]{.argname} [(number, optional)]{.argtype} -- Green\
[b]{.argname} [(number, optional)]{.argtype} -- Blue\
[a]{.argname} [(number, optional)]{.argtype} -- Alpha\

Return value\
[none]{.retname}

Render next frame with an outline around specified body. If no color is
given, a white outline will be drawn.

```lua
local handle = 0
function init()
    handle = FindBody("body", true)
end

function tick()
    if InputDown("interact") then
        --Draw white outline at 50% transparency
        DrawBodyOutline(handle, 0.5)
    else
        --Draw green outline, fully opaque
        DrawBodyOutline(handle, 0, 1, 0, 1)
    end
end
```

------------------------------------------------------------------------

[]{#DrawBodyHighlight}

### DrawBodyHighlight {#drawbodyhighlight .function}

``` funcdef
DrawBodyHighlight(handle, amount)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Body handle\
[amount]{.argname} [(number)]{.argtype} -- Amount\

Return value\
[none]{.retname}

Flash the appearance of a body when rendering this frame. This is used
for valuables in the game.

```lua
local handle = 0
function init()
    handle = FindBody("body", true)
end

function tick()
    if InputDown("interact") then
        DrawBodyHighlight(handle, 0.5)
    end
end
```

------------------------------------------------------------------------

[]{#GetBodyClosestPoint}

### GetBodyClosestPoint {#getbodyclosestpoint .function}

``` funcdef
hit, point, normal, shape = GetBodyClosestPoint(body, origin)
```

Arguments\
[body]{.argname} [(number)]{.argtype} -- Body handle\
[origin]{.argname} [(TVec)]{.argtype} -- World space point\

Return value\
[hit]{.retname} [(boolean)]{.argtype} -- True if a point was found\
[point]{.retname} [(TVec)]{.argtype} -- World space closest point\
[normal]{.retname} [(TVec)]{.argtype} -- World space normal at closest
point\
[shape]{.retname} [(number)]{.argtype} -- Handle to closest shape\

This will return the closest point of a specific body

```lua
local handle = 0
function init()
    handle = FindBody("body", true)
end

function tick()
    DebugCross(Vec(1, 0, 0))
    local hit, p, n, s = GetBodyClosestPoint(handle, Vec(1, 0, 0))
    if hit then
        DebugCross(p)
    end
end
```

------------------------------------------------------------------------

[]{#ConstrainVelocity}

### ConstrainVelocity {#constrainvelocity .function}

``` funcdef
ConstrainVelocity(bodyA, bodyB, point, dir, relVel, [min], [max])
```

Arguments\
[bodyA]{.argname} [(number)]{.argtype} -- First body handle (zero for
static)\
[bodyB]{.argname} [(number)]{.argtype} -- Second body handle (zero for
static)\
[point]{.argname} [(TVec)]{.argtype} -- World space point\
[dir]{.argname} [(TVec)]{.argtype} -- World space direction\
[relVel]{.argname} [(number)]{.argtype} -- Desired relative velocity
along the provided direction\
[min]{.argname} [(number, optional)]{.argtype} -- Minimum impulse
(default: -infinity)\
[max]{.argname} [(number, optional)]{.argtype} -- Maximum impulse
(default: infinity)\

Return value\
[none]{.retname}

This will tell the physics solver to constrain the velocity between two
bodies. The physics solver will try to reach the desired goal, while not
applying an impulse bigger than the min and max values. This function
should only be used from the update callback.

```lua
local handleA = 0
local handleB = 0
function init()
    handleA = FindBody("body", true)
    handleB = FindBody("target", true)
end

function update()
    --Constrain the velocity between bodies A and B so that the relative velocity 
    --along the X axis at point (0, 5, 0) is always 3 m/s
    ConstrainVelocity(handleA, handleB, Vec(0, 5, 0), Vec(1, 0, 0), 3)
end
```

------------------------------------------------------------------------

[]{#ConstrainAngularVelocity}

### ConstrainAngularVelocity {#constrainangularvelocity .function}

``` funcdef
ConstrainAngularVelocity(bodyA, bodyB, dir, relAngVel, [min], [max])
```

Arguments\
[bodyA]{.argname} [(number)]{.argtype} -- First body handle (zero for
static)\
[bodyB]{.argname} [(number)]{.argtype} -- Second body handle (zero for
static)\
[dir]{.argname} [(TVec)]{.argtype} -- World space direction\
[relAngVel]{.argname} [(number)]{.argtype} -- Desired relative angular
velocity along the provided direction\
[min]{.argname} [(number, optional)]{.argtype} -- Minimum angular
impulse (default: -infinity)\
[max]{.argname} [(number, optional)]{.argtype} -- Maximum angular
impulse (default: infinity)\

Return value\
[none]{.retname}

This will tell the physics solver to constrain the angular velocity
between two bodies. The physics solver will try to reach the desired
goal, while not applying an angular impulse bigger than the min and max
values. This function should only be used from the update callback.

```lua
local handleA = 0
local handleB = 0
function init()
    handleA = FindBody("body", true)
    handleB = FindBody("target", true)
end

function update()
    --Constrain the angular velocity between bodies A and B so that the relative angular velocity
    --along the Y axis is always 3 rad/s
    ConstrainAngularVelocity(handleA, handleB, Vec(1, 0, 0), 3)
end
```

------------------------------------------------------------------------

[]{#ConstrainPosition}

### ConstrainPosition {#constrainposition .function}

``` funcdef
ConstrainPosition(bodyA, bodyB, pointA, pointB, [maxVel], [maxImpulse])
```

Arguments\
[bodyA]{.argname} [(number)]{.argtype} -- First body handle (zero for
static)\
[bodyB]{.argname} [(number)]{.argtype} -- Second body handle (zero for
static)\
[pointA]{.argname} [(TVec)]{.argtype} -- World space point for first
body\
[pointB]{.argname} [(TVec)]{.argtype} -- World space point for second
body\
[maxVel]{.argname} [(number, optional)]{.argtype} -- Maximum relative
velocity (default: infinite)\
[maxImpulse]{.argname} [(number, optional)]{.argtype} -- Maximum impulse
(default: infinite)\

Return value\
[none]{.retname}

This is a helper function that uses ConstrainVelocity to constrain a
point on one body to a point on another body while not affecting the
bodies more than the provided maximum relative velocity and maximum
impulse. In other words: physically push on the bodies so that pointA
and pointB are aligned in world space. This is useful for physically
animating objects. This function should only be used from the update
callback.

```lua
local handleA = 0
local handleB = 0
function init()
    handleA = FindBody("body", true)
    handleB = FindBody("target", true)
end

function update()
    --Constrain the origo of body a to an animated point in the world
    local worldPos = Vec(0, 3+math.sin(GetTime()), 0)
    ConstrainPosition(handleA, 0, GetBodyTransform(handleA).pos, worldPos)

    --Constrain the origo of body a to the origo of body b (like a ball joint)
    ConstrainPosition(handleA, handleA, GetBodyTransform(handleA).pos, GetBodyTransform(handleB).pos)
end
```

------------------------------------------------------------------------

[]{#ConstrainOrientation}

### ConstrainOrientation {#constrainorientation .function}

``` funcdef
ConstrainOrientation(bodyA, bodyB, quatA, quatB, [maxAngVel], [maxAngImpulse])
```

Arguments\
[bodyA]{.argname} [(number)]{.argtype} -- First body handle (zero for
static)\
[bodyB]{.argname} [(number)]{.argtype} -- Second body handle (zero for
static)\
[quatA]{.argname} [(TQuat)]{.argtype} -- World space orientation for
first body\
[quatB]{.argname} [(TQuat)]{.argtype} -- World space orientation for
second body\
[maxAngVel]{.argname} [(number, optional)]{.argtype} -- Maximum relative
angular velocity (default: infinite)\
[maxAngImpulse]{.argname} [(number, optional)]{.argtype} -- Maximum
angular impulse (default: infinite)\

Return value\
[none]{.retname}

This is the angular counterpart to ConstrainPosition, a helper function
that uses ConstrainAngularVelocity to constrain the orientation of one
body to the orientation on another body while not affecting the bodies
more than the provided maximum relative angular velocity and maximum
angular impulse. In other words: physically rotate the bodies so that
quatA and quatB are aligned in world space. This is useful for
physically animating objects. This function should only be used from the
update callback.

```lua
local handleA = 0
local handleB = 0
function init()
    handleA = FindBody("body", true)
    handleB = FindBody("target", true)
end

function update()
    --Constrain the orietation of body a to an upright orientation in the world
    ConstrainOrientation(handleA, 0, GetBodyTransform(handleA).rot, Quat())

    --Constrain the orientation of body a to the orientation of body b
    ConstrainOrientation(handleA, handleB, GetBodyTransform(handleA).rot, GetBodyTransform(handleB).rot)
end
```

------------------------------------------------------------------------

[]{#GetWorldBody}

### GetWorldBody {#getworldbody .function}

``` funcdef
body = GetWorldBody()
```

Arguments\
[none]{.argname}

Return value\
[body]{.retname} [(number)]{.argtype} -- Handle to the static world
body\

Every scene in Teardown has an implicit static world body that contains
all shapes that are not explicitly assigned a body in the editor.

```lua
local handle
function init()
    handle = GetWorldBody()
end

function tick()
    DebugCross(GetBodyTransform(handle).pos)
end
```

------------------------------------------------------------------------

[]{#FindShape}

### FindShape {#findshape .function}

``` funcdef
handle = FindShape([tag], [global])
```

Arguments\
[tag]{.argname} [(string, optional)]{.argtype} -- Tag name\
[global]{.argname} [(boolean, optional)]{.argtype} -- Search in entire
scene\

Return value\
[handle]{.retname} [(number)]{.argtype} -- Handle to first shape with
specified tag or zero if not found\

```lua
local target = 0
local escape = 0
function init()
    --Search for a shape tagged "mybox" in script scope
    target = FindShape("mybox")

    --Search for a shape tagged "laserturret" in entire scene
    escape = FindShape("laserturret", true)
end

function tick()
    DebugCross(GetShapeWorldTransform(target).pos)
    DebugCross(GetShapeWorldTransform(escape).pos)
end
```

------------------------------------------------------------------------

[]{#FindShapes}

### FindShapes {#findshapes .function}

``` funcdef
list = FindShapes([tag], [global])
```

Arguments\
[tag]{.argname} [(string, optional)]{.argtype} -- Tag name\
[global]{.argname} [(boolean, optional)]{.argtype} -- Search in entire
scene\

Return value\
[list]{.retname} [(table)]{.argtype} -- Indexed table with handles to
all shapes with specified tag\

```lua
local shapes = {}
function init()
    --Search for shapes tagged "body"
    shapes = FindShapes("body", true)
end

function tick()
    for i=1, #shapes do
        local shape = shapes[i]
        DebugCross(GetShapeWorldTransform(shape).pos)
    end
end
```

------------------------------------------------------------------------

[]{#GetShapeLocalTransform}

### GetShapeLocalTransform {#getshapelocaltransform .function}

``` funcdef
transform = GetShapeLocalTransform(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Shape handle\

Return value\
[transform]{.retname} [(TTransform)]{.argtype} -- Return shape transform
in body space\

```lua
local shape = 0
function init()
    shape = FindShape("shape")
end

function tick()
    --Shape transform in body local space
    local shapeTransform = GetShapeLocalTransform(shape)

    --Body transform in world space
    local bodyTransform = GetBodyTransform(GetShapeBody(shape))

    --Shape transform in world space
    local worldTranform = TransformToParentTransform(bodyTransform, shapeTransform)

    DebugCross(worldTranform)
end
```

------------------------------------------------------------------------

[]{#SetShapeLocalTransform}

### SetShapeLocalTransform {#setshapelocaltransform .function}

``` funcdef
SetShapeLocalTransform(handle, transform)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Shape handle\
[transform]{.argname} [(TTransform)]{.argtype} -- Shape transform in
body space\

Return value\
[none]{.retname}

```lua
local shape = 0
function init()
    shape = FindShape("shape")
    local transform = Transform(Vec(0, 1, 0), QuatEuler(0, 90, 0))
    SetShapeLocalTransform(shape, transform)
end

function tick()
    --Shape transform in body local space
    local shapeTransform = GetShapeLocalTransform(shape)

    --Body transform in world space
    local bodyTransform = GetBodyTransform(GetShapeBody(shape))

    --Shape transform in world space
    local worldTranform = TransformToParentTransform(bodyTransform, shapeTransform)

    DebugCross(worldTranform)
end
```

------------------------------------------------------------------------

[]{#GetShapeWorldTransform}

### GetShapeWorldTransform {#getshapeworldtransform .function}

``` funcdef
transform = GetShapeWorldTransform(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Shape handle\

Return value\
[transform]{.retname} [(TTransform)]{.argtype} -- Return shape transform
in world space\

This is a convenience function, transforming the shape out of body space

```lua
--GetShapeWorldTransform is equivalent to
--local shapeTransform = GetShapeLocalTransform(shape)
--local bodyTransform = GetBodyTransform(GetShapeBody(shape))
--worldTranform = TransformToParentTransform(bodyTransform, shapeTransform)

local shape = 0
function init()
    shape = FindShape("shape", true)
end

function tick()
    DebugCross(GetShapeWorldTransform(shape).pos)
end
```

------------------------------------------------------------------------

[]{#GetShapeBody}

### GetShapeBody {#getshapebody .function}

``` funcdef
handle = GetShapeBody(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Shape handle\

Return value\
[handle]{.retname} [(number)]{.argtype} -- Body handle\

Get handle to the body this shape is owned by. A shape is always owned
by a body, but can be transfered to a new body during destruction.

```lua
local body = 0
function init()
    body = GetShapeBody(FindShape("shape", true), true)
end

function tick()
    DebugCross(GetBodyCenterOfMass(body))
end
```

------------------------------------------------------------------------

[]{#GetShapeJoints}

### GetShapeJoints {#getshapejoints .function}

``` funcdef
list = GetShapeJoints(shape)
```

Arguments\
[shape]{.argname} [(number)]{.argtype} -- Shape handle\

Return value\
[list]{.retname} [(table)]{.argtype} -- Indexed table with joints
connected to shape\

```lua
local shape = 0
function init()
    shape = FindShape("shape", true)

    local hinges = GetShapeJoints(shape)
    for i=1, #hinges do
        local joint = hinges[i]
        DebugPrint(joint)
    end
end
```

------------------------------------------------------------------------

[]{#GetShapeLights}

### GetShapeLights {#getshapelights .function}

``` funcdef
list = GetShapeLights(shape)
```

Arguments\
[shape]{.argname} [(number)]{.argtype} -- Shape handle\

Return value\
[list]{.retname} [(table)]{.argtype} -- Indexed table of lights owned by
shape\

```lua
local shape = 0
function init()
    shape = FindShape("shape", true)

    local light = GetShapeLights(shape)
    for i=1, #light do
        DebugPrint(light[i])
    end
end
```

------------------------------------------------------------------------

[]{#GetShapeBounds}

### GetShapeBounds {#getshapebounds .function}

``` funcdef
min, max = GetShapeBounds(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Shape handle\

Return value\
[min]{.retname} [(TVec)]{.argtype} -- Vector representing the AABB lower
bound\
[max]{.retname} [(TVec)]{.argtype} -- Vector representing the AABB upper
bound\

Return the world space, axis-aligned bounding box for a shape.

```lua
local shape = 0
function init()
    shape = FindShape("shape", true)

    local min, max = GetShapeBounds(shape)
    local boundsSize = VecSub(max, min)
    local center = VecLerp(min, max, 0.5)

    DebugPrint(VecStr(boundsSize) .. " " .. VecStr(center))
end
```

------------------------------------------------------------------------

[]{#SetShapeEmissiveScale}

### SetShapeEmissiveScale {#setshapeemissivescale .function}

``` funcdef
SetShapeEmissiveScale(handle, scale)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Shape handle\
[scale]{.argname} [(number)]{.argtype} -- Scale factor for emissiveness\

Return value\
[none]{.retname}

Scale emissiveness for shape. If the shape has light sources attached,
their intensity will be scaled by the same amount.

```lua
local shape = 0
function init()
    shape = FindShape("shape", true)

    --Pulsate emissiveness and light intensity for shape
    local scale = math.sin(GetTime())*0.5 + 0.5
    SetShapeEmissiveScale(shape, scale)
end
```

------------------------------------------------------------------------

[]{#SetShapeDensity}

### SetShapeDensity {#setshapedensity .function}

``` funcdef
SetShapeDensity(handle, density)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Shape handle\
[density]{.argname} [(number)]{.argtype} -- New density for the shape\

Return value\
[none]{.retname}

Change the material density of the shape.

```lua
local shape = 0
function init()
    shape = FindShape("shape", true)

    local density = 10.0
    SetShapeDensity(shape, density)
end
```

------------------------------------------------------------------------

[]{#GetShapeMaterialAtPosition}

### GetShapeMaterialAtPosition {#getshapematerialatposition .function}

``` funcdef
type, r, g, b, a, entry = GetShapeMaterialAtPosition(handle, pos, [includeUnphysical])
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Shape handle\
[pos]{.argname} [(TVec)]{.argtype} -- Position in world space\
[includeUnphysical]{.argname} [(boolean, optional)]{.argtype} -- Include
unphysical voxels in the search. Default false.\

Return value\
[type]{.retname} [(string)]{.argtype} -- Material type\
[r]{.retname} [(number)]{.argtype} -- Red\
[g]{.retname} [(number)]{.argtype} -- Green\
[b]{.retname} [(number)]{.argtype} -- Blue\
[a]{.retname} [(number)]{.argtype} -- Alpha\
[entry]{.retname} [(number)]{.argtype} -- Palette entry for voxel (zero
if empty)\

Return material properties for a particular voxel

```lua
local shape = 0
function init()
    shape = FindShape("shape", true)
end

function tick()
    local pos = GetCameraTransform().pos
    local dir = Vec(0, 0, 1)
    local hit, dist, normal, shape = QueryRaycast(pos, dir, 10)
    if hit then
        local hitPoint = VecAdd(pos, VecScale(dir, dist))
        local mat = GetShapeMaterialAtPosition(shape, hitPoint)
        DebugPrint("Raycast hit voxel made out of " .. mat)
    end
    DebugLine(pos, VecAdd(pos, VecScale(dir, 10)))
end
```

------------------------------------------------------------------------

[]{#GetShapeMaterialAtIndex}

### GetShapeMaterialAtIndex {#getshapematerialatindex .function}

``` funcdef
type, r, g, b, a, entry = GetShapeMaterialAtIndex(handle, x, y, z)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Shape handle\
[x]{.argname} [(number)]{.argtype} -- X integer coordinate\
[y]{.argname} [(number)]{.argtype} -- Y integer coordinate\
[z]{.argname} [(number)]{.argtype} -- Z integer coordinate\

Return value\
[type]{.retname} [(string)]{.argtype} -- Material type\
[r]{.retname} [(number)]{.argtype} -- Red\
[g]{.retname} [(number)]{.argtype} -- Green\
[b]{.retname} [(number)]{.argtype} -- Blue\
[a]{.retname} [(number)]{.argtype} -- Alpha\
[entry]{.retname} [(number)]{.argtype} -- Palette entry for voxel (zero
if empty)\

Return material properties for a particular voxel in the voxel grid
indexed by integer values. The first index is zero (not one, as opposed
to a lot of lua related things)

```lua
local shape = 0
function init()
    shape = FindShape("shape", true)
    local mat = GetShapeMaterialAtIndex(shape, 0, 0, 0)
    DebugPrint("The voxel is of material: " .. mat)
end
```

------------------------------------------------------------------------

[]{#GetShapeSize}

### GetShapeSize {#getshapesize .function}

``` funcdef
xsize, ysize, zsize, scale = GetShapeSize(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Shape handle\

Return value\
[xsize]{.retname} [(number)]{.argtype} -- Size in voxels along x axis\
[ysize]{.retname} [(number)]{.argtype} -- Size in voxels along y axis\
[zsize]{.retname} [(number)]{.argtype} -- Size in voxels along z axis\
[scale]{.retname} [(number)]{.argtype} -- The size of one voxel in
meters (with default scale it is 0.1)\

Return the size of a shape in voxels

```lua
local shape = 0
function init()
    shape = FindShape("shape", true)
    local x, y, z = GetShapeSize(shape)
    DebugPrint("Shape size: " .. x .. ";" .. y .. ";" .. z)
end
```

------------------------------------------------------------------------

[]{#GetShapeVoxelCount}

### GetShapeVoxelCount {#getshapevoxelcount .function}

``` funcdef
count = GetShapeVoxelCount(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Shape handle\

Return value\
[count]{.retname} [(number)]{.argtype} -- Number of voxels in shape\

Return the number of voxels in a shape, not including empty space

```lua
local shape = 0
function init()
    shape = FindShape("shape", true)
    local voxelCount = GetShapeVoxelCount(shape)
    DebugPrint(voxelCount)
end
```

------------------------------------------------------------------------

[]{#IsShapeVisible}

### IsShapeVisible {#isshapevisible .function}

``` funcdef
visible = IsShapeVisible(handle, maxDist, [rejectTransparent])
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Shape handle\
[maxDist]{.argname} [(number)]{.argtype} -- Maximum visible distance\
[rejectTransparent]{.argname} [(boolean, optional)]{.argtype} -- See
through transparent materials. Default false.\

Return value\
[visible]{.retname} [(boolean)]{.argtype} -- Return true if shape is
visible\

This function does a very rudimetary check and will only return true if
the object is visible within 74 degrees of the camera\'s forward
direction, and only tests line-of-sight visibility for the corners and
center of the bounding box.

```lua
local shape = 0
function init()
    shape = FindShape("shape", true)
end

function tick()
    if IsShapeVisible(shape, 25) then
        DebugPrint("Shape is visible")
    else
        DebugPrint("Shape is not visible")
    end
end
```

------------------------------------------------------------------------

[]{#IsShapeBroken}

### IsShapeBroken {#isshapebroken .function}

``` funcdef
broken = IsShapeBroken(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Shape handle\

Return value\
[broken]{.retname} [(boolean)]{.argtype} -- Return true if shape is
broken\

Determine if shape has been broken. Note that a shape can be transfered
to another body during destruction, but might still not be considered
broken if all voxels are intact.

```lua
local shape = 0
function init()
    shape = FindShape("shape", true)
end

function tick()
    DebugPrint("Is shape broken: " .. tostring(IsShapeBroken(shape)))
end
```

------------------------------------------------------------------------

[]{#DrawShapeOutline}

### DrawShapeOutline {#drawshapeoutline .function}

``` funcdef
DrawShapeOutline(handle, [r], [g], [b], a)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Shape handle\
[r]{.argname} [(number, optional)]{.argtype} -- Red\
[g]{.argname} [(number, optional)]{.argtype} -- Green\
[b]{.argname} [(number, optional)]{.argtype} -- Blue\
[a]{.argname} [(number)]{.argtype} -- Alpha\

Return value\
[none]{.retname}

Render next frame with an outline around specified shape. If no color is
given, a white outline will be drawn.

```lua
local shape = 0
function init()
    shape = FindShape("shape", true)
end

function tick()
    if InputDown("interact") then
        --Draw white outline at 50% transparency
        DrawShapeOutline(shape, 0.5)
    else
        --Draw green outline, fully opaque
        DrawShapeOutline(shape, 0, 1, 0, 1)
    end
end
```

------------------------------------------------------------------------

[]{#DrawShapeHighlight}

### DrawShapeHighlight {#drawshapehighlight .function}

``` funcdef
DrawShapeHighlight(handle, amount)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Shape handle\
[amount]{.argname} [(number)]{.argtype} -- Amount\

Return value\
[none]{.retname}

Flash the appearance of a shape when rendering this frame.

```lua
local shape = 0
function init()
    shape = FindShape("shape", true)
end

function tick()
    if InputDown("interact") then
        DrawShapeHighlight(shape, 0.5)
    end
end
```

------------------------------------------------------------------------

[]{#SetShapeCollisionFilter}

### SetShapeCollisionFilter {#setshapecollisionfilter .function}

``` funcdef
SetShapeCollisionFilter(handle, layer, mask)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Shape handle\
[layer]{.argname} [(number)]{.argtype} -- Layer bits (0-255)\
[mask]{.argname} [(number)]{.argtype} -- Mask bits (0-255)\

Return value\
[none]{.retname}

This is used to filter out collisions with other shapes. Each shape can
be given a layer bitmask (8 bits, 0-255) along with a mask (also 8
bits). The layer of one object must be in the mask of the other object
and vice versa for the collision to be valid. The default layer for all
objects is 1 and the default mask is 255 (collide with all layers).

```lua
local shapeA = 0
local shapeB = 0
local shapeC = 0
local shapeD = 0
function init()
    shapeA = FindShape("shapeA")
    shapeB = FindShape("shapeB")
    shapeC = FindShape("shapeC")
    shapeD = FindShape("shapeD")
    --This will put shapes a and b in layer 2 and disable collisions with
    --object shapes in layers 2, preventing any collisions between the two.
    SetShapeCollisionFilter(shapeA, 2, 255-2)
    SetShapeCollisionFilter(shapeB, 2, 255-2)

    --This will put shapes c and d in layer 4 and allow collisions with other
    --shapes in layer 4, but ignore all other collisions with the rest of the world.
    SetShapeCollisionFilter(shapeC, 4, 4)
    SetShapeCollisionFilter(shapeD, 4, 4)
end
```

------------------------------------------------------------------------

[]{#GetShapeCollisionFilter}

### GetShapeCollisionFilter {#getshapecollisionfilter .function}

``` funcdef
layer, mask = GetShapeCollisionFilter(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Shape handle\

Return value\
[layer]{.retname} [(number)]{.argtype} -- Layer bits (0-255)\
[mask]{.retname} [(number)]{.argtype} -- Mask bits (0-255)\

Returns the current layer/mask settings of the shape

```lua
function init()
    local shape = FindShape("some_shape")
    local layer, mask = GetShapeCollisionFilter(shape)
end
```

------------------------------------------------------------------------

[]{#CreateShape}

### CreateShape {#createshape .function}

``` funcdef
newShape = CreateShape(body, transform, refShape)
```

Arguments\
[body]{.argname} [(number)]{.argtype} -- Body handle\
[transform]{.argname} [(TTransform)]{.argtype} -- Shape transform in
body space\
[refShape]{.argname} [(number)]{.argtype} -- Handle to reference shape
or path to vox file\

Return value\
[newShape]{.retname} [(number)]{.argtype} -- Handle of new shape\

Create new, empty shape on existing body using the palette of a
reference shape. The reference shape can be any existing shape in the
scene or an external vox file. The size of the new shape will be 1x1x1.

```lua
function tick()
    if InputPressed("interact") then
        local t = Transform(Vec(0, 5, 0), QuatEuler(0, 0, 0))
        local handle = CreateShape(FindBody("shape", true), t, FindShape("shape", true))
        DebugPrint(handle)
    end
end
```

------------------------------------------------------------------------

[]{#ClearShape}

### ClearShape {#clearshape .function}

``` funcdef
ClearShape(shape)
```

Arguments\
[shape]{.argname} [(number)]{.argtype} -- Shape handle\

Return value\
[none]{.retname}

Fill a voxel shape with zeroes, thus removing all voxels.

```lua
function init()
    ClearShape(FindShape("shape", true))
end
```

------------------------------------------------------------------------

[]{#ResizeShape}

### ResizeShape {#resizeshape .function}

``` funcdef
resized, offset = ResizeShape(shape, xmi, ymi, zmi, xma, yma, zma)
```

Arguments\
[shape]{.argname} [(number)]{.argtype} -- Shape handle\
[xmi]{.argname} [(number)]{.argtype} -- Lower X coordinate\
[ymi]{.argname} [(number)]{.argtype} -- Lower Y coordinate\
[zmi]{.argname} [(number)]{.argtype} -- Lower Z coordinate\
[xma]{.argname} [(number)]{.argtype} -- Upper X coordinate\
[yma]{.argname} [(number)]{.argtype} -- Upper Y coordinate\
[zma]{.argname} [(number)]{.argtype} -- Upper Z coordinate\

Return value\
[resized]{.retname} [(boolean)]{.argtype} -- Resized successfully\
[offset]{.retname} [(TVec)]{.argtype} -- Offset vector in shape local
space\

Resize an existing shape. The new coordinates are expressed in the
existing shape coordinate frame, so you can provide negative values. The
existing content is preserved, but may be cropped if needed. The local
shape transform will be moved automatically with an offset vector to
preserve the original content in body space. This offset vector is
returned in shape local space.

```lua
function init()
    ResizeShape(FindShape("shape", true), -5, 0, -5, 5, 5, 5)
end
```

------------------------------------------------------------------------

[]{#SetShapeBody}

### SetShapeBody {#setshapebody .function}

``` funcdef
SetShapeBody(shape, body, [transform])
```

Arguments\
[shape]{.argname} [(number)]{.argtype} -- Shape handle\
[body]{.argname} [(number)]{.argtype} -- Body handle\
[transform]{.argname} [(TTransform, optional)]{.argtype} -- New local
shape transform. Default is existing local transform.\

Return value\
[none]{.retname}

Move existing shape to a new body, optionally providing a new local
transform.

```lua
function init()
    SetShapeBody(FindShape("shape", true), FindBody("custombody", true), true)
end
```

------------------------------------------------------------------------

[]{#CopyShapeContent}

### CopyShapeContent {#copyshapecontent .function}

``` funcdef
CopyShapeContent(src, dst)
```

Arguments\
[src]{.argname} [(number)]{.argtype} -- Source shape handle\
[dst]{.argname} [(number)]{.argtype} -- Destination shape handle\

Return value\
[none]{.retname}

Copy voxel content from source shape to destination shape. If
destination shape has a different size, it will be resized to match the
source shape.

```lua
function init()
    CopyShapeContent(FindShape("shape", true), FindShape("shape2", true))
end
```

------------------------------------------------------------------------

[]{#CopyShapePalette}

### CopyShapePalette {#copyshapepalette .function}

``` funcdef
CopyShapePalette(src, dst)
```

Arguments\
[src]{.argname} [(number)]{.argtype} -- Source shape handle\
[dst]{.argname} [(number)]{.argtype} -- Destination shape handle\

Return value\
[none]{.retname}

Copy the palette from source shape to destination shape.

```lua
function init()
    CopyShapePalette(FindShape("shape", true), FindShape("shape2", true))
end
```

------------------------------------------------------------------------

[]{#GetShapePalette}

### GetShapePalette {#getshapepalette .function}

``` funcdef
entries = GetShapePalette(shape)
```

Arguments\
[shape]{.argname} [(number)]{.argtype} -- Shape handle\

Return value\
[entries]{.retname} [(table)]{.argtype} -- Palette material entries\

Return list of material entries, each entry is a material index that can
be provided to GetShapeMaterial or used as brush for populating a shape.

```lua
function init()
    local palette = GetShapePalette(FindShape("shape2", true))
    for i = 1, #palette do
        DebugPrint(palette[i])
    end
end
```

------------------------------------------------------------------------

[]{#GetShapeMaterial}

### GetShapeMaterial {#getshapematerial .function}

``` funcdef
type, red, green, blue, alpha, reflectivity, shininess, metallic, emissive = GetShapeMaterial(shape, entry)
```

Arguments\
[shape]{.argname} [(number)]{.argtype} -- Shape handle\
[entry]{.argname} [(number)]{.argtype} -- Material entry\

Return value\
[type]{.retname} [(string)]{.argtype} -- Type\
[red]{.retname} [(number)]{.argtype} -- Red value\
[green]{.retname} [(number)]{.argtype} -- Green value\
[blue]{.retname} [(number)]{.argtype} -- Blue value\
[alpha]{.retname} [(number)]{.argtype} -- Alpha value\
[reflectivity]{.retname} [(number)]{.argtype} -- Range 0 to 1\
[shininess]{.retname} [(number)]{.argtype} -- Range 0 to 1\
[metallic]{.retname} [(number)]{.argtype} -- Range 0 to 1\
[emissive]{.retname} [(number)]{.argtype} -- Range 0 to 32\

Return material properties for specific matirial entry.

```lua
function init()
    local type, r, g, b, a, reflectivity, shininess, metallic, emissive = GetShapeMaterial(FindShape("shape2", true), 1)
    DebugPrint(type)
end
```

------------------------------------------------------------------------

[]{#SetBrush}

### SetBrush {#setbrush .function}

``` funcdef
SetBrush(type, size, index, [object])
```

Arguments\
[type]{.argname} [(string)]{.argtype} -- One of \"sphere\", \"cube\" or
\"noise\"\
[size]{.argname} [(number)]{.argtype} -- Size of brush in voxels (must
be in range 1 to 16)\
[index]{.argname} [(or)]{.argtype} -- Material index or path to brush
vox file\
[object]{.argname} [(string, optional)]{.argtype} -- Optional object in
brush vox file if brush vox file is used\

Return value\
[none]{.retname}

Set material index to be used for following calls to DrawShapeLine and
DrawShapeBox and ExtrudeShape. An optional brush vox file and subobject
can be used and provided instead of material index, in which case the
content of the brush will be used and repeated. Use material index zero
to remove of voxels.

```lua
function init()
    SetBrush("sphere", 3, 3)
end
```

------------------------------------------------------------------------

[]{#DrawShapeLine}

### DrawShapeLine {#drawshapeline .function}

``` funcdef
DrawShapeLine(shape, x0, y0, z0, x1, y1, z1, [paint], [noOverwrite])
```

Arguments\
[shape]{.argname} [(number)]{.argtype} -- Handle to shape\
[x0]{.argname} [(number)]{.argtype} -- Start X coordinate\
[y0]{.argname} [(number)]{.argtype} -- Start Y coordinate\
[z0]{.argname} [(number)]{.argtype} -- Start Z coordinate\
[x1]{.argname} [(number)]{.argtype} -- End X coordinate\
[y1]{.argname} [(number)]{.argtype} -- End Y coordinate\
[z1]{.argname} [(number)]{.argtype} -- End Z coordinate\
[paint]{.argname} [(boolean, optional)]{.argtype} -- Paint mode. Default
is false.\
[noOverwrite]{.argname} [(boolean, optional)]{.argtype} -- Only fill in
voxels if space isn\'t already occupied. Default is false.\

Return value\
[none]{.retname}

Draw voxelized line between (x0,y0,z0) and (x1,y1,z1) into shape using
the material set up with SetBrush. Paint mode will only change material
of existing voxels (where the current material index is non-zero).
noOverwrite mode will only fill in voxels if the space isn\'t already
accupied by another shape in the scene.

```lua
function init()
    SetBrush("sphere", 3, 1)
    DrawShapeLine(FindShape("shape"), 0, 0, 0, 10, 50, 5, false, true)
end
```

------------------------------------------------------------------------

[]{#DrawShapeBox}

### DrawShapeBox {#drawshapebox .function}

``` funcdef
DrawShapeBox(shape, x0, y0, z0, x1, y1, z1)
```

Arguments\
[shape]{.argname} [(number)]{.argtype} -- Handle to shape\
[x0]{.argname} [(number)]{.argtype} -- Start X coordinate\
[y0]{.argname} [(number)]{.argtype} -- Start Y coordinate\
[z0]{.argname} [(number)]{.argtype} -- Start Z coordinate\
[x1]{.argname} [(number)]{.argtype} -- End X coordinate\
[y1]{.argname} [(number)]{.argtype} -- End Y coordinate\
[z1]{.argname} [(number)]{.argtype} -- End Z coordinate\

Return value\
[none]{.retname}

Draw box between (x0,y0,z0) and (x1,y1,z1) into shape using the material
set up with SetBrush.

```lua
function init()
    SetBrush("sphere", 3, 4)
    DrawShapeBox(FindShape("shape", true), 0, 0, 0, 10, 50, 5)
end
```

------------------------------------------------------------------------

[]{#ExtrudeShape}

### ExtrudeShape {#extrudeshape .function}

``` funcdef
ExtrudeShape(shape, x, y, z, dx, dy, dz, steps, mode)
```

Arguments\
[shape]{.argname} [(number)]{.argtype} -- Handle to shape\
[x]{.argname} [(number)]{.argtype} -- X coordinate to extrude\
[y]{.argname} [(number)]{.argtype} -- Y coordinate to extrude\
[z]{.argname} [(number)]{.argtype} -- Z coordinate to extrude\
[dx]{.argname} [(number)]{.argtype} -- X component of extrude direction,
should be -1, 0 or 1\
[dy]{.argname} [(number)]{.argtype} -- Y component of extrude direction,
should be -1, 0 or 1\
[dz]{.argname} [(number)]{.argtype} -- Z component of extrude direction,
should be -1, 0 or 1\
[steps]{.argname} [(number)]{.argtype} -- Length of extrusion in voxels\
[mode]{.argname} [(string)]{.argtype} -- Extrusion mode, one of
\"exact\", \"material\", \"geometry\". Default is \"exact\"\

Return value\
[none]{.retname}

Extrude region of shape. The extruded region will be filled in with the
material set up with SetBrush. The mode parameter sepcifies how the
region is determined. Exact mode selects region of voxels that exactly
match the input voxel at input coordinate. Material mode selects region
that has the same material type as the input voxel. Geometry mode
selects any connected voxel in the same plane as the input voxel.

```lua
local shape = 0
function init()
    SetBrush("sphere", 3, 4)
    shape = FindShape("shape")
    ExtrudeShape(shape, 0, 5, 0, -1, 0, 0, 50, "exact")
end
```

------------------------------------------------------------------------

[]{#TrimShape}

### TrimShape {#trimshape .function}

``` funcdef
offset = TrimShape(shape)
```

Arguments\
[shape]{.argname} [(number)]{.argtype} -- Source handle\

Return value\
[offset]{.retname} [(TVec)]{.argtype} -- Offset vector in shape local
space\

Trim away empty regions of shape, thus potentially making it smaller. If
the size of the shape changes, the shape will be automatically moved to
preserve the shape content in body space. The offset vector for this
translation is returned in shape local space.

```lua
local shape = 0
function init()
    shape = FindShape("shape", true)
    TrimShape(shape)
end
```

------------------------------------------------------------------------

[]{#SplitShape}

### SplitShape {#splitshape .function}

``` funcdef
newShapes = SplitShape(shape, removeResidual)
```

Arguments\
[shape]{.argname} [(number)]{.argtype} -- Source handle\
[removeResidual]{.argname} [(boolean)]{.argtype} -- Remove residual
shapes (default false)\

Return value\
[newShapes]{.retname} [(table)]{.argtype} -- List of shape handles
created\

Split up a shape into multiple shapes based on connectivity. If the
removeResidual flag is used, small disconnected chunks will be removed
during this process to reduce the number of newly created shapes.

```lua
local shape = 0
function init()
    shape = FindShape("shape", true)
    SplitShape(shape, true)
end
```

------------------------------------------------------------------------

[]{#MergeShape}

### MergeShape {#mergeshape .function}

``` funcdef
shape = MergeShape(shape)
```

Arguments\
[shape]{.argname} [(number)]{.argtype} -- Input shape\

Return value\
[shape]{.retname} [(number)]{.argtype} -- Shape handle after merge\

Try to merge shape with a nearby, matching shape. For a merge to happen,
the shapes need to be aligned to the same rotation and touching. If the
provided shape was merged into another shape, that shape may be resized
to fit the merged content. If shape was merged, the handle to the other
shape is returned, otherwise the input handle is returned.

```lua
local shape = 0
function init()
    shape = FindShape("shape", true)
    DebugPrint(shape)
    shape = MergeShape(shape)
    DebugPrint(shape)
end
```

------------------------------------------------------------------------

[]{#IsShapeDisconnected}

### IsShapeDisconnected {#isshapedisconnected .function}

``` funcdef
disconnected = IsShapeDisconnected(shape)
```

Arguments\
[shape]{.argname} [(number)]{.argtype} -- Input shape\

Return value\
[disconnected]{.retname} [(boolean)]{.argtype} -- True if shape
disconnected (has detached parts)\

```lua
function tick()
    DebugWatch("IsShapeDisconnected", IsShapeDisconnected(FindShape("shape", true)))
end
```

------------------------------------------------------------------------

[]{#IsStaticShapeDetached}

### IsStaticShapeDetached {#isstaticshapedetached .function}

``` funcdef
disconnected = IsStaticShapeDetached(shape)
```

Arguments\
[shape]{.argname} [(number)]{.argtype} -- Input shape\

Return value\
[disconnected]{.retname} [(boolean)]{.argtype} -- True if static shape
has detached parts\

```lua
function tick()
    DebugWatch("IsStaticShapeDetached", IsStaticShapeDetached(FindShape("shape_glass", true)))
end
```

------------------------------------------------------------------------

[]{#GetShapeClosestPoint}

### GetShapeClosestPoint {#getshapeclosestpoint .function}

``` funcdef
hit, point, normal = GetShapeClosestPoint(shape, origin)
```

Arguments\
[shape]{.argname} [(number)]{.argtype} -- Shape handle\
[origin]{.argname} [(TVec)]{.argtype} -- World space point\

Return value\
[hit]{.retname} [(boolean)]{.argtype} -- True if a point was found\
[point]{.retname} [(TVec)]{.argtype} -- World space closest point\
[normal]{.retname} [(TVec)]{.argtype} -- World space normal at closest
point\

This will return the closest point of a specific shape

```lua
local shape = 0
function init()
    shape = FindShape("shape", true)
end

function tick()
    DebugCross(Vec(1, 0, 0))
    local hit, p, n, s = GetShapeClosestPoint(shape, Vec(1, 0, 0))
    if hit then
        DebugCross(p)
    end
end
```

------------------------------------------------------------------------

[]{#IsShapeTouching}

### IsShapeTouching {#isshapetouching .function}

``` funcdef
touching = IsShapeTouching(a, b)
```

Arguments\
[a]{.argname} [(number)]{.argtype} -- Handle to first shape\
[b]{.argname} [(number)]{.argtype} -- Handle to second shape\

Return value\
[touching]{.retname} [(boolean)]{.argtype} -- True is shapes a and b are
touching each other\

This will check if two shapes has physical overlap

```lua
local shapeA = 0
local shapeB = 0
function init()
    shapeA = FindShape("shape")
    shapeB = FindShape("shape2")
end

function tick()
    DebugPrint(IsShapeTouching(shapeA, shapeB))
end
```

------------------------------------------------------------------------

[]{#FindLocation}

### FindLocation {#findlocation .function}

``` funcdef
handle = FindLocation([tag], [global])
```

Arguments\
[tag]{.argname} [(string, optional)]{.argtype} -- Tag name\
[global]{.argname} [(boolean, optional)]{.argtype} -- Search in entire
scene\

Return value\
[handle]{.retname} [(number)]{.argtype} -- Handle to first location with
specified tag or zero if not found\

```lua
local loc = 0
function init()
    loc = FindLocation("loc1")
end

function tick()
    DebugCross(GetLocationTransform(loc).pos)
end
```

------------------------------------------------------------------------

[]{#FindLocations}

### FindLocations {#findlocations .function}

``` funcdef
list = FindLocations([tag], [global])
```

Arguments\
[tag]{.argname} [(string, optional)]{.argtype} -- Tag name\
[global]{.argname} [(boolean, optional)]{.argtype} -- Search in entire
scene\

Return value\
[list]{.retname} [(table)]{.argtype} -- Indexed table with handles to
all locations with specified tag\

```lua
local locations
function init()
    locations = FindLocations("loc1")

    for i=1, #locations do
        local loc = locations[i]
        DebugPrint(DebugPrint(loc))
    end
end
```

------------------------------------------------------------------------

[]{#GetLocationTransform}

### GetLocationTransform {#getlocationtransform .function}

``` funcdef
transform = GetLocationTransform(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Location handle\

Return value\
[transform]{.retname} [(TTransform)]{.argtype} -- Transform of the
location\

```lua
local location = 0
function init()
    location = FindLocation("loc1")
    DebugPrint(VecStr(GetLocationTransform(location).pos))
end
```

------------------------------------------------------------------------

[]{#FindJoint}

### FindJoint {#findjoint .function}

``` funcdef
handle = FindJoint([tag], [global])
```

Arguments\
[tag]{.argname} [(string, optional)]{.argtype} -- Tag name\
[global]{.argname} [(boolean, optional)]{.argtype} -- Search in entire
scene\

Return value\
[handle]{.retname} [(number)]{.argtype} -- Handle to first joint with
specified tag or zero if not found\

```lua
function init()
    local joint = FindJoint("doorhinge")
    DebugPrint(joint)
end
```

------------------------------------------------------------------------

[]{#FindJoints}

### FindJoints {#findjoints .function}

``` funcdef
list = FindJoints([tag], [global])
```

Arguments\
[tag]{.argname} [(string, optional)]{.argtype} -- Tag name\
[global]{.argname} [(boolean, optional)]{.argtype} -- Search in entire
scene\

Return value\
[list]{.retname} [(table)]{.argtype} -- Indexed table with handles to
all joints with specified tag\

```lua
--Search for locations tagged "doorhinge" in script scope
function init()
    local hinges = FindJoints("doorhinge")
    for i=1, #hinges do
        local joint = hinges[i]
        DebugPrint(joint)
    end
end
```

------------------------------------------------------------------------

[]{#IsJointBroken}

### IsJointBroken {#isjointbroken .function}

``` funcdef
broken = IsJointBroken(joint)
```

Arguments\
[joint]{.argname} [(number)]{.argtype} -- Joint handle\

Return value\
[broken]{.retname} [(boolean)]{.argtype} -- True if joint is broken\

```lua
function init()
    local broken = IsJointBroken(FindJoint("joint"))
    DebugPrint(broken)
end
```

------------------------------------------------------------------------

[]{#GetJointType}

### GetJointType {#getjointtype .function}

``` funcdef
type = GetJointType(joint)
```

Arguments\
[joint]{.argname} [(number)]{.argtype} -- Joint handle\

Return value\
[type]{.retname} [(string)]{.argtype} -- Joint type\

Joint type is one of the following: \"ball\", \"hinge\", \"prismatic\"
or \"rope\". An empty string is returned if joint handle is invalid.

```lua
function init()
    local joint = FindJoint("joint")
    if GetJointType(joint) == "rope" then
        DebugPrint("Joint is rope")
    end
end
```

------------------------------------------------------------------------

[]{#GetJointOtherShape}

### GetJointOtherShape {#getjointothershape .function}

``` funcdef
other = GetJointOtherShape(joint, shape)
```

Arguments\
[joint]{.argname} [(number)]{.argtype} -- Joint handle\
[shape]{.argname} [(number)]{.argtype} -- Shape handle\

Return value\
[other]{.retname} [(number)]{.argtype} -- Other shape handle\

A joint is always connected to two shapes. Use this function if you know
one shape and want to find the other one.

```lua
function init()
    local joint = FindJoint("joint")
    --joint is connected to A and B

    otherShape = GetJointOtherShape(joint, FindShape("shapeA"))
    --otherShape is now B

    otherShape = GetJointOtherShape(joint, FindShape("shapeB"))
    --otherShape is now A
end
```

------------------------------------------------------------------------

[]{#GetJointShapes}

### GetJointShapes {#getjointshapes .function}

``` funcdef
shapes = GetJointShapes(joint)
```

Arguments\
[joint]{.argname} [(number)]{.argtype} -- Joint handle\

Return value\
[shapes]{.retname} [(number)]{.argtype} -- Shape handles\

Get shapes connected to the joint.

```lua
local mainBody
local shapes
local joint
function init()
    joint = FindJoint("joint")
    mainBody = GetVehicleBody(FindVehicle("vehicle"))
    shapes = GetJointShapes(joint)
end

function tick()
    -- Check to see if joint chain is still connected to vehicle main body
    -- If not then disable motors

    local connected = false
    for i=1,#shapes do
    
        local body = GetShapeBody(shapes[i])
    
        if body == mainBody then
            connected = true
        end
    
    end
    
    if connected then
        SetJointMotor(joint, 0.5)
    else
        SetJointMotor(joint, 0.0)
    end
end
```

------------------------------------------------------------------------

[]{#SetJointMotor}

### SetJointMotor {#setjointmotor .function}

``` funcdef
SetJointMotor(joint, velocity, [strength])
```

Arguments\
[joint]{.argname} [(number)]{.argtype} -- Joint handle\
[velocity]{.argname} [(number)]{.argtype} -- Desired velocity\
[strength]{.argname} [(number, optional)]{.argtype} -- Desired strength.
Default is infinite. Zero to disable.\

Return value\
[none]{.retname}

Set joint motor target velocity. If joint is of type hinge, velocity is
given in radians per second angular velocity. If joint type is prismatic
joint velocity is given in meters per second. Calling this function will
override and void any previous call to SetJointMotorTarget.

```lua
function init()
    --Set motor speed to 0.5 radians per second
    SetJointMotor(FindJoint("hinge"), 0.5)
end
```

------------------------------------------------------------------------

[]{#SetJointMotorTarget}

### SetJointMotorTarget {#setjointmotortarget .function}

``` funcdef
SetJointMotorTarget(joint, target, [maxVel], [strength])
```

Arguments\
[joint]{.argname} [(number)]{.argtype} -- Joint handle\
[target]{.argname} [(number)]{.argtype} -- Desired movement target\
[maxVel]{.argname} [(number, optional)]{.argtype} -- Maximum velocity to
reach target. Default is infinite.\
[strength]{.argname} [(number, optional)]{.argtype} -- Desired strength.
Default is infinite. Zero to disable.\

Return value\
[none]{.retname}

If a joint has a motor target, it will try to maintain its relative
movement. This is very useful for elevators or other animated, jointed
mechanisms. If joint is of type hinge, target is an angle in degrees
(-180 to 180) and velocity is given in radians per second. If joint type
is prismatic, target is given in meters and velocity is given in meters
per second. Setting a motor target will override any previous call to
SetJointMotor.

```lua
function init()
    --Make joint reach a 45 degree angle, going at a maximum of 3 radians per second
    SetJointMotorTarget(FindJoint("hinge"), 45, 3)
end
```

------------------------------------------------------------------------

[]{#GetJointLimits}

### GetJointLimits {#getjointlimits .function}

``` funcdef
min, max = GetJointLimits(joint)
```

Arguments\
[joint]{.argname} [(number)]{.argtype} -- Joint handle\

Return value\
[min]{.retname} [(number)]{.argtype} -- Minimum joint limit (angle or
distance)\
[max]{.retname} [(number)]{.argtype} -- Maximum joint limit (angle or
distance)\

Return joint limits for hinge or prismatic joint. Returns angle or
distance depending on joint type.

```lua
function init()
    local min, max = GetJointLimits(FindJoint("hinge"))
    DebugPrint(min .. "-" .. max)
end
```

------------------------------------------------------------------------

[]{#GetJointMovement}

### GetJointMovement {#getjointmovement .function}

``` funcdef
movement = GetJointMovement(joint)
```

Arguments\
[joint]{.argname} [(number)]{.argtype} -- Joint handle\

Return value\
[movement]{.retname} [(number)]{.argtype} -- Current joint position or
angle\

Return the current position or angle or the joint, measured in same way
as joint limits.

```lua
function init()
    local current = GetJointMovement(FindJoint("hinge"))
    DebugPrint(current)
end
```

------------------------------------------------------------------------

[]{#GetJointedBodies}

### GetJointedBodies {#getjointedbodies .function}

``` funcdef
bodies = GetJointedBodies(body)
```

Arguments\
[body]{.argname} [(number)]{.argtype} -- Body handle (must be dynamic)\

Return value\
[bodies]{.retname} [(table)]{.argtype} -- Handles to all dynamic bodies
in the jointed structure. The input handle will also be included.\

```lua
local body = 0
function init()
    body = FindBody("body")
end

function tick()
    --Draw outline for all bodies in jointed structure
    local all = GetJointedBodies(body)
    for i=1,#all do
        DrawBodyOutline(all[i], 0.5)
    end
end
```

------------------------------------------------------------------------

[]{#DetachJointFromShape}

### DetachJointFromShape {#detachjointfromshape .function}

``` funcdef
DetachJointFromShape(joint, shape)
```

Arguments\
[joint]{.argname} [(number)]{.argtype} -- Joint handle\
[shape]{.argname} [(number)]{.argtype} -- Shape handle\

Return value\
[none]{.retname}

Detach joint from shape. If joint is not connected to shape, nothing
happens.

```lua
function init()
    DetachJointFromShape(FindJoint("joint"), FindShape("door"))
end
```

------------------------------------------------------------------------

[]{#GetRopeNumberOfPoints}

### GetRopeNumberOfPoints {#getropenumberofpoints .function}

``` funcdef
amount = GetRopeNumberOfPoints(joint)
```

Arguments\
[joint]{.argname} [(number)]{.argtype} -- Joint handle\

Return value\
[amount]{.retname} [(number)]{.argtype} -- Number of points in a rope or
zero if invalid\

Returns the number of points in the rope given its handle. Will return
zero if the handle is not a rope

```lua
function init()
    local joint = FindJoint("joint")
    local numberPoints = GetRopeNumberOfPoints(joint)
end
```

------------------------------------------------------------------------

[]{#GetRopePointPosition}

### GetRopePointPosition {#getropepointposition .function}

``` funcdef
pos = GetRopePointPosition(joint, index)
```

Arguments\
[joint]{.argname} [(number)]{.argtype} -- Joint handle\
[index]{.argname} [(number)]{.argtype} -- The point index, starting at
1\

Return value\
[pos]{.retname} [(TVec)]{.argtype} -- World position of the point, or
nil, if invalid\

Returns the world position of the rope\'s point. Will return nil if the
handle is not a rope or the index is not valid

```lua
function init()
    local joint = FindJoint("joint")
    numberPoints = GetRopeNumberOfPoints(joint)

    for pointIndex = 1, numberPoints do
        DebugCross(GetRopePointPosition(joint, pointIndex))
    end
end
```

------------------------------------------------------------------------

[]{#GetRopeBounds}

### GetRopeBounds {#getropebounds .function}

``` funcdef
min, max = GetRopeBounds(joint)
```

Arguments\
[joint]{.argname} [(number)]{.argtype} -- Joint handle\

Return value\
[min]{.retname} [(TVec)]{.argtype} -- Lower point of rope bounds in
world space\
[max]{.retname} [(TVec)]{.argtype} -- Upper point of rope bounds in
world space\

Returns the bounds of the rope. Will return nil if the handle is not a
rope

```lua
function init()
    local joint = FindJoint("joint")
    local mi, ma = GetRopeBounds(joint)

    DebugCross(mi)
    DebugCross(ma)
end
```

------------------------------------------------------------------------

[]{#BreakRope}

### BreakRope {#breakrope .function}

``` funcdef
BreakRope(joint, point)
```

Arguments\
[joint]{.argname} [(number)]{.argtype} -- Rope type joint handle\
[point]{.argname} [(TVec)]{.argtype} -- Point of break as world space
vector\

Return value\
[none]{.retname}

Breaks the rope at the specified point.

```lua
function tick()
    local playerCameraTransform = GetPlayerCameraTransform()
    local dir = TransformToParentVec(playerCameraTransform, Vec(0, 0, -1))

    local hit, dist, joint = QueryRaycastRope(playerCameraTransform.pos, dir, 5)
    if hit then
        local breakPoint = VecAdd(playerCameraTransform.pos, VecScale(dir, dist))
        BreakRope(joint, breakPoint)
    end
end
```

------------------------------------------------------------------------

[]{#SetAnimatorPositionIK}

### SetAnimatorPositionIK {#setanimatorpositionik .function}

``` funcdef
SetAnimatorPositionIK(handle, begname, endname, target, [weight], [history], [flag])
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\
[begname]{.argname} [(string)]{.argtype} -- Name of the start-bone of
the chain\
[endname]{.argname} [(string)]{.argtype} -- Name of the end-bone of the
chain\
[target]{.argname} [(TVec)]{.argtype} -- World target position that the
\"endname\" bone should reach\
[weight]{.argname} [(number, optional)]{.argtype} -- Weight \[0,1\] of
this animation, default is 1.0\
[history]{.argname} [(number, optional)]{.argtype} -- How much of the
previous frames result \[0,1\] that should be used when start the IK
search, default is 0.0\
[flag]{.argname} [(boolean, optional)]{.argtype} -- TRUE if constraints
should be used, default is TRUE\

Return value\
[none]{.retname}

```lua
SetAnimatorPositionIK(animator, "shoulder_l", "hand_l", Vec(10, 0, 0), 1.0, 0.9, true)
```

------------------------------------------------------------------------

[]{#SetAnimatorTransformIK}

### SetAnimatorTransformIK {#setanimatortransformik .function}

``` funcdef
SetAnimatorTransformIK(handle, begname, endname, transform, [weight], [history], [locktarget], [useconstraints])
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\
[begname]{.argname} [(string)]{.argtype} -- Name of the start-bone of
the chain\
[endname]{.argname} [(string)]{.argtype} -- Name of the end-bone of the
chain\
[transform]{.argname} [(TTransform)]{.argtype} -- World target transform
that the \"endname\" bone should reach\
[weight]{.argname} [(number, optional)]{.argtype} -- Weight \[0,1\] of
this animation, default is 1.0\
[history]{.argname} [(number, optional)]{.argtype} -- How much of the
previous frames result \[0,1\] that should be used when start the IK
search, default is 0.0\
[locktarget]{.argname} [(boolean, optional)]{.argtype} -- TRUE if the
end-bone should be fixed to the target-transform, FALSE if IK solution
is used\
[useconstraints]{.argname} [(boolean, optional)]{.argtype} -- TRUE if
constraints should be used, default is TRUE\

Return value\
[none]{.retname}

```lua
SetAnimatorTransformIK(animator, "shoulder_l", "hand_l", Transform(10, 0, 0), 1.0, 0.9, false, true)
```

------------------------------------------------------------------------

[]{#GetBoneChainLength}

### GetBoneChainLength {#getbonechainlength .function}

``` funcdef
length = GetBoneChainLength(handle, begname, endname)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\
[begname]{.argname} [(string)]{.argtype} -- Name of the start-bone of
the chain\
[endname]{.argname} [(string)]{.argtype} -- Name of the end-bone of the
chain\

Return value\
[length]{.retname} [(number)]{.argtype} -- Length of the bone chain
between \"start-bone\" and \"end-bone\"\

This will calculate the length of the bone-chain between the endpoints.
If the skeleton have a chain like this (shoulder_l -\> upper_arm_l -\>
lower_arm_l -\> hand_l) it will return the length of the
upper_arm_l+lower_arm_l

```lua
local length = GetBoneChainLength(animator, "shoulder_l", "hand_l")
```

------------------------------------------------------------------------

[]{#FindAnimator}

### FindAnimator {#findanimator .function}

``` funcdef
handle = FindAnimator([tag], [global])
```

Arguments\
[tag]{.argname} [(string, optional)]{.argtype} -- Tag name\
[global]{.argname} [(boolean, optional)]{.argtype} -- Search in entire
scene\

Return value\
[handle]{.retname} [(number)]{.argtype} -- Handle to first animator with
specified tag or zero if not found\

```lua
--Search for the first animator in script scope
local animator = FindAnimator()

--Search for an animator tagged "anim" in script scope
local animator = FindAnimator("anim")

--Search for an animator tagged "anim2" in entire scene
local anim2 = FindAnimator("anim2", true)
```

------------------------------------------------------------------------

[]{#FindAnimators}

### FindAnimators {#findanimators .function}

``` funcdef
list = FindAnimators([tag], [global])
```

Arguments\
[tag]{.argname} [(string, optional)]{.argtype} -- Tag name\
[global]{.argname} [(boolean, optional)]{.argtype} -- Search in entire
scene\

Return value\
[list]{.retname} [(table)]{.argtype} -- Indexed table with handles to
all animators with specified tag\

```lua
--Search for animators tagged "target" in script scope
local targets = FindAnimators("target")
for i=1, #targets do
    local target = targets[i]
    ...
end
```

------------------------------------------------------------------------

[]{#GetAnimatorTransform}

### GetAnimatorTransform {#getanimatortransform .function}

``` funcdef
transform = GetAnimatorTransform(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\

Return value\
[transform]{.retname} [(TTransform)]{.argtype} -- World space transform
of the animator\

```lua
local pos = GetAnimatorTransform(animator).pos
```

------------------------------------------------------------------------

[]{#GetAnimatorAdjustTransformIK}

### GetAnimatorAdjustTransformIK {#getanimatoradjusttransformik .function}

``` funcdef
transform = GetAnimatorAdjustTransformIK(handle, name)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\
[name]{.argname} [(string)]{.argtype} -- Name of the location node\

Return value\
[transform]{.retname} [(TTransform)]{.argtype} -- World space transform
of the animator\

When using IK for a character you can use ik-helpers to define where the

```lua
--This will adjust the target transform so that the grip defined by a location node in editor called "ik_hand_l" will reach the target
local target = Transform(Vec(10, 0, 0), QuatEuler(0, 90, 0))
local adj = GetAnimatorAdjustTransformIK(animator, "ik_hand_l")
if adj ~= nil then
    target = TransformToParentTransform(target, adj)
end
SetAnimatorTransformIK(animator, "shoulder_l", "hand_l", target, 1.0, 0.9)
```

------------------------------------------------------------------------

[]{#SetAnimatorTransform}

### SetAnimatorTransform {#setanimatortransform .function}

``` funcdef
SetAnimatorTransform(handle, transform)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\
[transform]{.argname} [(TTransform)]{.argtype} -- Desired transform\

Return value\
[none]{.retname}

```lua
local t = Transform(Vec(10, 0, 0), QuatEuler(0, 90, 0))
SetAnimatorTransform(animator, t)
```

------------------------------------------------------------------------

[]{#MakeRagdoll}

### MakeRagdoll {#makeragdoll .function}

``` funcdef
MakeRagdoll(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\

Return value\
[none]{.retname}

Make all prefab bodies physical and leave control to physics system

```lua
MakeRagdoll(animator)
```

------------------------------------------------------------------------

[]{#UnRagdoll}

### UnRagdoll {#unragdoll .function}

``` funcdef
UnRagdoll(handle, [time])
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\
[time]{.argname} [(number, optional)]{.argtype} -- Transition time\

Return value\
[none]{.retname}

Take control if the prefab bodies and do an optional blend between the
current ragdoll state and current animation state

```lua
--Take control of bodies and do a blend during one sec between the animation state and last physics state
UnRagdoll(animator, 1.0)
```

------------------------------------------------------------------------

[]{#PlayAnimation}

### PlayAnimation {#playanimation .function}

``` funcdef
handle = PlayAnimation(handle, name, [weight], [filter])
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\
[name]{.argname} [(string)]{.argtype} -- Animation name\
[weight]{.argname} [(number, optional)]{.argtype} -- Weight \[0,1\] of
this animation, default is 1.0\
[filter]{.argname} [(string, optional)]{.argtype} -- Name of the bone
and its subtree that will be affected\

Return value\
[handle]{.retname} [(number)]{.argtype} -- Handle to the instance that
can be used with PlayAnimationInstance, zero if clip reached its end\

Single animations, one-shot, will be processed after looping animations.

```lua
--This will play a single animation "Shooting" with a 80% influence but only on the skeleton starting at bone "Spine"
PlayAnimation(animator, "Shooting", 0.8, "Spine")
```

------------------------------------------------------------------------

[]{#PlayAnimationLoop}

### PlayAnimationLoop {#playanimationloop .function}

``` funcdef
PlayAnimationLoop(handle, name, [weight], [filter])
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\
[name]{.argname} [(string)]{.argtype} -- Animation name\
[weight]{.argname} [(number, optional)]{.argtype} -- Weight \[0,1\] of
this animation, default is 1.0\
[filter]{.argname} [(string, optional)]{.argtype} -- Name of the bone
and its subtree that will be affected\

Return value\
[none]{.retname}

```lua
--This will play an animation loop "Walking" with a 100% influence on the whole skeleton
PlayAnimationLoop(animator, "Walking")
```

------------------------------------------------------------------------

[]{#PlayAnimationInstance}

### PlayAnimationInstance {#playanimationinstance .function}

``` funcdef
handle = PlayAnimationInstance(handle, instance, [weight], [speed])
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\
[instance]{.argname} [(number)]{.argtype} -- Instance handle\
[weight]{.argname} [(number, optional)]{.argtype} -- Weight \[0,1\] of
this animation, default is 1.0\
[speed]{.argname} [(number, optional)]{.argtype} -- Weight \[0,1\] of
this animation, default is 1.0\

Return value\
[handle]{.retname} [(number)]{.argtype} -- Handle to the instance that
can be used with PlayAnimationInstance, zero if clip reached its end\

Single animations, one-shot, will be processed after looping animations.

```lua
--This will play a single animation "Shooting" with a 80% influence but only on the skeleton starting at bone "Spine"
PlayAnimation(animator, "Shooting", 0.8, "Spine")
```

------------------------------------------------------------------------

[]{#StopAnimationInstance}

### StopAnimationInstance {#stopanimationinstance .function}

``` funcdef
StopAnimationInstance(handle, instance)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\
[instance]{.argname} [(number)]{.argtype} -- Instance handle\

Return value\
[none]{.retname}

This will stop the playing anim-instance

------------------------------------------------------------------------

[]{#PlayAnimationFrame}

### PlayAnimationFrame {#playanimationframe .function}

``` funcdef
PlayAnimationFrame(handle, name, time, [weight], [filter])
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\
[name]{.argname} [()]{.argtype} -- Animation name\
[time]{.argname} [()]{.argtype} -- Time in the animation\
[weight]{.argname} [(number, optional)]{.argtype} -- Weight \[0,1\] of
this animation, default is 1.0\
[filter]{.argname} [(string, optional)]{.argtype} -- Name of the bone
and its subtree that will be affected\

Return value\
[none]{.retname}

```lua
--This will play an animation "Walking" at a specific time of 1.5s with a 80% influence on the whole skeleton
PlayAnimationFrame(animator, "Walking", 1.5, 0.8)
```

------------------------------------------------------------------------

[]{#BeginAnimationGroup}

### BeginAnimationGroup {#beginanimationgroup .function}

``` funcdef
BeginAnimationGroup(handle, [weight], [filter])
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\
[weight]{.argname} [(number, optional)]{.argtype} -- Weight \[0,1\] of
this group, default is 1.0\
[filter]{.argname} [(string, optional)]{.argtype} -- Name of the bone
and its subtree that will be affected\

Return value\
[none]{.retname}

You can group looping animations together and use the result of those to
blend to target. PlayAnimation will not work here since they are
processed last separately from blendgroups.

```lua
--This will blend an entire group with 50% influence
BeginAnimationGroup(animator, 0.5)
    PlayAnimationLoop(...)
    PlayAnimationLoop(...)
EndAnimationGroup(animator)

--You can also create a tree of groups, blending is performed in a depth-first order
BeginAnimationGroup(animator, 0.5)
    PlayAnimationLoop(animator, "anim_a", 1.0)
    PlayAnimationLoop(animator, "anim_b", 0.2)
    BeginAnimationGroup(animator, 0.75)
        PlayAnimationLoop(animator, "anim_c", 1.0)
        PlayAnimationLoop(animator, "anim_d", 0.25)
    EndAnimationGroup(animator)
EndAnimationGroup(animator)
```

------------------------------------------------------------------------

[]{#EndAnimationGroup}

### EndAnimationGroup {#endanimationgroup .function}

``` funcdef
EndAnimationGroup(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\

Return value\
[none]{.retname}

Ends the group created by BeginAnimationGroup

------------------------------------------------------------------------

[]{#PlayAnimationInstances}

### PlayAnimationInstances {#playanimationinstances .function}

``` funcdef
PlayAnimationInstances(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\

Return value\
[none]{.retname}

Single animations, one-shot, will be processed after looping animations.
By calling PlayAnimationInstances you can force it to be processed
earlier and be able to \"overwrite\" the result of it if you want

```lua
--First we play a single jump animation affecting the whole skeleton
--Then we play an aiming animation on the upper-body, filter="Spine1", keeping the lower-body unaffected
--Then we force the single-animations to be processed, this will force the "jump" to be processed.
--Then we overwrite just the spine-bone with a mouse controlled rotation("rot")
--Result will be a jump animation with the upperbody playing an aiming animation but the pitch of the spine controlled by the mouse("rot")

if InputPressed("jump") then
    PlayAnimation(animator, "Jump")
end
PlayAnimationLoop(animator, "Pistol Idle", aimWeight, "Spine1")
PlayAnimationInstances(animator)
SetBoneRotation(animator, "Spine1", rot, 1)
```

------------------------------------------------------------------------

[]{#GetAnimationClipNames}

### GetAnimationClipNames {#getanimationclipnames .function}

``` funcdef
list = GetAnimationClipNames(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\

Return value\
[list]{.retname} [(table)]{.argtype} -- Indexed table with animation
names\

```lua
local list = GetAnimationClipNames(animator)
for i=1, #list do
    local name = list[i]
    ..
end
```

------------------------------------------------------------------------

[]{#GetAnimationClipDuration}

### GetAnimationClipDuration {#getanimationclipduration .function}

``` funcdef
time = GetAnimationClipDuration(handle, name)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\
[name]{.argname} [()]{.argtype} -- Animation name\

Return value\
[time]{.retname} [()]{.argtype} -- Total duration of the animation\

------------------------------------------------------------------------

[]{#SetAnimationClipFade}

### SetAnimationClipFade {#setanimationclipfade .function}

``` funcdef
SetAnimationClipFade(handle, name, fadein, fadeout)
```

Arguments\
[handle]{.argname} [()]{.argtype} -- Animator handle\
[name]{.argname} [()]{.argtype} -- Animation name\
[fadein]{.argname} [()]{.argtype} -- Fadein time of the animation\
[fadeout]{.argname} [(number)]{.argtype} -- Fadeout time of the
animation\

Return value\
[none]{.retname}

```lua
SetAnimationClipFade(animator, "fire", 0.5, 0.5)
```

------------------------------------------------------------------------

[]{#SetAnimationClipSpeed}

### SetAnimationClipSpeed {#setanimationclipspeed .function}

``` funcdef
SetAnimationClipSpeed(handle, name, speed)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\
[name]{.argname} [()]{.argtype} -- Animation name\
[speed]{.argname} [()]{.argtype} -- Sets the speed factor of the
animation\

Return value\
[none]{.retname}

```lua
--This will make the clip run 2x as normal speed
SetAnimationClipSpeed(animator, "walking", 2)
```

------------------------------------------------------------------------

[]{#TrimAnimationClip}

### TrimAnimationClip {#trimanimationclip .function}

``` funcdef
TrimAnimationClip(handle, name, begoffset, [endoffset])
```

Arguments\
[handle]{.argname} [()]{.argtype} -- Animator handle\
[name]{.argname} [()]{.argtype} -- Animation name\
[begoffset]{.argname} [(number)]{.argtype} -- Time offset from the
beginning of the animation\
[endoffset]{.argname} [(number, optional)]{.argtype} -- Time offset,
positive value means from the beginning and negative value means from
the end, zero(default) means at end\

Return value\
[none]{.retname}

```lua
--This will "remove" 1s from the beginning and 2s from the end.
TrimAnimationClip(animator, "walking", 1, -2)
```

------------------------------------------------------------------------

[]{#GetAnimationClipLoopPosition}

### GetAnimationClipLoopPosition {#getanimationcliploopposition .function}

``` funcdef
time = GetAnimationClipLoopPosition(handle, name)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\
[name]{.argname} [()]{.argtype} -- Animation name\

Return value\
[time]{.retname} [()]{.argtype} -- Time of the current playposition in
the animation\

------------------------------------------------------------------------

[]{#GetAnimationInstancePosition}

### GetAnimationInstancePosition {#getanimationinstanceposition .function}

``` funcdef
time = GetAnimationInstancePosition(handle, instance)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\
[instance]{.argname} [(number)]{.argtype} -- Instance handle\

Return value\
[time]{.retname} [()]{.argtype} -- Time of the current playposition in
the animation\

------------------------------------------------------------------------

[]{#SetAnimationClipLoopPosition}

### SetAnimationClipLoopPosition {#setanimationcliploopposition .function}

``` funcdef
SetAnimationClipLoopPosition(handle, name, time)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\
[name]{.argname} [()]{.argtype} -- Animation name\
[time]{.argname} [()]{.argtype} -- Time in the animation\

Return value\
[none]{.retname}

```lua
--This will set the current playposition to one second
SetAnimationClipLoopPosition(animator, "walking", 1)
```

------------------------------------------------------------------------

[]{#SetBoneRotation}

### SetBoneRotation {#setbonerotation .function}

``` funcdef
SetBoneRotation(handle, name, quat, [weight])
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\
[name]{.argname} [()]{.argtype} -- Bone name\
[quat]{.argname} [()]{.argtype} -- Orientation of the bone\
[weight]{.argname} [(number, optional)]{.argtype} -- Weight \[0,1\]
default is 1.0\

Return value\
[none]{.retname}

```lua
--This will set the existing rotation by QuatEuler(...)
SetBoneRotation(animator, "spine", QuatEuler(0, 180, 0), 1.0)
```

------------------------------------------------------------------------

[]{#SetBoneLookAt}

### SetBoneLookAt {#setbonelookat .function}

``` funcdef
SetBoneLookAt(handle, name, point, [weight])
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\
[name]{.argname} [()]{.argtype} -- Bone name\
[point]{.argname} [()]{.argtype} -- World space point as vector\
[weight]{.argname} [(number, optional)]{.argtype} -- Weight \[0,1\]
default is 1.0\

Return value\
[none]{.retname}

```lua
--This will set the existing local-rotation to point to world space point
SetBoneLookAt(animator, "upper_arm_l", Vec(10, 20, 30), 1.0)
```

------------------------------------------------------------------------

[]{#RotateBone}

### RotateBone {#rotatebone .function}

``` funcdef
RotateBone(handle, name, quat, [weight])
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\
[name]{.argname} [()]{.argtype} -- Bone name\
[quat]{.argname} [()]{.argtype} -- Additive orientation\
[weight]{.argname} [(number, optional)]{.argtype} -- Weight \[0,1\]
default is 1.0\

Return value\
[none]{.retname}

```lua
--This will offset the existing rotation by QuatEuler(...)
RotateBone(animator, "spine", QuatEuler(0, 5, 0), 1.0)
```

------------------------------------------------------------------------

[]{#GetBoneNames}

### GetBoneNames {#getbonenames .function}

``` funcdef
list = GetBoneNames(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\

Return value\
[list]{.retname} [(table)]{.argtype} -- Indexed table with bone-names\

```lua
local list = GetBoneNames(animator)
for i=1, #list do
    local name = list[i]
    ..
end
```

------------------------------------------------------------------------

[]{#GetBoneBody}

### GetBoneBody {#getbonebody .function}

``` funcdef
handle = GetBoneBody(handle, name)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\
[name]{.argname} [(string)]{.argtype} -- Bone name\

Return value\
[handle]{.retname} [(number)]{.argtype} -- Handle to the bone\'s body,
or zero if no bone is present.\

```lua
local body = GetBoneBody(animator, "head")
end
```

------------------------------------------------------------------------

[]{#GetBoneWorldTransform}

### GetBoneWorldTransform {#getboneworldtransform .function}

``` funcdef
transform = GetBoneWorldTransform(handle, name)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\
[name]{.argname} [(string)]{.argtype} -- Bone name\

Return value\
[transform]{.retname} [(TTransform)]{.argtype} -- World space transform
of the bone\

```lua
    local animator = GetPlayerAnimator()
    local bones = GetBoneNames(animator)
    for i=1, #bones do
        local bone = bones[i]
        local t = GetBoneWorldTransform(animator,bone)
        DebugCross(t.pos)
    end
```

------------------------------------------------------------------------

[]{#GetBoneBindPoseTransform}

### GetBoneBindPoseTransform {#getbonebindposetransform .function}

``` funcdef
transform = GetBoneBindPoseTransform(handle, name)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\
[name]{.argname} [(string)]{.argtype} -- Bone name\

Return value\
[transform]{.retname} [(TTransform)]{.argtype} -- Local space transform
of the bone in bindpose\

```lua
local lt = getBindPoseTransform(animator, "lefthand")
```

------------------------------------------------------------------------

[]{#FindLight}

### FindLight {#findlight .function}

``` funcdef
handle = FindLight([tag], [global])
```

Arguments\
[tag]{.argname} [(string, optional)]{.argtype} -- Tag name\
[global]{.argname} [(boolean, optional)]{.argtype} -- Search in entire
scene\

Return value\
[handle]{.retname} [(number)]{.argtype} -- Handle to first light with
specified tag or zero if not found\

```lua
function init()
    local light = FindLight("main")
    DebugPrint(light)
end
```

------------------------------------------------------------------------

[]{#FindLights}

### FindLights {#findlights .function}

``` funcdef
list = FindLights([tag], [global])
```

Arguments\
[tag]{.argname} [(string, optional)]{.argtype} -- Tag name\
[global]{.argname} [(boolean, optional)]{.argtype} -- Search in entire
scene\

Return value\
[list]{.retname} [(table)]{.argtype} -- Indexed table with handles to
all lights with specified tag\

```lua
function init()
    --Search for lights tagged "main" in script scope
    local lights = FindLights("main")
    for i=1, #lights do
        local light = lights[i]
        DebugPrint(light)
    end
end
```

------------------------------------------------------------------------

[]{#SetLightEnabled}

### SetLightEnabled {#setlightenabled .function}

``` funcdef
SetLightEnabled(handle, enabled)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Light handle\
[enabled]{.argname} [(boolean)]{.argtype} -- Set to true if light should
be enabled\

Return value\
[none]{.retname}

If light is owned by a shape, the emissive scale of that shape will be
set to 0.0 when light is disabled and 1.0 when light is enabled.

```lua
function init()
    SetLightEnabled(FindLight("main"), false)
end
```

------------------------------------------------------------------------

[]{#SetLightColor}

### SetLightColor {#setlightcolor .function}

``` funcdef
SetLightColor(handle, r, g, b)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Light handle\
[r]{.argname} [(number)]{.argtype} -- Red value\
[g]{.argname} [(number)]{.argtype} -- Green value\
[b]{.argname} [(number)]{.argtype} -- Blue value\

Return value\
[none]{.retname}

This will only set the color tint of the light. Use SetLightIntensity
for brightness. Setting the light color will not affect the emissive
color of a parent shape.

```lua
function init()
    --Set light color to yellow
    SetLightColor(FindLight("main"), 1, 1, 0)
end
```

------------------------------------------------------------------------

[]{#SetLightIntensity}

### SetLightIntensity {#setlightintensity .function}

``` funcdef
SetLightIntensity(handle, intensity)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Light handle\
[intensity]{.argname} [(number)]{.argtype} -- Desired intensity of the
light\

Return value\
[none]{.retname}

If the shape is owned by a shape you most likely want to use
SetShapeEmissiveScale instead, which will affect both the emissiveness
of the shape and the brightness of the light at the same time.

```lua
function init()
    --Pulsate light
    SetLightIntensity(FindLight("main"), math.sin(GetTime())*0.5 + 1.0)
end
```

------------------------------------------------------------------------

[]{#GetLightTransform}

### GetLightTransform {#getlighttransform .function}

``` funcdef
transform = GetLightTransform(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Light handle\

Return value\
[transform]{.retname} [(TTransform)]{.argtype} -- World space light
transform\

Lights that are owned by a dynamic shape are automatcially moved with
that shape

```lua
local light = 0
function init()
    light = FindLight("main")
    local t = GetLightTransform(light)
    DebugPrint(VecStr(t.pos))
end
```

------------------------------------------------------------------------

[]{#GetLightShape}

### GetLightShape {#getlightshape .function}

``` funcdef
handle = GetLightShape(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Light handle\

Return value\
[handle]{.retname} [(number)]{.argtype} -- Shape handle or zero if not
attached to shape\

```lua
local light = 0
function init()
    light = FindLight("main")
    local shape = GetLightShape(light)
    DebugPrint(shape)
end
```

------------------------------------------------------------------------

[]{#IsLightActive}

### IsLightActive {#islightactive .function}

``` funcdef
active = IsLightActive(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Light handle\

Return value\
[active]{.retname} [(boolean)]{.argtype} -- True if light is currently
emitting light\

```lua
local light = 0
function init()
    light = FindLight("main")
    if IsLightActive(light) then
        DebugPrint("Light is active")
    end
end
```

------------------------------------------------------------------------

[]{#IsPointAffectedByLight}

### IsPointAffectedByLight {#ispointaffectedbylight .function}

``` funcdef
affected = IsPointAffectedByLight(handle, point)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Light handle\
[point]{.argname} [(TVec)]{.argtype} -- World space point as vector\

Return value\
[affected]{.retname} [(boolean)]{.argtype} -- Return true if point is in
light cone and range\

```lua
local light = 0
function init()
    light = FindLight("main")
    local point = Vec(0, 10, 0)
    local affected = IsPointAffectedByLight(light, point)
    DebugPrint(affected)
end
```

------------------------------------------------------------------------

[]{#GetFlashlight}

### GetFlashlight {#getflashlight .function}

``` funcdef
handle = GetFlashlight()
```

Arguments\
[none]{.argname}

Return value\
[handle]{.retname} [(number)]{.argtype} -- Handle of the player\'s
flashlight\

Returns the handle of the player\'s flashlight. You can work with it as
with an entity of the Light type.

```lua
function tick()
    local flashlight = GetFlashlight()
    SetProperty(flashlight, "color", Vec(0.5, 0, 1))
end
```

------------------------------------------------------------------------

[]{#SetFlashlight}

### SetFlashlight {#setflashlight .function}

``` funcdef
SetFlashlight(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Handle of the light\

Return value\
[none]{.retname}

Sets a new entity of the Light type as a flashlight.

```lua
local oldLight = 0
function tick()
    -- in order not to lose the original flashlight, it is better to save it's handle
    oldLight = GetFlashlight()
    SetFlashlight(FindEntity("mylight", true))
end
```

------------------------------------------------------------------------

[]{#FindTrigger}

### FindTrigger {#findtrigger .function}

``` funcdef
handle = FindTrigger([tag], [global])
```

Arguments\
[tag]{.argname} [(string, optional)]{.argtype} -- Tag name\
[global]{.argname} [(boolean, optional)]{.argtype} -- Search in entire
scene\

Return value\
[handle]{.retname} [(number)]{.argtype} -- Handle to first trigger with
specified tag or zero if not found\

```lua
function init()
    local goal = FindTrigger("goal")
end
```

------------------------------------------------------------------------

[]{#FindTriggers}

### FindTriggers {#findtriggers .function}

``` funcdef
list = FindTriggers([tag], [global])
```

Arguments\
[tag]{.argname} [(string, optional)]{.argtype} -- Tag name\
[global]{.argname} [(boolean, optional)]{.argtype} -- Search in entire
scene\

Return value\
[list]{.retname} [(table)]{.argtype} -- Indexed table with handles to
all triggers with specified tag\

```lua
function init()
    --Find triggers tagged "toxic" in script scope
    local triggers = FindTriggers("toxic")
    for i=1, #triggers do
        local trigger = triggers[i]
        DebugPrint(trigger)
    end
end
```

------------------------------------------------------------------------

[]{#GetTriggerTransform}

### GetTriggerTransform {#gettriggertransform .function}

``` funcdef
transform = GetTriggerTransform(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Trigger handle\

Return value\
[transform]{.retname} [(TTransform)]{.argtype} -- Current trigger
transform in world space\

```lua
function init()
    local trigger = FindTrigger("toxic")
    local t = GetTriggerTransform(trigger)
    DebugPrint(t.pos)
end
```

------------------------------------------------------------------------

[]{#SetTriggerTransform}

### SetTriggerTransform {#settriggertransform .function}

``` funcdef
SetTriggerTransform(handle, transform)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Trigger handle\
[transform]{.argname} [(TTransform)]{.argtype} -- Desired trigger
transform in world space\

Return value\
[none]{.retname}

```lua
function init()
    local trigger = FindTrigger("toxic")
    local t = Transform(Vec(0, 1, 0), QuatEuler(0, 90, 0))
    SetTriggerTransform(trigger, t)
end
```

------------------------------------------------------------------------

[]{#GetTriggerBounds}

### GetTriggerBounds {#gettriggerbounds .function}

``` funcdef
min, max = GetTriggerBounds(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Trigger handle\

Return value\
[min]{.retname} [(TVec)]{.argtype} -- Lower point of trigger bounds in
world space\
[max]{.retname} [(TVec)]{.argtype} -- Upper point of trigger bounds in
world space\

Return the lower and upper points in world space of the trigger axis
aligned bounding box

```lua
function init()
    local trigger = FindTrigger("toxic")
    local mi, ma = GetTriggerBounds(trigger)
    
    local list = QueryAabbShapes(mi, ma)
    for i = 1, #list do
        DebugPrint(list[i])
    end
end
```

------------------------------------------------------------------------

[]{#IsBodyInTrigger}

### IsBodyInTrigger {#isbodyintrigger .function}

``` funcdef
inside = IsBodyInTrigger(trigger, body)
```

Arguments\
[trigger]{.argname} [(number)]{.argtype} -- Trigger handle\
[body]{.argname} [(number)]{.argtype} -- Body handle\

Return value\
[inside]{.retname} [(boolean)]{.argtype} -- True if body is in trigger
volume\

This function will only check the center point of the body

```lua
local trigger = 0
local body = 0
function init()
    trigger = FindTrigger("toxic")
    body = FindBody("body")
end

function tick()
    if IsBodyInTrigger(trigger, body) then
        DebugPrint("In trigger!")
    end
end
```

------------------------------------------------------------------------

[]{#IsVehicleInTrigger}

### IsVehicleInTrigger {#isvehicleintrigger .function}

``` funcdef
inside = IsVehicleInTrigger(trigger, vehicle)
```

Arguments\
[trigger]{.argname} [(number)]{.argtype} -- Trigger handle\
[vehicle]{.argname} [(number)]{.argtype} -- Vehicle handle\

Return value\
[inside]{.retname} [(boolean)]{.argtype} -- True if vehicle is in
trigger volume\

This function will only check origo of vehicle

```lua
local trigger = 0
local vehicle = 0
function init()
    trigger = FindTrigger("toxic")
    vehicle = FindVehicle("vehicle")
end

function tick()
    if IsVehicleInTrigger(trigger, vehicle) then
        DebugPrint("In trigger!")
    end
end
```

------------------------------------------------------------------------

[]{#IsShapeInTrigger}

### IsShapeInTrigger {#isshapeintrigger .function}

``` funcdef
inside = IsShapeInTrigger(trigger, shape)
```

Arguments\
[trigger]{.argname} [(number)]{.argtype} -- Trigger handle\
[shape]{.argname} [(number)]{.argtype} -- Shape handle\

Return value\
[inside]{.retname} [(boolean)]{.argtype} -- True if shape is in trigger
volume\

This function will only check the center point of the shape

```lua
local trigger = 0
local shape = 0
function init()
    trigger = FindTrigger("toxic")
    shape = FindShape("shape")
end

function tick()
    if IsShapeInTrigger(trigger, shape) then
        DebugPrint("In trigger!")
    end
end
```

------------------------------------------------------------------------

[]{#IsPointInTrigger}

### IsPointInTrigger {#ispointintrigger .function}

``` funcdef
inside = IsPointInTrigger(trigger, point)
```

Arguments\
[trigger]{.argname} [(number)]{.argtype} -- Trigger handle\
[point]{.argname} [(TVec)]{.argtype} -- Word space point as vector\

Return value\
[inside]{.retname} [(boolean)]{.argtype} -- True if point is in trigger
volume\

```lua
local trigger = 0
local point = {}
function init()
    trigger = FindTrigger("toxic", true)
    point = Vec(0, 0, 0)
end

function tick()
    if IsPointInTrigger(trigger, point) then
        DebugPrint("In trigger!")
    end
end
```

------------------------------------------------------------------------

[]{#IsPointInBoundaries}

### IsPointInBoundaries {#ispointinboundaries .function}

``` funcdef
value = IsPointInBoundaries(point)
```

Arguments\
[point]{.argname} [(TVec)]{.argtype} -- Point\

Return value\
[value]{.retname} [(boolean)]{.argtype} -- True if point is inside scene
boundaries\

Checks whether the point is within the scene boundaries. If there are no
boundaries on the scene, the function returns True.

```lua
function tick()
    local p = Vec(1.5, 3, 2.5)
    DebugWatch("In boundaries", IsPointInBoundaries(p))
end
```

------------------------------------------------------------------------

[]{#IsTriggerEmpty}

### IsTriggerEmpty {#istriggerempty .function}

``` funcdef
empty, maxpoint = IsTriggerEmpty(handle, [demolision])
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Trigger handle\
[demolision]{.argname} [(boolean, optional)]{.argtype} -- If true, small
debris and vehicles are ignored\

Return value\
[empty]{.retname} [(boolean)]{.argtype} -- True if trigger is empty\
[maxpoint]{.retname} [(TVec)]{.argtype} -- World space point of highest
point (largest Y coordinate) if not empty\

This function will check if trigger is empty. If trigger contains any
part of a body it will return false and the highest point as second
return value.

```lua
local trigger = 0
function init()
    trigger = FindTrigger("toxic")
end

function tick()
    local empty, highPoint = IsTriggerEmpty(trigger)
    if not empty then
        --highPoint[2] is the tallest point in trigger
        DebugPrint("Is not empty")
    end
end
```

------------------------------------------------------------------------

[]{#GetTriggerDistance}

### GetTriggerDistance {#gettriggerdistance .function}

``` funcdef
distance = GetTriggerDistance(trigger, point)
```

Arguments\
[trigger]{.argname} [(number)]{.argtype} -- Trigger handle\
[point]{.argname} [(TVec)]{.argtype} -- Word space point as vector\

Return value\
[distance]{.retname} [(number)]{.argtype} -- Positive if point is
outside, negative if inside\

Get distance to the surface of trigger volume. Will return negative
distance if inside.

```lua
local trigger = 0
function init()
    trigger = FindTrigger("toxic")
    local p = Vec(0, 10, 0)
    local dist = GetTriggerDistance(trigger, p)
    DebugPrint(dist)
end
```

------------------------------------------------------------------------

[]{#GetTriggerClosestPoint}

### GetTriggerClosestPoint {#gettriggerclosestpoint .function}

``` funcdef
closest = GetTriggerClosestPoint(trigger, point)
```

Arguments\
[trigger]{.argname} [(number)]{.argtype} -- Trigger handle\
[point]{.argname} [(TVec)]{.argtype} -- Word space point as vector\

Return value\
[closest]{.retname} [(TVec)]{.argtype} -- Closest point in trigger as
vector\

Return closest point in trigger volume. Will return the input point
itself if inside trigger or closest point on surface of trigger if
outside.

```lua
local trigger = 0
function init()
    trigger = FindTrigger("toxic")
    local p = Vec(0, 10, 0)
    local closest = GetTriggerClosestPoint(trigger, p)
    DebugPrint(closest)
end
```

------------------------------------------------------------------------

[]{#FindScreen}

### FindScreen {#findscreen .function}

``` funcdef
handle = FindScreen([tag], [global])
```

Arguments\
[tag]{.argname} [(string, optional)]{.argtype} -- Tag name\
[global]{.argname} [(boolean, optional)]{.argtype} -- Search in entire
scene\

Return value\
[handle]{.retname} [(number)]{.argtype} -- Handle to first screen with
specified tag or zero if not found\

```lua
function init()
    local screen = FindScreen("tv")
    DebugPrint(screen)
end
```

------------------------------------------------------------------------

[]{#FindScreens}

### FindScreens {#findscreens .function}

``` funcdef
list = FindScreens([tag], [global])
```

Arguments\
[tag]{.argname} [(string, optional)]{.argtype} -- Tag name\
[global]{.argname} [(boolean, optional)]{.argtype} -- Search in entire
scene\

Return value\
[list]{.retname} [(table)]{.argtype} -- Indexed table with handles to
all screens with specified tag\

```lua
function init()
    --Find screens tagged "tv" in script scope
    local screens = FindScreens("tv")
    for i=1, #screens do
        local screen = screens[i]
        DebugPrint(screen)
    end
end
```

------------------------------------------------------------------------

[]{#SetScreenEnabled}

### SetScreenEnabled {#setscreenenabled .function}

``` funcdef
SetScreenEnabled(screen, enabled)
```

Arguments\
[screen]{.argname} [(number)]{.argtype} -- Screen handle\
[enabled]{.argname} [(boolean)]{.argtype} -- True if screen should be
enabled\

Return value\
[none]{.retname}

Enable or disable screen

```lua
function init()
    SetScreenEnabled(FindScreen("tv"), true)
end
```

------------------------------------------------------------------------

[]{#IsScreenEnabled}

### IsScreenEnabled {#isscreenenabled .function}

``` funcdef
enabled = IsScreenEnabled(screen)
```

Arguments\
[screen]{.argname} [(number)]{.argtype} -- Screen handle\

Return value\
[enabled]{.retname} [(boolean)]{.argtype} -- True if screen is enabled\

```lua
function init()
    local b = IsScreenEnabled(FindScreen("tv"))
    DebugPrint(b)
end
```

------------------------------------------------------------------------

[]{#GetScreenShape}

### GetScreenShape {#getscreenshape .function}

``` funcdef
shape = GetScreenShape(screen)
```

Arguments\
[screen]{.argname} [(number)]{.argtype} -- Screen handle\

Return value\
[shape]{.retname} [(number)]{.argtype} -- Shape handle or zero if none\

Return handle to the parent shape of a screen

```lua
local screen = 0
function init()
    screen = FindScreen("tv")
    local shape = GetScreenShape(screen)
    DebugPrint(shape)
end
```

------------------------------------------------------------------------

[]{#FindVehicle}

### FindVehicle {#findvehicle .function}

``` funcdef
handle = FindVehicle([tag], [global])
```

Arguments\
[tag]{.argname} [(string, optional)]{.argtype} -- Tag name\
[global]{.argname} [(boolean, optional)]{.argtype} -- Search in entire
scene\

Return value\
[handle]{.retname} [(number)]{.argtype} -- Handle to first vehicle with
specified tag or zero if not found\

```lua
function init()
    local vehicle = FindVehicle("mycar")
end
```

------------------------------------------------------------------------

[]{#FindVehicles}

### FindVehicles {#findvehicles .function}

``` funcdef
list = FindVehicles([tag], [global])
```

Arguments\
[tag]{.argname} [(string, optional)]{.argtype} -- Tag name\
[global]{.argname} [(boolean, optional)]{.argtype} -- Search in entire
scene\

Return value\
[list]{.retname} [(table)]{.argtype} -- Indexed table with handles to
all vehicles with specified tag\

```lua
function init()
    --Find all vehicles in level tagged "boat"
    local boats = FindVehicles("boat")
    for i=1, #boats do
        local boat = boats[i]
        DebugPrint(boat)
    end
end
```

------------------------------------------------------------------------

[]{#GetVehicleTransform}

### GetVehicleTransform {#getvehicletransform .function}

``` funcdef
transform = GetVehicleTransform(vehicle)
```

Arguments\
[vehicle]{.argname} [(number)]{.argtype} -- Vehicle handle\

Return value\
[transform]{.retname} [(TTransform)]{.argtype} -- Transform of vehicle\

```lua
function init()
    local vehicle = FindVehicle("vehicle")
    local t = GetVehicleTransform(vehicle)
end
```

------------------------------------------------------------------------

[]{#GetVehicleExhaustTransforms}

### GetVehicleExhaustTransforms {#getvehicleexhausttransforms .function}

``` funcdef
transforms = GetVehicleExhaustTransforms(vehicle)
```

Arguments\
[vehicle]{.argname} [(number)]{.argtype} -- Vehicle handle\

Return value\
[transforms]{.retname} [(table)]{.argtype} -- Transforms of vehicle
exhausts\

Returns the exhausts transforms in local space of the vehicle.

```lua
function tick()
    local vehicle = FindVehicle("car", true)
    local t = GetVehicleExhaustTransforms(vehicle)
    for i = 1, #t do
        DebugWatch(tostring(i), t[i])
    end
end
```

------------------------------------------------------------------------

[]{#GetVehicleVitalTransforms}

### GetVehicleVitalTransforms {#getvehiclevitaltransforms .function}

``` funcdef
transforms = GetVehicleVitalTransforms(vehicle)
```

Arguments\
[vehicle]{.argname} [(number)]{.argtype} -- Vehicle handle\

Return value\
[transforms]{.retname} [(table)]{.argtype} -- Transforms of vehicle
vitals\

Returns the vitals transforms in local space of the vehicle.

```lua
function tick()
    local vehicle = FindVehicle("car", true)
    local t = GetVehicleVitalTransforms(vehicle)
    for i = 1, #t do
        DebugWatch(tostring(i), t[i])
    end
end
```

------------------------------------------------------------------------

[]{#GetVehicleBodies}

### GetVehicleBodies {#getvehiclebodies .function}

``` funcdef
transforms = GetVehicleBodies(vehicle)
```

Arguments\
[vehicle]{.argname} [(number)]{.argtype} -- Vehicle handle\

Return value\
[transforms]{.retname} [(table)]{.argtype} -- Vehicle bodies handles\

```lua
function tick()
    local vehicle = FindVehicle("car", true)
    local t = GetVehicleBodies(vehicle)
    for i = 1, #t do
        DebugWatch(tostring(i), t[i])
    end
end
```

------------------------------------------------------------------------

[]{#GetVehicleBody}

### GetVehicleBody {#getvehiclebody .function}

``` funcdef
body = GetVehicleBody(vehicle)
```

Arguments\
[vehicle]{.argname} [(number)]{.argtype} -- Vehicle handle\

Return value\
[body]{.retname} [(number)]{.argtype} -- Main body of vehicle\

```lua
function init()
    local vehicle = FindVehicle("vehicle")
    local body = GetVehicleBody(vehicle)
    if IsBodyBroken(body) then
        DebugPrint("Is broken")
    end
end
```

------------------------------------------------------------------------

[]{#GetVehicleHealth}

### GetVehicleHealth {#getvehiclehealth .function}

``` funcdef
health = GetVehicleHealth(vehicle)
```

Arguments\
[vehicle]{.argname} [(number)]{.argtype} -- Vehicle handle\

Return value\
[health]{.retname} [(number)]{.argtype} -- Vehicle health (zero to one)\

```lua
function init()
    local vehicle = FindVehicle("vehicle")
    local health = GetVehicleHealth(vehicle)
    DebugPrint(health)
end
```

------------------------------------------------------------------------

[]{#GetVehicleParams}

### GetVehicleParams {#getvehicleparams .function}

``` funcdef
params = GetVehicleParams(vehicle)
```

Arguments\
[vehicle]{.argname} [(number)]{.argtype} -- Vehicle handle\

Return value\
[params]{.retname} [(table)]{.argtype} -- Vehicle params\

```lua
function tick()
    local params = GetVehicleParams(FindVehicle("car", true))
    for key, value in pairs(params) do
        DebugWatch(key, value)
    end
end
```

------------------------------------------------------------------------

[]{#SetVehicleParam}

### SetVehicleParam {#setvehicleparam .function}

``` funcdef
SetVehicleParam(handle, param, value)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Vehicle handler\
[param]{.argname} [(string)]{.argtype} -- Param name\
[value]{.argname} [(number)]{.argtype} -- Param value\

Return value\
[none]{.retname}

Available parameters: spring, damping, topspeed, acceleration, strength,
antispin, antiroll, difflock, steerassist, friction

```lua
function init()
    SetVehicleParam(FindVehicle("car", true), "topspeed", 200)
end
```

------------------------------------------------------------------------

[]{#GetVehicleDriverPos}

### GetVehicleDriverPos {#getvehicledriverpos .function}

``` funcdef
pos = GetVehicleDriverPos(vehicle)
```

Arguments\
[vehicle]{.argname} [(number)]{.argtype} -- Vehicle handle\

Return value\
[pos]{.retname} [(TVec)]{.argtype} -- Driver position as vector in
vehicle space\

```lua
function init()
    local vehicle = FindVehicle("vehicle")
    local driverPos = GetVehicleDriverPos(vehicle)
    local t = GetVehicleTransform(vehicle)
    local worldPos = TransformToParentPoint(t, driverPos)
    DebugPrint(worldPos)
end
```

------------------------------------------------------------------------

[]{#GetVehicleSteering}

### GetVehicleSteering {#getvehiclesteering .function}

``` funcdef
steering = GetVehicleSteering(vehicle)
```

Arguments\
[vehicle]{.argname} [(number)]{.argtype} -- Vehicle handle\

Return value\
[steering]{.retname} [(number)]{.argtype} -- Driver steering value -1 to
1\

```lua
local steering = GetVehicleSteering(vehicle)
```

------------------------------------------------------------------------

[]{#GetVehicleDrive}

### GetVehicleDrive {#getvehicledrive .function}

``` funcdef
drive = GetVehicleDrive(vehicle)
```

Arguments\
[vehicle]{.argname} [(number)]{.argtype} -- Vehicle handle\

Return value\
[drive]{.retname} [(number)]{.argtype} -- Driver drive value -1 to 1\

```lua
local drive = GetVehicleDrive(vehicle)
```

------------------------------------------------------------------------

[]{#DriveVehicle}

### DriveVehicle {#drivevehicle .function}

``` funcdef
DriveVehicle(vehicle, drive, steering, handbrake)
```

Arguments\
[vehicle]{.argname} [(number)]{.argtype} -- Vehicle handle\
[drive]{.argname} [(number)]{.argtype} -- Reverse/forward control -1 to
1\
[steering]{.argname} [(number)]{.argtype} -- Left/right control -1 to 1\
[handbrake]{.argname} [(boolean)]{.argtype} -- Handbrake control\

Return value\
[none]{.retname}

This function applies input to vehicles, allowing for autonomous
driving. The vehicle will be turned on automatically and turned off when
no longer called. Call this from the tick function, not update.

```lua
function tick()
    --Drive mycar forwards
    local v = FindVehicle("mycar")
    DriveVehicle(v, 1, 0, false)
end
```

------------------------------------------------------------------------

[]{#GetPlayerPos}

### GetPlayerPos {#getplayerpos .function}

``` funcdef
position = GetPlayerPos()
```

Arguments\
[none]{.argname}

Return value\
[position]{.retname} [(TVec)]{.argtype} -- Player center position\

Return center point of player. This function is deprecated. Use
GetPlayerTransform instead.

```lua
function init()
    local p = GetPlayerPos()
    DebugPrint(p)

    --This is equivalent to
    p = VecAdd(GetPlayerTransform().pos, Vec(0,1,0))
    DebugPrint(p)
end
```

------------------------------------------------------------------------

[]{#GetPlayerAimInfo}

### GetPlayerAimInfo {#getplayeraiminfo .function}

``` funcdef
hit, startpos, endpos, direction, hitnormal, hitdist, hitentity, hitmaterial = GetPlayerAimInfo(position, [maxdist])
```

Arguments\
[position]{.argname} [(TVec)]{.argtype} -- Start position of the search\
[maxdist]{.argname} [(number, optional)]{.argtype} -- Max search
distance\

Return value\
[hit]{.retname} [(boolean)]{.argtype} -- TRUE if hit, FALSE otherwise.\
[startpos]{.retname} [(TVec)]{.argtype} -- Player can modify start
position when close to walls etc\
[endpos]{.retname} [(TVec)]{.argtype} -- Hit position\
[direction]{.retname} [(TVec)]{.argtype} -- Direction from start
position to end position\
[hitnormal]{.retname} [(TVec)]{.argtype} -- Normal of the hitpoint\
[hitdist]{.retname} [(number)]{.argtype} -- Distance of the hit\
[hitentity]{.retname} [(handle)]{.argtype} -- Handle of the entitiy
being hit\
[hitmaterial]{.retname} [(handle)]{.argtype} -- Name of the material
being hit\

```lua
local muzzle = GetToolLocationWorldTransform("muzzle")
local _, pos, _, dir = GetPlayerAimInfo(muzzle.pos)
Shoot(pos, dir)
```

------------------------------------------------------------------------

[]{#GetPlayerPitch}

### GetPlayerPitch {#getplayerpitch .function}

``` funcdef
pitch = GetPlayerPitch()
```

Arguments\
[none]{.argname}

Return value\
[pitch]{.retname} [(number)]{.argtype} -- Current player pitch angle\

The player pitch angle is applied to the player camera transform. This
value can be used to animate tool pitch movement when using
SetToolTransformOverride.

```lua
function init()
    local pitchRotation = Quat(Vec(1,0,0), GetPlayerPitch())
end
```

------------------------------------------------------------------------

[]{#GetPlayerYaw}

### GetPlayerYaw {#getplayeryaw .function}

``` funcdef
yaw = GetPlayerYaw()
```

Arguments\
[none]{.argname}

Return value\
[yaw]{.retname} [(number)]{.argtype} -- Current player yaw angle\

The player yaw angle is applied to the player camera transform. It
represents the top-down angle of rotation of the player.

```lua
function init()
    local compassBearing = GetPlayerYaw()
end
```

------------------------------------------------------------------------

[]{#SetPlayerPitch}

### SetPlayerPitch {#setplayerpitch .function}

``` funcdef
SetPlayerPitch(pitch)
```

Arguments\
[pitch]{.argname} [(number)]{.argtype} -- Pitch.\

Return value\
[none]{.retname}

Sets the player pitch.

```lua
function tick()
    -- look straight ahead
    SetPlayerPitch(0.0)
end
```

------------------------------------------------------------------------

[]{#GetPlayerCrouch}

### GetPlayerCrouch {#getplayercrouch .function}

``` funcdef
recoil = GetPlayerCrouch()
```

Arguments\
[none]{.argname}

Return value\
[recoil]{.retname} [(number)]{.argtype} -- Current player crouch\

```lua
function tick()
    local crouch = GetPlayerCrouch()
    if crouch > 0.0 then
        ...
    end
end
```

------------------------------------------------------------------------

[]{#GetPlayerTransform}

### GetPlayerTransform {#getplayertransform .function}

``` funcdef
transform = GetPlayerTransform([includePitch])
```

Arguments\
[includePitch]{.argname} [(boolean, optional)]{.argtype} -- Include the
player pitch (look up/down) in transform\

Return value\
[transform]{.retname} [(TTransform)]{.argtype} -- Current player
transform\

The player transform is located at the bottom of the player. The player
transform considers heading (looking left and right). Forward is along
negative Z axis. Player pitch (looking up and down) does not affect
player transform unless includePitch is set to true. If you want the
transform of the eye, use GetPlayerCameraTransform() instead.

```lua
function init()
    local t = GetPlayerTransform()
    DebugPrint(TransformStr(t))
end
```

------------------------------------------------------------------------

[]{#SetPlayerTransform}

### SetPlayerTransform {#setplayertransform .function}

``` funcdef
SetPlayerTransform(transform, [includePitch])
```

Arguments\
[transform]{.argname} [(TTransform)]{.argtype} -- Desired player
transform\
[includePitch]{.argname} [(boolean, optional)]{.argtype} -- Set player
pitch (look up/down) as well\

Return value\
[none]{.retname}

Instantly teleport the player to desired transform. Unless includePitch
is set to true, up/down look angle will be set to zero during this
process. Player velocity will be reset to zero.

```lua
function tick()
    if InputPressed("jump") then
        local t = Transform(Vec(50, 0, 0), QuatEuler(0, 90, 0))
        SetPlayerTransform(t)
    end
end
```

------------------------------------------------------------------------

[]{#ClearPlayerRig}

### ClearPlayerRig {#clearplayerrig .function}

``` funcdef
ClearPlayerRig(rig-id)
```

Arguments\
[rig-id]{.argname} [(number)]{.argtype} -- Unique rig-id, -1 means all
rigs\

Return value\
[none]{.retname}

```lua
    --Clear specific rig
    ClearPlayerRig(someId)
    
    --Clear all rigs
    ClearPlayerRig(-1)
```

------------------------------------------------------------------------

[]{#SetPlayerRigLocationLocalTransform}

### SetPlayerRigLocationLocalTransform {#setplayerriglocationlocaltransform .function}

``` funcdef
SetPlayerRigLocationLocalTransform(rig-id, name, location)
```

Arguments\
[rig-id]{.argname} [(number)]{.argtype} -- Unique id\
[name]{.argname} [(string)]{.argtype} -- Name of location\
[location]{.argname} [(table)]{.argtype} -- Rig Local transform of the
location\

Return value\
[none]{.retname}

```lua
    local someBody = FindBody("bodyname")
    SetPlayerRigLocationLocalTransform(someBody, "ik_foot_l", TransformToLocalTransform(GetBodyTransform(someBody), GetLocationTransform(FindLocation("ik_foot_l"))))
```

------------------------------------------------------------------------

[]{#SetPlayerRigTransform}

### SetPlayerRigTransform {#setplayerrigtransform .function}

``` funcdef
SetPlayerRigTransform(rig-id, location)
```

Arguments\
[rig-id]{.argname} [(number)]{.argtype} -- Unique id\
[location]{.argname} [(table)]{.argtype} -- New world transform\

Return value\
[none]{.retname}

This will both update the rig identified by the \'id\' and make it
active

```lua
    local someBody = FindBody("bodyname")
    SetPlayerRigTransform(someBody, GetBodyTransform(someBody))
```

------------------------------------------------------------------------

[]{#GetPlayerRigTransform}

### GetPlayerRigTransform {#getplayerrigtransform .function}

``` funcdef
location = GetPlayerRigTransform()
```

Arguments\
[none]{.argname}

Return value\
[location]{.retname} [(table)]{.argtype} -- Transform of the current
active player-rig, nil otherwise\

------------------------------------------------------------------------

[]{#GetPlayerRigLocationWorldTransform}

### GetPlayerRigLocationWorldTransform {#getplayerriglocationworldtransform .function}

``` funcdef
location = GetPlayerRigLocationWorldTransform(name)
```

Arguments\
[name]{.argname} [(string)]{.argtype} -- Name of location\

Return value\
[location]{.retname} [(table)]{.argtype} -- Transform of a location in
world space\

```lua
local t = GetPlayerRigLocationWorldTransform("ik_hand_l")
```

------------------------------------------------------------------------

[]{#SetPlayerRigTags}

### SetPlayerRigTags {#setplayerrigtags .function}

``` funcdef
SetPlayerRigTags(tag, [value])
```

Arguments\
[tag]{.argname} [(string)]{.argtype} -- Tag name\
[value]{.argname} [(string, optional)]{.argtype} -- Tag value\

Return value\
[none]{.retname}

------------------------------------------------------------------------

[]{#GetPlayerRigHasTag}

### GetPlayerRigHasTag {#getplayerrighastag .function}

``` funcdef
exists = GetPlayerRigHasTag(tag)
```

Arguments\
[tag]{.argname} [(string)]{.argtype} -- Tag name\

Return value\
[exists]{.retname} [(boolean)]{.argtype} -- Returns true if entity has
tag\

------------------------------------------------------------------------

[]{#GetPlayerRigTagValue}

### GetPlayerRigTagValue {#getplayerrigtagvalue .function}

``` funcdef
value = GetPlayerRigTagValue(tag)
```

Arguments\
[tag]{.argname} [(string)]{.argtype} -- Tag name\

Return value\
[value]{.retname} [(string)]{.argtype} -- Returns the tag value, if any.
Empty string otherwise.\

------------------------------------------------------------------------

[]{#SetPlayerGroundVelocity}

### SetPlayerGroundVelocity {#setplayergroundvelocity .function}

``` funcdef
SetPlayerGroundVelocity(vel)
```

Arguments\
[vel]{.argname} [(TVec)]{.argtype} -- Desired ground velocity\

Return value\
[none]{.retname}

Make the ground act as a conveyor belt, pushing the player even if
ground shape is static.

```lua
function tick()
    SetPlayerGroundVelocity(Vec(2,0,0))
end
```

------------------------------------------------------------------------

[]{#GetPlayerEyeTransform}

### GetPlayerEyeTransform {#getplayereyetransform .function}

``` funcdef
transform = GetPlayerEyeTransform()
```

Arguments\
[none]{.argname}

Return value\
[transform]{.retname} [(TTransform)]{.argtype} -- Current player eye
transform\

The player eye transform is the same as what you get from
GetCameraTransform when playing in first-person, but if you have set a
camera transform manually with SetCameraTransform or playing in
third-person, you can retrieve the player eye transform with this
function.

```lua
function init()
    local t = GetPlayerEyeTransform()
    DebugPrint(TransformStr(t))
end
```

------------------------------------------------------------------------

[]{#GetPlayerCameraTransform}

### GetPlayerCameraTransform {#getplayercameratransform .function}

``` funcdef
transform = GetPlayerCameraTransform()
```

Arguments\
[none]{.argname}

Return value\
[transform]{.retname} [(TTransform)]{.argtype} -- Current player camera
transform\

The player camera transform is usually the same as what you get from
GetCameraTransform, but if you have set a camera transform manually with
SetCameraTransform, you can retrieve the standard player camera
transform with this function.

```lua
function init()
    local t = GetPlayerCameraTransform()
    DebugPrint(TransformStr(t))
end
```

------------------------------------------------------------------------

[]{#SetPlayerCameraOffsetTransform}

### SetPlayerCameraOffsetTransform {#setplayercameraoffsettransform .function}

``` funcdef
SetPlayerCameraOffsetTransform(transform, [stackable])
```

Arguments\
[transform]{.argname} [(TTransform)]{.argtype} -- Desired player camera
offset transform\
[stackable]{.argname} [(boolean, optional)]{.argtype} -- True if eye
offset should summ up with multiple calls per tick\

Return value\
[none]{.retname}

Call this function continously to apply a camera offset. Can be used for
camera effects such as shake and wobble.

```lua
function tick()
    local t = Transform(Vec(), QuatAxisAngle(Vec(1, 0, 0), math.sin(GetTime()*3.0) * 3.0))
    SetPlayerCameraOffsetTransform(t)
end
```

------------------------------------------------------------------------

[]{#SetPlayerSpawnTransform}

### SetPlayerSpawnTransform {#setplayerspawntransform .function}

``` funcdef
SetPlayerSpawnTransform(transform)
```

Arguments\
[transform]{.argname} [(TTransform)]{.argtype} -- Desired player spawn
transform\

Return value\
[none]{.retname}

Call this function during init to alter the player spawn transform.

```lua
function init()
    local t = Transform(Vec(10, 0, 0), QuatEuler(0, 90, 0))
    SetPlayerSpawnTransform(t)
end
```

------------------------------------------------------------------------

[]{#SetPlayerSpawnHealth}

### SetPlayerSpawnHealth {#setplayerspawnhealth .function}

``` funcdef
SetPlayerSpawnHealth(health)
```

Arguments\
[health]{.argname} [(number)]{.argtype} -- Desired player spawn health
(between zero and one)\

Return value\
[none]{.retname}

Call this function during init to alter the player spawn health amount.

```lua
function init()
    SetPlayerSpawnHealth(0.5)
end
```

------------------------------------------------------------------------

[]{#SetPlayerSpawnTool}

### SetPlayerSpawnTool {#setplayerspawntool .function}

``` funcdef
SetPlayerSpawnTool(id)
```

Arguments\
[id]{.argname} [(string)]{.argtype} -- Tool unique identifier\

Return value\
[none]{.retname}

Call this function during init to alter the player spawn active tool.

```lua
function init()
    SetPlayerSpawnTool("pistol")
end
```

------------------------------------------------------------------------

[]{#GetPlayerVelocity}

### GetPlayerVelocity {#getplayervelocity .function}

``` funcdef
velocity = GetPlayerVelocity()
```

Arguments\
[none]{.argname}

Return value\
[velocity]{.retname} [(TVec)]{.argtype} -- Player velocity in world
space as vector\

```lua
function tick()
    local vel = GetPlayerVelocity()
    DebugPrint(VecStr(vel))
end
```

------------------------------------------------------------------------

[]{#SetPlayerVehicle}

### SetPlayerVehicle {#setplayervehicle .function}

``` funcdef
SetPlayerVehicle(vehicle)
```

Arguments\
[vehicle]{.argname} [(number)]{.argtype} -- Handle to vehicle or zero to
not drive.\

Return value\
[none]{.retname}

Drive specified vehicle.

```lua
function tick()
    if InputPressed("interact") then
        local car = FindVehicle("mycar")
        SetPlayerVehicle(car)
    end
end
```

------------------------------------------------------------------------

[]{#SetPlayerAnimator}

### SetPlayerAnimator {#setplayeranimator .function}

``` funcdef
SetPlayerAnimator(animator)
```

Arguments\
[animator]{.argname} [(number)]{.argtype} -- Handle to animator or zero
for no animator\

Return value\
[none]{.retname}

------------------------------------------------------------------------

[]{#GetPlayerAnimator}

### GetPlayerAnimator {#getplayeranimator .function}

``` funcdef
animator = GetPlayerAnimator()
```

Arguments\
[none]{.argname}

Return value\
[animator]{.retname} [(number)]{.argtype} -- Handle to animator or zero
for no animator\

------------------------------------------------------------------------

[]{#SetPlayerVelocity}

### SetPlayerVelocity {#setplayervelocity .function}

``` funcdef
SetPlayerVelocity(velocity)
```

Arguments\
[velocity]{.argname} [(TVec)]{.argtype} -- Player velocity in world
space as vector\

Return value\
[none]{.retname}

```lua
function tick()
    if InputPressed("jump") then
        SetPlayerVelocity(Vec(0, 5, 0)) 
    end
end
```

------------------------------------------------------------------------

[]{#GetPlayerVehicle}

### GetPlayerVehicle {#getplayervehicle .function}

``` funcdef
handle = GetPlayerVehicle()
```

Arguments\
[none]{.argname}

Return value\
[handle]{.retname} [(number)]{.argtype} -- Current vehicle handle, or
zero if not in vehicle\

```lua
function tick()
    local vehicle = GetPlayerVehicle()
    if vehicle ~= 0 then
        DebugPrint("Player drives the vehicle")
    end
end
```

------------------------------------------------------------------------

[]{#IsPlayerGrounded}

### IsPlayerGrounded {#isplayergrounded .function}

``` funcdef
isGrounded = IsPlayerGrounded()
```

Arguments\
[none]{.argname}

Return value\
[isGrounded]{.retname} [(boolean)]{.argtype} -- Whether the player is
grounded\

```lua
local isGrounded = IsPlayerGrounded()
```

------------------------------------------------------------------------

[]{#GetPlayerGroundContact}

### GetPlayerGroundContact {#getplayergroundcontact .function}

``` funcdef
contact, shape, point, normal = GetPlayerGroundContact()
```

Arguments\
[none]{.argname}

Return value\
[contact]{.retname} [(boolean)]{.argtype} -- Whether the player is
grounded\
[shape]{.retname} [(number)]{.argtype} -- Handle to shape\
[point]{.retname} [(Vec)]{.argtype} -- Point of contact\
[normal]{.retname} [(Vec)]{.argtype} -- Normal of contact\

Get information about player ground contact. If the output boolean
(contact) is false then the rest of the output is invalid.

```lua
function tick()
    hasGroundContact, shape, point, normal = GetPlayerGroundContact()

    if hasGroundContact then
        -- print ground contact data
        DebugPrint(VecStr(point).." : "..VecStr(normal))
    end
end
```

------------------------------------------------------------------------

[]{#GetPlayerGrabShape}

### GetPlayerGrabShape {#getplayergrabshape .function}

``` funcdef
handle = GetPlayerGrabShape()
```

Arguments\
[none]{.argname}

Return value\
[handle]{.retname} [(number)]{.argtype} -- Handle to grabbed shape or
zero if not grabbing.\

```lua
function tick()
    local shape = GetPlayerGrabShape()
    if shape ~= 0 then
        DebugPrint("Player is grabbing a shape")
    end
end
```

------------------------------------------------------------------------

[]{#GetPlayerGrabBody}

### GetPlayerGrabBody {#getplayergrabbody .function}

``` funcdef
handle = GetPlayerGrabBody()
```

Arguments\
[none]{.argname}

Return value\
[handle]{.retname} [(number)]{.argtype} -- Handle to grabbed body or
zero if not grabbing.\

```lua
function tick()
    local body = GetPlayerGrabBody()
    if body ~= 0 then
        DebugPrint("Player is grabbing a body")
    end
end
```

------------------------------------------------------------------------

[]{#ReleasePlayerGrab}

### ReleasePlayerGrab {#releaseplayergrab .function}

``` funcdef
ReleasePlayerGrab()
```

Arguments\
[none]{.argname}

Return value\
[none]{.retname}

Release what the player is currently holding

```lua
function tick()
    if InputPressed("jump") then
        ReleasePlayerGrab()
    end
end
```

------------------------------------------------------------------------

[]{#GetPlayerGrabPoint}

### GetPlayerGrabPoint {#getplayergrabpoint .function}

``` funcdef
pos = GetPlayerGrabPoint()
```

Arguments\
[none]{.argname}

Return value\
[pos]{.retname} [(TVec)]{.argtype} -- The world space grab point.\

```lua
local body = GetPlayerGrabBody()
if body ~= 0 then
    local pos = GetPlayerGrabPoint()
end
```

------------------------------------------------------------------------

[]{#GetPlayerPickShape}

### GetPlayerPickShape {#getplayerpickshape .function}

``` funcdef
handle = GetPlayerPickShape()
```

Arguments\
[none]{.argname}

Return value\
[handle]{.retname} [(number)]{.argtype} -- Handle to picked shape or
zero if nothing is picked\

```lua
function tick()
    local shape = GetPlayerPickShape()
    if shape ~= 0 then
        DebugPrint("Picked shape " .. shape)
    end
end
```

------------------------------------------------------------------------

[]{#GetPlayerPickBody}

### GetPlayerPickBody {#getplayerpickbody .function}

``` funcdef
handle = GetPlayerPickBody()
```

Arguments\
[none]{.argname}

Return value\
[handle]{.retname} [(number)]{.argtype} -- Handle to picked body or zero
if nothing is picked\

```lua
function tick()
    local body = GetPlayerPickBody()
    if body ~= 0 then
        DebugWatch("Pick body ", body)
    end
end
```

------------------------------------------------------------------------

[]{#GetPlayerInteractShape}

### GetPlayerInteractShape {#getplayerinteractshape .function}

``` funcdef
handle = GetPlayerInteractShape()
```

Arguments\
[none]{.argname}

Return value\
[handle]{.retname} [(number)]{.argtype} -- Handle to interactable shape
or zero\

Interactable shapes has to be tagged with \"interact\". The engine
determines which interactable shape is currently interactable.

```lua
function tick()
    local shape = GetPlayerInteractShape()
    if shape ~= 0 then
        DebugPrint("Interact shape " .. shape)
    end
end
```

------------------------------------------------------------------------

[]{#GetPlayerInteractBody}

### GetPlayerInteractBody {#getplayerinteractbody .function}

``` funcdef
handle = GetPlayerInteractBody()
```

Arguments\
[none]{.argname}

Return value\
[handle]{.retname} [(number)]{.argtype} -- Handle to interactable body
or zero\

Interactable shapes has to be tagged with \"interact\". The engine
determines which interactable body is currently interactable.

```lua
function tick()
    local body = GetPlayerInteractBody()
    if body ~= 0 then
        DebugPrint("Interact body " .. body)
    end
end
```

------------------------------------------------------------------------

[]{#SetPlayerScreen}

### SetPlayerScreen {#setplayerscreen .function}

``` funcdef
SetPlayerScreen(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Handle to screen or zero for
no screen\

Return value\
[none]{.retname}

Set the screen the player should interact with. For the screen to
feature a mouse pointer and receieve input, the screen also needs to
have interactive property.

```lua
function tick()
    if InputPressed("interact") then
        if GetPlayerScreen() ~= 0 then
            SetPlayerScreen(0)
        else
            SetPlayerScreen(screen)
        end

    end
end
```

------------------------------------------------------------------------

[]{#GetPlayerScreen}

### GetPlayerScreen {#getplayerscreen .function}

``` funcdef
handle = GetPlayerScreen()
```

Arguments\
[none]{.argname}

Return value\
[handle]{.retname} [(number)]{.argtype} -- Handle to interacted screen
or zero if none\

```lua
function tick()
    if InputPressed("interact") then
        if GetPlayerScreen() ~= 0 then
            SetPlayerScreen(0)
        else
            SetPlayerScreen(screen)
        end

    end
end
```

------------------------------------------------------------------------

[]{#SetPlayerHealth}

### SetPlayerHealth {#setplayerhealth .function}

``` funcdef
SetPlayerHealth(health)
```

Arguments\
[health]{.argname} [(number)]{.argtype} -- Set player health (between
zero and one)\

Return value\
[none]{.retname}

```lua
function tick()
    if InputPressed("interact") then
        if GetPlayerHealth() < 0.75 then
            SetPlayerHealth(1.0)
        else
            SetPlayerHealth(0.5)
        end
    end
end
```

------------------------------------------------------------------------

[]{#GetPlayerHealth}

### GetPlayerHealth {#getplayerhealth .function}

``` funcdef
health = GetPlayerHealth()
```

Arguments\
[none]{.argname}

Return value\
[health]{.retname} [(number)]{.argtype} -- Current player health\

```lua
function tick()
    if InputPressed("interact") then
        if GetPlayerHealth() < 0.75 then
            SetPlayerHealth(1.0)
        else
            SetPlayerHealth(0.5)
        end
    end
end
```

------------------------------------------------------------------------

[]{#SetPlayerRegenerationState}

### SetPlayerRegenerationState {#setplayerregenerationstate .function}

``` funcdef
SetPlayerRegenerationState(state)
```

Arguments\
[state]{.argname} [(boolean)]{.argtype} -- State of player regeneration\

Return value\
[none]{.retname}

Enable or disable regeneration for player

```lua
function init()
    -- disable regeneration for player
    SetPlayerRegenerationState(false)
end
```

------------------------------------------------------------------------

[]{#RespawnPlayer}

### RespawnPlayer {#respawnplayer .function}

``` funcdef
RespawnPlayer()
```

Arguments\
[none]{.argname}

Return value\
[none]{.retname}

Respawn player at spawn position without modifying the scene

```lua
function tick()
    if InputPressed("interact") then
        RespawnPlayer()
    end
end
```

------------------------------------------------------------------------

[]{#GetPlayerWalkingSpeed}

### GetPlayerWalkingSpeed {#getplayerwalkingspeed .function}

``` funcdef
speed = GetPlayerWalkingSpeed()
```

Arguments\
[none]{.argname}

Return value\
[speed]{.retname} [(number)]{.argtype} -- Current player base walking
speed\

This function gets base speed, but real player speed depends on many
factors such as health, crouch, water, grabbing objects.

```lua
function tick()
    DebugPrint(GetPlayerWalkingSpeed())
end
```

------------------------------------------------------------------------

[]{#SetPlayerWalkingSpeed}

### SetPlayerWalkingSpeed {#setplayerwalkingspeed .function}

``` funcdef
SetPlayerWalkingSpeed(speed)
```

Arguments\
[speed]{.argname} [(number)]{.argtype} -- Set player base walking speed\

Return value\
[none]{.retname}

This function sets base speed, but real player speed depends on many
factors such as health, crouch, water, grabbing objects.

```lua
function tick()
    if InputDown("shift") then
        SetPlayerWalkingSpeed(15.0)
    else
        SetPlayerWalkingSpeed(7.0)
    end
end
```

------------------------------------------------------------------------

[]{#GetPlayerParam}

### GetPlayerParam {#getplayerparam .function}

``` funcdef
value = GetPlayerParam(parameter)
```

Arguments\
[parameter]{.argname} [(string)]{.argtype} -- Parameter name\

Return value\
[value]{.retname} [(any)]{.argtype} -- Parameter value\

 Param name

 Type

 Description

health

float

Current value of the player\'s health.

healthRegeneration  

boolean  

Is the player\'s health regeneration enabled.

walkingSpeed

float

The player\'s walking speed.

jumpSpeed

float

The player\'s jump speed.

godMode

boolean  

If the value is True, the player does not lose health

friction

float

Player body friction

frictionMode

string

Player friction combine mode

flyMode

boolean  

If the value is True, the player will fly

```lua
function tick()
    -- The parameter names are case-insensitive, so any of the specified writing styles will be correct:
    -- "GodMode", "godmode", "godMode"
    local paramName = "GodMode"
    local param = GetPlayerParam(paramName)
    DebugWatch(paramName, param)

    if InputPressed("g") then
        SetPlayerParam(paramName, not param)
    end
end
```

------------------------------------------------------------------------

[]{#SetPlayerParam}

### SetPlayerParam {#setplayerparam .function}

``` funcdef
SetPlayerParam(parameter, value)
```

Arguments\
[parameter]{.argname} [(string)]{.argtype} -- Parameter name\
[value]{.argname} [(any)]{.argtype} -- Parameter value\

Return value\
[none]{.retname}

 Param name

 Type

 Description

health

float

Current value of the player\'s health.

healthRegeneration  

boolean  

Is the player\'s health regeneration enabled.

walkingSpeed

float

The player\'s walking speed. **This value is applied for 1 frame!**

jumpSpeed

float

The player\'s jump speed. The height of the jump depends non-linearly on
the jump speed. **This value is applied for 1 frame!**

godMode

boolean  

If the value is True, the player does not lose health

friction

float

Player body friction. Default is 0.8

frictionMode

string

Player friction combine mode. Can be
(average\|minimum\|multiply\|maximum)

flyMode

boolean  

If the value is True, the player will fly

```lua
function tick()
    -- The parameter names are case-insensitive, so any of the specified writing styles will be correct:
    -- "JumpSpeed", "jumpspeed", "jumpSpeed"
    local paramName = "JumpSpeed"
    local param = GetPlayerParam(paramName)
    DebugWatch(paramName, param)

    if InputDown("shift") then
        -- JumpSpeed sets for 1 frame
        SetPlayerParam(paramName, 10)
    end
end
```

------------------------------------------------------------------------

[]{#SetPlayerHidden}

### SetPlayerHidden {#setplayerhidden .function}

``` funcdef
SetPlayerHidden()
```

Arguments\
[none]{.argname}

Return value\
[none]{.retname}

Use this function to hide the player character.

```lua

function tick()
    ...
    SetCameraTransform(t)
    SetPlayerHidden()
end
```

------------------------------------------------------------------------

[]{#RegisterTool}

### RegisterTool {#registertool .function}

``` funcdef
RegisterTool(id, name, file, [group])
```

Arguments\
[id]{.argname} [(string)]{.argtype} -- Tool unique identifier\
[name]{.argname} [(string)]{.argtype} -- Tool name to show in hud\
[file]{.argname} [(string)]{.argtype} -- Path to vox file or prefab xml\
[group]{.argname} [(number, optional)]{.argtype} -- Tool group for this
tool (1-6) Default is 6.\

Return value\
[none]{.retname}

Register a custom tool that will show up in the player inventory and can
be selected with scroll wheel. Do this only once per tool. You also need
to enable the tool in the registry before it can be used.

```lua
function init()
    RegisterTool("lasergun", "Laser Gun", "MOD/vox/lasergun.vox")
    SetBool("game.tool.lasergun.enabled", true)
end

function tick()
    if GetString("game.player.tool") == "lasergun" then
        --Tool is selected. Tool logic goes here.
    end
end
```

------------------------------------------------------------------------

[]{#GetToolBody}

### GetToolBody {#gettoolbody .function}

``` funcdef
handle = GetToolBody()
```

Arguments\
[none]{.argname}

Return value\
[handle]{.retname} [(number)]{.argtype} -- Handle to currently visible
tool body or zero if none\

Return body handle of the visible tool. You can use this to retrieve
tool shapes and animate them, change emissiveness, etc. Do not attempt
to set the tool body transform, since it is controlled by the engine.
Use SetToolTranform for that.

```lua
function tick()
    local toolBody = GetToolBody()
    if toolBody~=0 then
        DebugPrint("Tool body: " .. toolBody)
    end
end
```

------------------------------------------------------------------------

[]{#GetToolHandPoseLocalTransform}

### GetToolHandPoseLocalTransform {#gettoolhandposelocaltransform .function}

``` funcdef
right, left = GetToolHandPoseLocalTransform()
```

Arguments\
[none]{.argname}

Return value\
[right]{.retname} [(TTransform)]{.argtype} -- Transform of right hand
relative to the tool body origin, or nil if the right hand is not used\
[left]{.retname} [(TTransform)]{.argtype} -- Transform of left hand, or
nil if left hand is not used\

```lua
local right, left = GetToolHandPoseLocalTransform()
```

------------------------------------------------------------------------

[]{#GetToolHandPoseWorldTransform}

### GetToolHandPoseWorldTransform {#gettoolhandposeworldtransform .function}

``` funcdef
right, left = GetToolHandPoseWorldTransform()
```

Arguments\
[none]{.argname}

Return value\
[right]{.retname} [(TTransform)]{.argtype} -- Transform of right hand in
world space, or nil if the right hand is not used\
[left]{.retname} [(TTransform)]{.argtype} -- Transform of left hand, or
nil if left hand is not used\

```lua
local right, left = GetToolHandPoseWorldTransform()
```

------------------------------------------------------------------------

[]{#SetToolHandPoseLocalTransform}

### SetToolHandPoseLocalTransform {#settoolhandposelocaltransform .function}

``` funcdef
SetToolHandPoseLocalTransform(right, left)
```

Arguments\
[right]{.argname} [(TTransform)]{.argtype} -- Transform of right hand
relative to the tool body origin, or nil if right hand is not used\
[left]{.argname} [(TTransform)]{.argtype} -- Transform of left hand, or
nil if left hand is not used\

Return value\
[none]{.retname}

Use this function to position the character\'s hands on the currently
equipped tool. This function must be called every frame from the tick
function. In third-person view, failing to call this function can lead
to different outcomes depending on how the tool is animated:

- If the tool\'s transform is not explicitly set or is set using
  SetToolTransform, not calling this function will trigger a fallback
  solution where the right hand is automatically positioned.
- If the tool is animated using the SetToolTransformOverride function,
  not calling this function will result in the character\'s animation
  taking control of the hand movement

```lua
if GetBool("game.thirdperson") then
    if aiming then
        SetToolHandPoseLocalTransform(Transform(Vec(0.2,0.0,0.0), QuatAxisAngle(Vec(0,1,0), 90.0)), Transform(Vec(-0.1, 0.0, -0.4)))
    else
        SetToolHandPoseLocalTransform(Transform(Vec(0.2,0.0,0.0), QuatAxisAngle(Vec(0,1,0), 90.0)), nil)
    end
end
```

------------------------------------------------------------------------

[]{#GetToolLocationLocalTransform}

### GetToolLocationLocalTransform {#gettoollocationlocaltransform .function}

``` funcdef
location = GetToolLocationLocalTransform(name)
```

Arguments\
[name]{.argname} [(string)]{.argtype} -- Name of location\

Return value\
[location]{.retname} [(TTransform)]{.argtype} -- Transform of a tool
location in tool space or nil if location is not found.\

Return transform of a tool location in tool space. Locations can be
defined using the tool prefab editor.

```lua
local right  = GetToolLocationLocalTransform("righthand")
SetToolHandPoseLocalTransform(right, nil)
```

------------------------------------------------------------------------

[]{#GetToolLocationWorldTransform}

### GetToolLocationWorldTransform {#gettoollocationworldtransform .function}

``` funcdef
location = GetToolLocationWorldTransform(name)
```

Arguments\
[name]{.argname} [(string)]{.argtype} -- Name of location\

Return value\
[location]{.retname} [(TTransform)]{.argtype} -- Transform of a tool
location in world space or nil if the location is not found or if there
is no visible tool body.\

Return transform of a tool location in world space. Locations can be
defined using the tool prefab editor. A tool location is defined in tool
space and to get the world space transform a tool body is required. If a
tool body does not exist this function will return nil.

```lua
local muzzle = GetToolLocationWorldTransform("muzzle")
Shoot(muzzle, direction)
```

------------------------------------------------------------------------

[]{#SetToolTransform}

### SetToolTransform {#settooltransform .function}

``` funcdef
SetToolTransform(transform, [sway])
```

Arguments\
[transform]{.argname} [(TTransform)]{.argtype} -- Tool body transform\
[sway]{.argname} [(number, optional)]{.argtype} -- Tool sway amount.
Default is 1.0.\

Return value\
[none]{.retname}

Apply an additional transform on the visible tool body. This can be used
to create tool animations. You need to set this every frame from the
tick function. The optional sway parameter control the amount of tool
swaying when walking. Set to zero to disable completely.

```lua
function init()
    --Offset the tool half a meter to the right
    local offset = Transform(Vec(0.5, 0, 0))
    SetToolTransform(offset)
end
```

------------------------------------------------------------------------

[]{#SetToolAllowedZoom}

### SetToolAllowedZoom {#settoolallowedzoom .function}

``` funcdef
SetToolAllowedZoom(zoom, [zoom])
```

Arguments\
[zoom]{.argname} [(number)]{.argtype} -- Zoom factor\
[zoom]{.argname} [(sensitivity\], optional)]{.argtype} -- Input
sensitivity when zoomed in. Default is 1.0.\

Return value\
[none]{.retname}

Set the allowed zoom for a registered tool. The zoom sensitivity will be
factored with the user options for sensitivity.

```lua
function tick()
    -- allow our scoped tool to zoom by factor 4.
    SetToolAllowedZoom(4.0, 0.5)
end
```

------------------------------------------------------------------------

[]{#SetToolTransformOverride}

### SetToolTransformOverride {#settooltransformoverride .function}

``` funcdef
SetToolTransformOverride(transform)
```

Arguments\
[transform]{.argname} [(TTransform)]{.argtype} -- Tool body transform\

Return value\
[none]{.retname}

This function serves as an alternative to SetToolTransform, providing
full control over tool animation by disabling all internal tool
animations. When using this function, you must manually include pitch,
sway, and crouch movements in the transform. To maintain this control,
call the function every frame from the tick function.

```lua
function init()

    if GetBool("game.thirdperson") then
        local toolTransform = Transform(Vec(0.3, -0.3, -0.2), Quat(0.0, 0.0, 15.0))

        -- Rotate around point
        local pivotPoint = Vec(-0.01, -0.2, 0.04)
        toolTransform.pos = VecSub(toolTransform.pos, pivotPoint)
        local rotation = Transform(Vec(), QuatAxisAngle(Vec(0,0,1), GetPlayerPitch()))
        toolTransform = TransformToParentTransform(rotation, toolTransform)
        toolTransform.pos = VecAdd(toolTransform.pos, pivotPoint)

        SetToolTransformOverride(toolTransform)
    else
        local toolTransform = Transform(Vec(0.3, -0.3, -0.2), Quat(0.0, 0.0, 15.0))
        SetToolTransform(toolTransform)
    end
end
```

------------------------------------------------------------------------

[]{#SetToolOffset}

### SetToolOffset {#settooloffset .function}

``` funcdef
SetToolOffset(offset)
```

Arguments\
[offset]{.argname} [(TVec)]{.argtype} -- Tool body offset\

Return value\
[none]{.retname}

Apply an additional offset on the visible tool body. This can be used to
tweak tool placement for different characters. You need to set this
every frame from the tick function.

```lua
function tick()
    --Offset the tool depending on character height
    local defaultEyeY = 1.7
    local offsetY = characterHeight - defaultEyeY
    local offset = Vec(0, offsetY, 0)
    SetToolOffset(offset)
end
```

------------------------------------------------------------------------

[]{#LoadSound}

### LoadSound {#loadsound .function}

``` funcdef
handle = LoadSound(path, [nominalDistance])
```

Arguments\
[path]{.argname} [(string)]{.argtype} -- Path to ogg sound file\
[nominalDistance]{.argname} [(number, optional)]{.argtype} -- The
distance in meters this sound is recorded at. Affects attenuation,
default is 10.0\

Return value\
[handle]{.retname} [(number)]{.argtype} -- Sound handle\

```lua
function init()
    local snd = LoadSound("warning-beep.ogg")
end
```

------------------------------------------------------------------------

[]{#UnloadSound}

### UnloadSound {#unloadsound .function}

``` funcdef
UnloadSound(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Sound handle\

Return value\
[none]{.retname}

```lua
function init()
    local snd = LoadSound("warning-beep.ogg")
    UnloadSound(snd)
end
```

------------------------------------------------------------------------

[]{#LoadLoop}

### LoadLoop {#loadloop .function}

``` funcdef
handle = LoadLoop(path, [nominalDistance])
```

Arguments\
[path]{.argname} [(string)]{.argtype} -- Path to ogg sound file\
[nominalDistance]{.argname} [(number, optional)]{.argtype} -- The
distance in meters this sound is recorded at. Affects attenuation,
default is 10.0\

Return value\
[handle]{.retname} [(number)]{.argtype} -- Loop handle\

```lua
local loop
function init()
    loop = LoadLoop("radio/jazz.ogg")
end

function tick()
    local pos = Vec(0, 0, 0)
    PlayLoop(loop, pos, 1.0)
end
```

------------------------------------------------------------------------

[]{#UnloadLoop}

### UnloadLoop {#unloadloop .function}

``` funcdef
UnloadLoop(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Loop handle\

Return value\
[none]{.retname}

```lua
local loop = -1
function init()
    loop = LoadLoop("radio/jazz.ogg")
end

function tick()
    if loop ~= -1 then
        local pos = Vec(0, 0, 0)
        PlayLoop(loop, pos, 1.0)
    end
        
    if InputPressed("space") then
        UnloadLoop(loop)
        loop = -1
    end
end
```

------------------------------------------------------------------------

[]{#SetSoundLoopUser}

### SetSoundLoopUser {#setsoundloopuser .function}

``` funcdef
flag = SetSoundLoopUser(handle, nominalDistance)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Loop handle\
[nominalDistance]{.argname} [(number)]{.argtype} -- User index\

Return value\
[flag]{.retname} [(boolean)]{.argtype} -- TRUE if sound applied to
gamepad speaker, FALSE otherwise.\

```lua
function init()
    local loop = LoadLoop("radio/jazz.ogg")
    SetSoundLoopUser(loop, 0)
end
--This function will move (if possible) sound to gamepad of appropriate user
```

------------------------------------------------------------------------

[]{#PlaySound}

### PlaySound {#playsound .function}

``` funcdef
handle = PlaySound(handle, [pos], [volume], [registerVolume], [pitch])
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Sound handle\
[pos]{.argname} [(TVec, optional)]{.argtype} -- World position as
vector. Default is player position.\
[volume]{.argname} [(number, optional)]{.argtype} -- Playback volume.
Default is 1.0\
[registerVolume]{.argname} [(boolean, optional)]{.argtype} -- Register
position and volume of this sound for GetLastSound. Default is true\
[pitch]{.argname} [(number, optional)]{.argtype} -- Playback pitch.
Default 1.0\

Return value\
[handle]{.retname} [(number)]{.argtype} -- Sound play handle\

```lua
local snd
function init()
    snd = LoadSound("warning-beep.ogg")
end

function tick()
    if InputPressed("interact") then
        local pos = Vec(0, 0, 0)
        PlaySound(snd, pos, 0.5)
    end
end

-- If you have a list of sound files and you add a sequence number, starting from zero, at the end of each filename like below,
-- then each time you call PlaySound it will pick a random sound from that list and play that sound.

-- "example-sound0.ogg"
-- "example-sound1.ogg"
-- "example-sound2.ogg"
-- "example-sound3.ogg"
-- ...
--[[
    local snd
    function init()
        snd = LoadSound("example-sound0.ogg")
    end

    -- Plays a random sound from the loaded sound series
    function tick()
        if trigSound then
            local pos = Vec(100, 0, 0)
            PlaySound(snd, pos, 0.5)
        end
    end
]]
```

------------------------------------------------------------------------

[]{#PlaySoundForUser}

### PlaySoundForUser {#playsoundforuser .function}

``` funcdef
handle = PlaySoundForUser(handle, user, [pos], [volume], [registerVolume], [pitch])
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Sound handle\
[user]{.argname} [(number)]{.argtype} -- Index of user to play.\
[pos]{.argname} [(TVec, optional)]{.argtype} -- World position as
vector. Default is player position.\
[volume]{.argname} [(number, optional)]{.argtype} -- Playback volume.
Default is 1.0\
[registerVolume]{.argname} [(boolean, optional)]{.argtype} -- Register
position and volume of this sound for GetLastSound. Default is true\
[pitch]{.argname} [(number, optional)]{.argtype} -- Playback pitch.
Default 1.0\

Return value\
[handle]{.retname} [(number)]{.argtype} -- Sound play handle\

```lua
local snd
function init()
    snd = LoadSound("warning-beep.ogg")
end

function tick()
    if InputPressed("interact") then
        PlaySoundForUser(snd, 0)
    end
end

-- If you have a list of sound files and you add a sequence number, starting from zero, at the end of each filename like below,
-- then each time you call PlaySoundForUser it will pick a random sound from that list and play that sound.

-- "example-sound0.ogg"
-- "example-sound1.ogg"
-- "example-sound2.ogg"
-- "example-sound3.ogg"
-- ...

--[[
    local snd
    function init()
        snd = LoadSound("example-sound0.ogg")
    end

    -- Plays a random sound from the loaded sound series
    function tick()
        if trigSound then
            local pos = Vec(100, 0, 0)
            PlaySoundForUser(snd, 0, pos, 0.5)
        end
    end
]]
```

------------------------------------------------------------------------

[]{#StopSound}

### StopSound {#stopsound .function}

``` funcdef
StopSound(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Sound play handle\

Return value\
[none]{.retname}

```lua
local snd
function init()
    snd = LoadSound("radio/jazz.ogg")
end

local sndPlay
function tick()
    if InputPressed("interact") then
        if not IsSoundPlaying(sndPlay) then
            local pos = Vec(0, 0, 0)
            sndPlay = PlaySound(snd, pos, 0.5)
        else
            StopSound(sndPlay)
        end
    end
end
```

------------------------------------------------------------------------

[]{#IsSoundPlaying}

### IsSoundPlaying {#issoundplaying .function}

``` funcdef
playing = IsSoundPlaying(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Sound play handle\

Return value\
[playing]{.retname} [(boolean)]{.argtype} -- True if sound is playing,
false otherwise.\

```lua
local snd
function init()
    snd = LoadSound("radio/jazz.ogg")
end

local sndPlay
function tick()
    if InputPressed("interact") then
        if not IsSoundPlaying(sndPlay) then
            local pos = Vec(0, 0, 0)
            sndPlay = PlaySound(snd, pos, 0.5)
        else
            StopSound(sndPlay)
        end
    end
end
```

------------------------------------------------------------------------

[]{#GetSoundProgress}

### GetSoundProgress {#getsoundprogress .function}

``` funcdef
progress = GetSoundProgress(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Sound play handle\

Return value\
[progress]{.retname} [(number)]{.argtype} -- Current sound progress in
seconds.\

```lua
local snd
function init()
    snd = LoadSound("radio/jazz.ogg")
end

local sndPlay
function tick()
    if InputPressed("interact") then
        if not IsSoundPlaying(sndPlay) then
            local pos = Vec(0, 0, 0)
            sndPlay = PlaySound(snd, pos, 0.5)
        else
            SetSoundProgress(sndPlay, GetSoundProgress(sndPlay) - 1.0)
        end
    end
end
```

------------------------------------------------------------------------

[]{#SetSoundProgress}

### SetSoundProgress {#setsoundprogress .function}

``` funcdef
SetSoundProgress(handle, progress)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Sound play handle\
[progress]{.argname} [(number)]{.argtype} -- Progress in seconds\

Return value\
[none]{.retname}

```lua
local snd
function init()
    snd = LoadSound("radio/jazz.ogg")
end

local sndPlay
function tick()
    if InputPressed("interact") then
        if not IsSoundPlaying(sndPlay) then
            local pos = Vec(0, 0, 0)
            sndPlay = PlaySound(snd, pos, 0.5)
        else
            SetSoundProgress(sndPlay, GetSoundProgress(sndPlay) - 1.0)
        end
    end
end
```

------------------------------------------------------------------------

[]{#PlayLoop}

### PlayLoop {#playloop .function}

``` funcdef
PlayLoop(handle, [pos], [volume], [registerVolume], [pitch])
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Loop handle\
[pos]{.argname} [(TVec, optional)]{.argtype} -- World position as
vector. Default is player position.\
[volume]{.argname} [(number, optional)]{.argtype} -- Playback volume.
Default is 1.0\
[registerVolume]{.argname} [(boolean, optional)]{.argtype} -- Register
position and volume of this sound for GetLastSound. Default is true\
[pitch]{.argname} [(number, optional)]{.argtype} -- Playback pitch.
Default 1.0\

Return value\
[none]{.retname}

Call this function continuously to play loop

```lua
local loop
function init()
    loop = LoadLoop("radio/jazz.ogg")
end

function tick()
    local pos = Vec(0, 0, 0)
    PlayLoop(loop, pos, 1.0)
end
```

------------------------------------------------------------------------

[]{#GetSoundLoopProgress}

### GetSoundLoopProgress {#getsoundloopprogress .function}

``` funcdef
progress = GetSoundLoopProgress(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Loop handle\

Return value\
[progress]{.retname} [(number)]{.argtype} -- Current music progress in
seconds.\

```lua
function init()
    loop = LoadLoop("radio/jazz.ogg")
end

function tick()
    local pos = Vec(0, 0, 0)
    PlayLoop(loop, pos, 1.0)
    if InputPressed("interact") then
        SetSoundLoopProgress(loop, GetSoundLoopProgress(loop) - 1.0)
    end
end
```

------------------------------------------------------------------------

[]{#SetSoundLoopProgress}

### SetSoundLoopProgress {#setsoundloopprogress .function}

``` funcdef
SetSoundLoopProgress(handle, [progress])
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Loop handle\
[progress]{.argname} [(number, optional)]{.argtype} -- Progress in
seconds. Default 0.0.\

Return value\
[none]{.retname}

```lua
function init()
    loop = LoadLoop("radio/jazz.ogg")
end

function tick()
    local pos = Vec(0, 0, 0)
    PlayLoop(loop, pos, 1.0)
    if InputPressed("interact") then
        SetSoundLoopProgress(loop, GetSoundLoopProgress(loop) - 1.0)
    end
end
```

------------------------------------------------------------------------

[]{#PlayMusic}

### PlayMusic {#playmusic .function}

``` funcdef
PlayMusic(path)
```

Arguments\
[path]{.argname} [(string)]{.argtype} -- Music path\

Return value\
[none]{.retname}

```lua
function init()
    PlayMusic("about.ogg")
end
```

------------------------------------------------------------------------

[]{#StopMusic}

### StopMusic {#stopmusic .function}

``` funcdef
StopMusic()
```

Arguments\
[none]{.argname}

Return value\
[none]{.retname}

```lua
function init()
    PlayMusic("about.ogg")
end

function tick()
    if InputDown("interact") then
        StopMusic()
    end
end
```

------------------------------------------------------------------------

[]{#IsMusicPlaying}

### IsMusicPlaying {#ismusicplaying .function}

``` funcdef
playing = IsMusicPlaying()
```

Arguments\
[none]{.argname}

Return value\
[playing]{.retname} [(boolean)]{.argtype} -- True if music is playing,
false otherwise.\

```lua
function init()
    PlayMusic("about.ogg")
end

function tick()
    if InputPressed("interact") and IsMusicPlaying() then
        DebugPrint("music is playing")
    end
end
```

------------------------------------------------------------------------

[]{#SetMusicPaused}

### SetMusicPaused {#setmusicpaused .function}

``` funcdef
SetMusicPaused(paused)
```

Arguments\
[paused]{.argname} [(boolean)]{.argtype} -- True to pause, false to
resume.\

Return value\
[none]{.retname}

```lua
function init()
    PlayMusic("about.ogg")
end

function tick()
    if InputPressed("interact") then
        SetMusicPaused(IsMusicPlaying())
    end
end
```

------------------------------------------------------------------------

[]{#GetMusicProgress}

### GetMusicProgress {#getmusicprogress .function}

``` funcdef
progress = GetMusicProgress()
```

Arguments\
[none]{.argname}

Return value\
[progress]{.retname} [(number)]{.argtype} -- Current music progress in
seconds.\

```lua
function init()
    PlayMusic("about.ogg")
end

function tick()
    if InputPressed("interact") then
        DebugPrint(GetMusicProgress())
    end
end
```

------------------------------------------------------------------------

[]{#SetMusicProgress}

### SetMusicProgress {#setmusicprogress .function}

``` funcdef
SetMusicProgress([progress])
```

Arguments\
[progress]{.argname} [(number, optional)]{.argtype} -- Progress in
seconds. Default 0.0.\

Return value\
[none]{.retname}

```lua
function init()
    PlayMusic("about.ogg")
end

function tick()
    if InputPressed("interact") then
        SetMusicProgress(GetMusicProgress() - 1.0)
    end
end
```

------------------------------------------------------------------------

[]{#SetMusicVolume}

### SetMusicVolume {#setmusicvolume .function}

``` funcdef
SetMusicVolume(volume)
```

Arguments\
[volume]{.argname} [(number)]{.argtype} -- Music volume.\

Return value\
[none]{.retname}

Override current music volume for this frame. Call continuously to keep
overriding.

```lua
function init()
    PlayMusic("about.ogg")
end

function tick()
    if InputDown("interact") then
        SetMusicVolume(0.3)
    end
end
```

------------------------------------------------------------------------

[]{#SetMusicLowPass}

### SetMusicLowPass {#setmusiclowpass .function}

``` funcdef
SetMusicLowPass(wet)
```

Arguments\
[wet]{.argname} [(number)]{.argtype} -- Music low pass filter 0.0 -
1.0.\

Return value\
[none]{.retname}

Override current music low pass filter for this frame. Call continuously
to keep overriding.

```lua
function init()
    PlayMusic("about.ogg")
end

function tick()
    if InputDown("interact") then
        SetMusicLowPass(0.6)
    end
end
```

------------------------------------------------------------------------

[]{#LoadSprite}

### LoadSprite {#loadsprite .function}

``` funcdef
handle = LoadSprite(path)
```

Arguments\
[path]{.argname} [(string)]{.argtype} -- Path to sprite. Must be PNG or
JPG format.\

Return value\
[handle]{.retname} [(number)]{.argtype} -- Sprite handle\

```lua
function init()
    arrow = LoadSprite("gfx/arrowdown.png")
end
```

------------------------------------------------------------------------

[]{#DrawSprite}

### DrawSprite {#drawsprite .function}

``` funcdef
DrawSprite(handle, transform, width, height, [r], [g], [b], [a], [depthTest], [additive], [fogAffected])
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Sprite handle\
[transform]{.argname} [(TTransform)]{.argtype} -- Transform\
[width]{.argname} [(number)]{.argtype} -- Width in meters\
[height]{.argname} [(number)]{.argtype} -- Height in meters\
[r]{.argname} [(number, optional)]{.argtype} -- Red color. Default 1.0.\
[g]{.argname} [(number, optional)]{.argtype} -- Green color. Default
1.0.\
[b]{.argname} [(number, optional)]{.argtype} -- Blue color. Default
1.0.\
[a]{.argname} [(number, optional)]{.argtype} -- Alpha. Default 1.0.\
[depthTest]{.argname} [(boolean, optional)]{.argtype} -- Depth test
enabled. Default false.\
[additive]{.argname} [(boolean, optional)]{.argtype} -- Additive
blending enabled. Default false.\
[fogAffected]{.argname} [(boolean, optional)]{.argtype} -- Enable
distance fog effect. Default false.\

Return value\
[none]{.retname}

Draw sprite in world at next frame. Call this function from the tick
callback.

```lua
function init()
    arrow = LoadSprite("gfx/arrowdown.png")
end

function tick()
    --Draw sprite using transform
    --Size is two meters in width and height
    --Color is white, fully opaue
    local t = Transform(Vec(0, 10, 0), QuatEuler(0, GetTime(), 0))
    DrawSprite(arrow, t, 2, 2, 1, 1, 1, 1)
end
```

------------------------------------------------------------------------

[]{#QueryRequire}

### QueryRequire {#queryrequire .function}

``` funcdef
QueryRequire(layers)
```

Arguments\
[layers]{.argname} [(string)]{.argtype} -- Space separate list of
layers\

Return value\
[none]{.retname}

Set required layers for next query. Available layers are:

 Layer 

 Description

physical

have a physical representation

dynamic

part of a dynamic body

static

part of a static body

large

above debris threshold

small

below debris threshold

visible

only hit visible shapes

animator    

part of an animator hierachy

player      

part of an player animator hierachy

tool        

part of a tool

```lua
--Raycast dynamic, physical objects above debris threshold, but not specific vehicle
function tick()
    local vehicle = FindVehicle("vehicle")
    QueryRequire("physical dynamic large")
    QueryRejectVehicle(vehicle)
    local hit, dist = QueryRaycast(Vec(0, 0, 0), Vec(1, 0, 0), 10)
    if hit then
        DebugPrint(dist)
    end
end
```

------------------------------------------------------------------------

[]{#QueryInclude}

### QueryInclude {#queryinclude .function}

``` funcdef
QueryInclude(layers)
```

Arguments\
[layers]{.argname} [(string)]{.argtype} -- Space separate list of
layers\

Return value\
[none]{.retname}

Set included layers for next query. Queries include all layers except
tool and player per default. Available layers are:

 Layer 

 Description

physical

have a physical representation

dynamic

part of a dynamic body

static

part of a static body

large

above debris threshold

small

below debris threshold

visible

only hit visible shapes

animator    

part of an animator hierachy

player      

part of an player

tool        

part of a tool

```lua
--Raycast all the default layers and include the player layer.
function tick()
    QueryInclude("player")
    local hit, dist = QueryRaycast(Vec(0, 0, 0), Vec(1, 0, 0), 10)
    if hit then
        DebugPrint(dist)
    end
end
```

------------------------------------------------------------------------

[]{#QueryRejectAnimator}

### QueryRejectAnimator {#queryrejectanimator .function}

``` funcdef
QueryRejectAnimator(handle)
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Animator handle\

Return value\
[none]{.retname}

Exclude animator from the next query

------------------------------------------------------------------------

[]{#QueryRejectVehicle}

### QueryRejectVehicle {#queryrejectvehicle .function}

``` funcdef
QueryRejectVehicle(vehicle)
```

Arguments\
[vehicle]{.argname} [(number)]{.argtype} -- Vehicle handle\

Return value\
[none]{.retname}

Exclude vehicle from the next query

```lua
function tick()
    local vehicle = FindVehicle("vehicle")
    QueryRequire("physical dynamic large")
    --Do not include vehicle in next raycast
    QueryRejectVehicle(vehicle)
    local hit, dist = QueryRaycast(Vec(0, 0, 0), Vec(1, 0, 0), 10)
    if hit then
        DebugPrint(dist)
    end
end


```

------------------------------------------------------------------------

[]{#QueryRejectBody}

### QueryRejectBody {#queryrejectbody .function}

``` funcdef
QueryRejectBody(body)
```

Arguments\
[body]{.argname} [(number)]{.argtype} -- Body handle\

Return value\
[none]{.retname}

Exclude body from the next query

```lua
function tick()
    local body = FindBody("body")
    QueryRequire("physical dynamic large")
    --Do not include body in next raycast
    QueryRejectBody(body)
    local hit, dist = QueryRaycast(Vec(0, 0, 0), Vec(1, 0, 0), 10)
    if hit then
        DebugPrint(dist)
    end
end
```

------------------------------------------------------------------------

[]{#QueryRejectBodies}

### QueryRejectBodies {#queryrejectbodies .function}

``` funcdef
QueryRejectBodies(bodies)
```

Arguments\
[bodies]{.argname} [(table)]{.argtype} -- Array with bodies handles\

Return value\
[none]{.retname}

Exclude bodies from the next query

```lua
function tick()
    local body = FindBody("body")
    QueryRequire("physical dynamic large")
    local bodies = {body}
    --Do not include body in next raycast
    QueryRejectBodies(bodies)
    local hit, dist = QueryRaycast(Vec(0, 0, 0), Vec(1, 0, 0), 10)
    if hit then
        DebugPrint(dist)
    end
end
```

------------------------------------------------------------------------

[]{#QueryRejectShape}

### QueryRejectShape {#queryrejectshape .function}

``` funcdef
QueryRejectShape(shape)
```

Arguments\
[shape]{.argname} [(number)]{.argtype} -- Shape handle\

Return value\
[none]{.retname}

Exclude shape from the next query

```lua
function tick()
    local shape = FindShape("shape")
    QueryRequire("physical dynamic large")
    --Do not include shape in next raycast
    QueryRejectShape(shape)
    local hit, dist = QueryRaycast(Vec(0, 0, 0), Vec(1, 0, 0), 10)
    if hit then
        DebugPrint(dist)
    end
end
```

------------------------------------------------------------------------

[]{#QueryRejectShapes}

### QueryRejectShapes {#queryrejectshapes .function}

``` funcdef
QueryRejectShapes(shapes)
```

Arguments\
[shapes]{.argname} [(table)]{.argtype} -- Array with shapes handles\

Return value\
[none]{.retname}

Exclude shapes from the next query

```lua
function tick()
    local shape = FindShape("shape")
    QueryRequire("physical dynamic large")
    local shapes = {shape}
    --Do not include shape in next raycast
    QueryRejectShapes(shapes)
    local hit, dist = QueryRaycast(Vec(0, 0, 0), Vec(1, 0, 0), 10)
    if hit then
        DebugPrint(dist)
    end
end
```

------------------------------------------------------------------------

[]{#QueryRaycast}

### QueryRaycast {#queryraycast .function}

``` funcdef
hit, dist, normal, shape = QueryRaycast(origin, direction, maxDist, [radius], [rejectTransparent])
```

Arguments\
[origin]{.argname} [(TVec)]{.argtype} -- Raycast origin as world space
vector\
[direction]{.argname} [(TVec)]{.argtype} -- Unit length raycast
direction as world space vector\
[maxDist]{.argname} [(number)]{.argtype} -- Raycast maximum distance.
Keep this as low as possible for good performance.\
[radius]{.argname} [(number, optional)]{.argtype} -- Raycast thickness.
Default zero.\
[rejectTransparent]{.argname} [(boolean, optional)]{.argtype} -- Raycast
through transparent materials. Default false.\

Return value\
[hit]{.retname} [(boolean)]{.argtype} -- True if raycast hit something\
[dist]{.retname} [(number)]{.argtype} -- Hit distance from origin\
[normal]{.retname} [(TVec)]{.argtype} -- World space normal at hit
point\
[shape]{.retname} [(number)]{.argtype} -- Handle to hit shape\

This will perform a raycast or spherecast (if radius is more than zero)
query. If you want to set up a filter for the query you need to do so
before every call to this function.

```lua
function init()
    local vehicle = FindVehicle("vehicle")
    QueryRejectVehicle(vehicle)
    --Raycast from a high point straight downwards, excluding a specific vehicle
    local hit, d = QueryRaycast(Vec(0, 100, 0), Vec(0, -1, 0), 100)
    if hit then
        DebugPrint(d)
    end
end
```

------------------------------------------------------------------------

[]{#QueryRaycastRope}

### QueryRaycastRope {#queryraycastrope .function}

``` funcdef
hit, dist, joint = QueryRaycastRope(origin, direction, maxDist, [radius])
```

Arguments\
[origin]{.argname} [(TVec)]{.argtype} -- Raycast origin as world space
vector\
[direction]{.argname} [(TVec)]{.argtype} -- Unit length raycast
direction as world space vector\
[maxDist]{.argname} [(number)]{.argtype} -- Raycast maximum distance.
Keep this as low as possible for good performance.\
[radius]{.argname} [(number, optional)]{.argtype} -- Raycast thickness.
Default zero.\

Return value\
[hit]{.retname} [(boolean)]{.argtype} -- True if raycast hit something\
[dist]{.retname} [(number)]{.argtype} -- Hit distance from origin\
[joint]{.retname} [(number)]{.argtype} -- Handle to hit joint of rope
type\

This will perform a raycast query that returns the handle of the joint
of rope type when if collides with it. There are no filters for this
type of raycast.

```lua
function tick()
    local playerCameraTransform = GetPlayerCameraTransform()
    local dir = TransformToParentVec(playerCameraTransform, Vec(0, 0, -1))

    local hit, dist, joint = QueryRaycastRope(playerCameraTransform.pos, dir, 10)
    if hit then
        DebugWatch("distance", dist)
        DebugWatch("joint", joint)
    end
end
```

------------------------------------------------------------------------

[]{#QueryClosestPoint}

### QueryClosestPoint {#queryclosestpoint .function}

``` funcdef
hit, point, normal, shape = QueryClosestPoint(origin, maxDist)
```

Arguments\
[origin]{.argname} [(TVec)]{.argtype} -- World space point\
[maxDist]{.argname} [(number)]{.argtype} -- Maximum distance. Keep this
as low as possible for good performance.\

Return value\
[hit]{.retname} [(boolean)]{.argtype} -- True if a point was found\
[point]{.retname} [(TVec)]{.argtype} -- World space closest point\
[normal]{.retname} [(TVec)]{.argtype} -- World space normal at closest
point\
[shape]{.retname} [(number)]{.argtype} -- Handle to closest shape\

This will query the closest point to all shapes in the world. If you
want to set up a filter for the query you need to do so before every
call to this function.

```lua
function tick()
    local vehicle = FindVehicle("vehicle")
    --Find closest point within 10 meters of {0, 5, 0}, excluding any point on myVehicle
    QueryRejectVehicle(vehicle)
    local hit, p, n, s = QueryClosestPoint(Vec(0, 5, 0), 10)
    if hit then
        DebugPrint(p)
    end
end
```

------------------------------------------------------------------------

[]{#QueryAabbShapes}

### QueryAabbShapes {#queryaabbshapes .function}

``` funcdef
list = QueryAabbShapes(min, max)
```

Arguments\
[min]{.argname} [(TVec)]{.argtype} -- Aabb minimum point\
[max]{.argname} [(TVec)]{.argtype} -- Aabb maximum point\

Return value\
[list]{.retname} [(table)]{.argtype} -- Indexed table with handles to
all shapes in the aabb\

Return all shapes within the provided world space, axis-aligned bounding
box

```lua
function tick()
    local list = QueryAabbShapes(Vec(0, 0, 0), Vec(10, 10, 10))
    for i=1, #list do
        local shape = list[i]
        DebugPrint(shape)
    end
end
```

------------------------------------------------------------------------

[]{#QueryAabbBodies}

### QueryAabbBodies {#queryaabbbodies .function}

``` funcdef
list = QueryAabbBodies(min, max)
```

Arguments\
[min]{.argname} [(TVec)]{.argtype} -- Aabb minimum point\
[max]{.argname} [(TVec)]{.argtype} -- Aabb maximum point\

Return value\
[list]{.retname} [(table)]{.argtype} -- Indexed table with handles to
all bodies in the aabb\

Return all bodies within the provided world space, axis-aligned bounding
box

```lua
function tick()
    local list = QueryAabbBodies(Vec(0, 0, 0), Vec(10, 10, 10))
    for i=1, #list do
        local body = list[i]
        DebugPrint(body)
    end
end
```

------------------------------------------------------------------------

[]{#QueryPath}

### QueryPath {#querypath .function}

``` funcdef
QueryPath(start, end, [maxDist], [targetRadius], [type])
```

Arguments\
[start]{.argname} [(TVec)]{.argtype} -- World space start point\
[end]{.argname} [(TVec)]{.argtype} -- World space target point\
[maxDist]{.argname} [(number, optional)]{.argtype} -- Maximum path
length before giving up. Default is infinite.\
[targetRadius]{.argname} [(number, optional)]{.argtype} -- Maximum
allowed distance to target in meters. Default is 2.0\
[type]{.argname} [(string, optional)]{.argtype} -- Type of path. Can be
\"low\", \"standart\", \"water\", \"flying\". Default is \"standart\"\

Return value\
[none]{.retname}

Initiate path planning query. The result will run asynchronously as long
as GetPathState returns \"busy\". An ongoing path query can be aborted
with AbortPath. The path planning query will use the currently set up
query filter, just like the other query functions. Using the \'water\'
type allows you to build a path within the water. The \'flying\' type
builds a path in the entire three-dimensional space.

```lua
function init()
    QueryPath(Vec(-10, 0, 0), Vec(10, 0, 0))
end
```

------------------------------------------------------------------------

[]{#CreatePathPlanner}

### CreatePathPlanner {#createpathplanner .function}

``` funcdef
id = CreatePathPlanner()
```

Arguments\
[none]{.argname}

Return value\
[id]{.retname} [(number)]{.argtype} -- Path planner id\

Creates a new path planner that can be used to calculate multiple paths
in parallel. It is supposed to be used together with PathPlannerQuery.
Returns created path planner id/handler. It is recommended to reuse
previously created path planners, because they exist throughout the
lifetime of the script.

```lua
local paths = {}

function init()
    paths[1] = {
        id = CreatePathPlanner(),
        location = GetProperty(FindEntity("loc1", true), "transform").pos,
    }

    paths[2] = {
        id = CreatePathPlanner(),
        location = GetProperty(FindEntity("loc2", true), "transform").pos,
    }

    for i = 1, #paths do
        PathPlannerQuery(paths[i].id, GetPlayerTransform().pos, paths[i].location)
    end
end
```

------------------------------------------------------------------------

[]{#DeletePathPlanner}

### DeletePathPlanner {#deletepathplanner .function}

``` funcdef
DeletePathPlanner(id)
```

Arguments\
[id]{.argname} [(number)]{.argtype} -- Path planner id\

Return value\
[none]{.retname}

Deletes the path planner with the specified id which can be used to save
some memory. Calling CreatePathPlanner again can initialize a new path
planner with the id previously deleted.

```lua
local paths = {}

function init()
    local id = CreatePathPlanner()
    DeletePathPlanner(id)
    -- now calling PathPlannerQuery for 'id' will result in an error
end
```

------------------------------------------------------------------------

[]{#PathPlannerQuery}

### PathPlannerQuery {#pathplannerquery .function}

``` funcdef
PathPlannerQuery(id, start, end, [maxDist], [targetRadius], [type])
```

Arguments\
[id]{.argname} [(number)]{.argtype} -- Path planner id\
[start]{.argname} [(TVec)]{.argtype} -- World space start point\
[end]{.argname} [(TVec)]{.argtype} -- World space target point\
[maxDist]{.argname} [(number, optional)]{.argtype} -- Maximum path
length before giving up. Default is infinite.\
[targetRadius]{.argname} [(number, optional)]{.argtype} -- Maximum
allowed distance to target in meters. Default is 2.0\
[type]{.argname} [(string, optional)]{.argtype} -- Type of path. Can be
\"low\", \"standart\", \"water\", \"flying\". Default is \"standart\"\

Return value\
[none]{.retname}

It works similarly to QueryPath but several paths can be built
simultaneously within the same script. The QueryPath automatically
creates a path planner with an index of 0 and only works with it.

```lua
local paths = {}

function init()
    paths[1] = {
        id = CreatePathPlanner(),
        location = GetProperty(FindEntity("loc1", true), "transform").pos,
    }

    paths[2] = {
        id = CreatePathPlanner(),
        location = GetProperty(FindEntity("loc2", true), "transform").pos,
    }

    for i = 1, #paths do
        PathPlannerQuery(paths[i].id, GetPlayerTransform().pos, paths[i].location)
    end
end
```

------------------------------------------------------------------------

[]{#AbortPath}

### AbortPath {#abortpath .function}

``` funcdef
AbortPath([id])
```

Arguments\
[id]{.argname} [(number, optional)]{.argtype} -- Path planner id.
Default value is 0.\

Return value\
[none]{.retname}

Abort current path query, regardless of what state it is currently in.
This is a way to save computing resources if the result of the current
query is no longer of interest.

```lua
function init()
    QueryPath(Vec(-10, 0, 0), Vec(10, 0, 0))
    AbortPath()
end
```

------------------------------------------------------------------------

[]{#GetPathState}

### GetPathState {#getpathstate .function}

``` funcdef
state = GetPathState([id])
```

Arguments\
[id]{.argname} [(number, optional)]{.argtype} -- Path planner id.
Default value is 0.\

Return value\
[state]{.retname} [(string)]{.argtype} -- Current path planning state\

Return the current state of the last path planning query.

 State 

 Description

idle

No recent query

busy

Busy computing. No path found yet.

fail

Failed to find path. You can still get the resulting path (even though
it won\'t reach the target).

done

Path planning completed and a path was found. Get it with GetPathLength
and GetPathPoint)

```lua
function init()
    QueryPath(Vec(-10, 0, 0), Vec(10, 0, 0))
end

function tick()
    local s = GetPathState()
    if s == "done" then
        DebugPrint("done")
    end
end
```

------------------------------------------------------------------------

[]{#GetPathLength}

### GetPathLength {#getpathlength .function}

``` funcdef
length = GetPathLength([id])
```

Arguments\
[id]{.argname} [(number, optional)]{.argtype} -- Path planner id.
Default value is 0.\

Return value\
[length]{.retname} [(number)]{.argtype} -- Length of last path planning
result (in meters)\

Return the path length of the most recently computed path query. Note
that the result can often be retrieved even if the path query failed. If
the target point couldn\'t be reached, the path endpoint will be the
point closest to the target.

```lua
function init()
    QueryPath(Vec(-10, 0, 0), Vec(10, 0, 0))
end

function tick()
    local s = GetPathState()
    if s == "done" then
        DebugPrint("done " .. GetPathLength())
    end
end
```

------------------------------------------------------------------------

[]{#GetPathPoint}

### GetPathPoint {#getpathpoint .function}

``` funcdef
point = GetPathPoint(dist, [id])
```

Arguments\
[dist]{.argname} [(number)]{.argtype} -- The distance along path. Should
be between zero and result from GetPathLength()\
[id]{.argname} [(number, optional)]{.argtype} -- Path planner id.
Default value is 0.\

Return value\
[point]{.retname} [(TVec)]{.argtype} -- The path point dist meters along
the path\

Return a point along the path for the most recently computed path query.
Note that the result can often be retrieved even if the path query
failed. If the target point couldn\'t be reached, the path endpoint will
be the point closest to the target.

```lua
function init()
    QueryPath(Vec(-10, 0, 0), Vec(10, 0, 0))
end

function tick()
    local d = 0
    local l = GetPathLength()
    while d < l do
        DebugCross(GetPathPoint(d))
        d = d + 0.5
    end
end
```

------------------------------------------------------------------------

[]{#GetLastSound}

### GetLastSound {#getlastsound .function}

``` funcdef
volume, position = GetLastSound()
```

Arguments\
[none]{.argname}

Return value\
[volume]{.retname} [(number)]{.argtype} -- Volume of loudest sound
played last frame\
[position]{.retname} [(TVec)]{.argtype} -- World position of loudest
sound played last frame\

```lua
function tick()
    local vol, pos = GetLastSound()
    if vol > 0 then
        DebugPrint(vol .. " " .. VecStr(pos)) 
    end
end
```

------------------------------------------------------------------------

[]{#IsPointInWater}

### IsPointInWater {#ispointinwater .function}

``` funcdef
inWater, depth = IsPointInWater(point)
```

Arguments\
[point]{.argname} [(TVec)]{.argtype} -- World point as vector\

Return value\
[inWater]{.retname} [(boolean)]{.argtype} -- True if point is in water\
[depth]{.retname} [(number)]{.argtype} -- Depth of point into water, or
zero if not in water\

```lua
function tick()
    local wet, d = IsPointInWater(Vec(10, 0, 0))
    if wet then
        DebugPrint("point" .. d .. " meters into water")
    end
end
```

------------------------------------------------------------------------

[]{#GetWindVelocity}

### GetWindVelocity {#getwindvelocity .function}

``` funcdef
vel = GetWindVelocity(point)
```

Arguments\
[point]{.argname} [(TVec)]{.argtype} -- World point as vector\

Return value\
[vel]{.retname} [(TVec)]{.argtype} -- Wind at provided position\

Get the wind velocity at provided point. The wind will be determined by
wind property of the environment, but it varies with position
procedurally.

```lua
function tick()
    local v = GetWindVelocity(Vec(0, 10, 0))
    DebugPrint(VecStr(v))
end
```

------------------------------------------------------------------------

[]{#ParticleReset}

### ParticleReset {#particlereset .function}

``` funcdef
ParticleReset()
```

Arguments\
[none]{.argname}

Return value\
[none]{.retname}

Reset to default particle state, which is a plain, white particle of
radius 0.5. Collision is enabled and it alpha animates from 1 to 0.

```lua
function init()
    ParticleReset()
end
```

------------------------------------------------------------------------

[]{#ParticleType}

### ParticleType {#particletype .function}

``` funcdef
ParticleType(type)
```

Arguments\
[type]{.argname} [(string)]{.argtype} -- Type of particle. Can be
\"smoke\" or \"plain\".\

Return value\
[none]{.retname}

Set type of particle

```lua
function init()
    ParticleType("smoke")
end
```

------------------------------------------------------------------------

[]{#ParticleTile}

### ParticleTile {#particletile .function}

``` funcdef
ParticleTile(type)
```

Arguments\
[type]{.argname} [(number)]{.argtype} -- Tile in the particle texture
atlas (0-15)\

Return value\
[none]{.retname}

```lua
function init()
    --Smoke particle
    ParticleTile(0)
    
    --Fire particle
    ParticleTile(5)
end
```

------------------------------------------------------------------------

[]{#ParticleColor}

### ParticleColor {#particlecolor .function}

``` funcdef
ParticleColor(r0, g0, b0, [r1], [g1], [b1])
```

Arguments\
[r0]{.argname} [(number)]{.argtype} -- Red value\
[g0]{.argname} [(number)]{.argtype} -- Green value\
[b0]{.argname} [(number)]{.argtype} -- Blue value\
[r1]{.argname} [(number, optional)]{.argtype} -- Red value at end\
[g1]{.argname} [(number, optional)]{.argtype} -- Green value at end\
[b1]{.argname} [(number, optional)]{.argtype} -- Blue value at end\

Return value\
[none]{.retname}

Set particle color to either constant (three arguments) or linear
interpolation (six arguments)

```lua
function init()
    --Constant red
    ParticleColor(1,0,0)

    --Animating from yellow to red
    ParticleColor(1,1,0, 1,0,0)
end
```

------------------------------------------------------------------------

[]{#ParticleRadius}

### ParticleRadius {#particleradius .function}

``` funcdef
ParticleRadius(r0, [r1], [interpolation], [fadein], [fadeout])
```

Arguments\
[r0]{.argname} [(number)]{.argtype} -- Radius\
[r1]{.argname} [(number, optional)]{.argtype} -- End radius\
[interpolation]{.argname} [(string, optional)]{.argtype} --
Interpolation method: linear, smooth, easein, easeout or constant.
Default is linear.\
[fadein]{.argname} [(number, optional)]{.argtype} -- Fade in between t=0
and t=fadein. Default is zero.\
[fadeout]{.argname} [(number, optional)]{.argtype} -- Fade out between
t=fadeout and t=1. Default is one.\

Return value\
[none]{.retname}

Set the particle radius. Max radius for smoke particles is 1.0.

```lua
function init()
    --Constant radius 0.4 meters
    ParticleRadius(0.4)

    --Interpolate from small to large
    ParticleRadius(0.1, 0.7)
end
```

------------------------------------------------------------------------

[]{#ParticleAlpha}

### ParticleAlpha {#particlealpha .function}

``` funcdef
ParticleAlpha(a0, [a1], [interpolation], [fadein], [fadeout])
```

Arguments\
[a0]{.argname} [(number)]{.argtype} -- Alpha (0.0 - 1.0)\
[a1]{.argname} [(number, optional)]{.argtype} -- End alpha (0.0 - 1.0)\
[interpolation]{.argname} [(string, optional)]{.argtype} --
Interpolation method: linear, smooth, easein, easeout or constant.
Default is linear.\
[fadein]{.argname} [(number, optional)]{.argtype} -- Fade in between t=0
and t=fadein. Default is zero.\
[fadeout]{.argname} [(number, optional)]{.argtype} -- Fade out between
t=fadeout and t=1. Default is one.\

Return value\
[none]{.retname}

Set the particle alpha (opacity).

```lua
function init()
    --Interpolate from opaque to transparent
    ParticleAlpha(1.0, 0.0)
end
```

------------------------------------------------------------------------

[]{#ParticleGravity}

### ParticleGravity {#particlegravity .function}

``` funcdef
ParticleGravity(g0, [g1], [interpolation], [fadein], [fadeout])
```

Arguments\
[g0]{.argname} [(number)]{.argtype} -- Gravity\
[g1]{.argname} [(number, optional)]{.argtype} -- End gravity\
[interpolation]{.argname} [(string, optional)]{.argtype} --
Interpolation method: linear, smooth, easein, easeout or constant.
Default is linear.\
[fadein]{.argname} [(number, optional)]{.argtype} -- Fade in between t=0
and t=fadein. Default is zero.\
[fadeout]{.argname} [(number, optional)]{.argtype} -- Fade out between
t=fadeout and t=1. Default is one.\

Return value\
[none]{.retname}

Set particle gravity. It will be applied along the world Y axis. A
negative value will move the particle downwards.

```lua
function init()
    --Move particles slowly upwards
    ParticleGravity(2)
end
```

------------------------------------------------------------------------

[]{#ParticleDrag}

### ParticleDrag {#particledrag .function}

``` funcdef
ParticleDrag(d0, [d1], [interpolation], [fadein], [fadeout])
```

Arguments\
[d0]{.argname} [(number)]{.argtype} -- Drag\
[d1]{.argname} [(number, optional)]{.argtype} -- End drag\
[interpolation]{.argname} [(string, optional)]{.argtype} --
Interpolation method: linear, smooth, easein, easeout or constant.
Default is linear.\
[fadein]{.argname} [(number, optional)]{.argtype} -- Fade in between t=0
and t=fadein. Default is zero.\
[fadeout]{.argname} [(number, optional)]{.argtype} -- Fade out between
t=fadeout and t=1. Default is one.\

Return value\
[none]{.retname}

Particle drag will slow down fast moving particles. It\'s implemented
slightly different for smoke and plain particles. Drag must be positive,
and usually look good between zero and one.

```lua
function init()
    --Slow down fast moving particles
    ParticleDrag(0.5)
end
```

------------------------------------------------------------------------

[]{#ParticleEmissive}

### ParticleEmissive {#particleemissive .function}

``` funcdef
ParticleEmissive(d0, [d1], [interpolation], [fadein], [fadeout])
```

Arguments\
[d0]{.argname} [(number)]{.argtype} -- Emissive\
[d1]{.argname} [(number, optional)]{.argtype} -- End emissive\
[interpolation]{.argname} [(string, optional)]{.argtype} --
Interpolation method: linear, smooth, easein, easeout or constant.
Default is linear.\
[fadein]{.argname} [(number, optional)]{.argtype} -- Fade in between t=0
and t=fadein. Default is zero.\
[fadeout]{.argname} [(number, optional)]{.argtype} -- Fade out between
t=fadeout and t=1. Default is one.\

Return value\
[none]{.retname}

Draw particle as emissive (glow in the dark). This is useful for fire
and embers.

```lua
function init()
    --Highly emissive at start, not emissive at end
    ParticleEmissive(5, 0)
end
```

------------------------------------------------------------------------

[]{#ParticleRotation}

### ParticleRotation {#particlerotation .function}

``` funcdef
ParticleRotation(r0, [r1], [interpolation], [fadein], [fadeout])
```

Arguments\
[r0]{.argname} [(number)]{.argtype} -- Rotation speed in radians per
second.\
[r1]{.argname} [(number, optional)]{.argtype} -- End rotation speed in
radians per second.\
[interpolation]{.argname} [(string, optional)]{.argtype} --
Interpolation method: linear, smooth, easein, easeout or constant.
Default is linear.\
[fadein]{.argname} [(number, optional)]{.argtype} -- Fade in between t=0
and t=fadein. Default is zero.\
[fadeout]{.argname} [(number, optional)]{.argtype} -- Fade out between
t=fadeout and t=1. Default is one.\

Return value\
[none]{.retname}

Makes the particle rotate. Positive values is counter-clockwise
rotation.

```lua
function init()
    --Rotate fast at start and slow at end
    ParticleRotation(10, 1)
end
```

------------------------------------------------------------------------

[]{#ParticleStretch}

### ParticleStretch {#particlestretch .function}

``` funcdef
ParticleStretch(s0, [s1], [interpolation], [fadein], [fadeout])
```

Arguments\
[s0]{.argname} [(number)]{.argtype} -- Stretch\
[s1]{.argname} [(number, optional)]{.argtype} -- End stretch\
[interpolation]{.argname} [(string, optional)]{.argtype} --
Interpolation method: linear, smooth, easein, easeout or constant.
Default is linear.\
[fadein]{.argname} [(number, optional)]{.argtype} -- Fade in between t=0
and t=fadein. Default is zero.\
[fadeout]{.argname} [(number, optional)]{.argtype} -- Fade out between
t=fadeout and t=1. Default is one.\

Return value\
[none]{.retname}

Stretch particle along with velocity. 0.0 means no stretching. 1.0
stretches with the particle motion over one frame. Larger values
stretches the particle even more.

```lua
function init()
    --Stretch particle along direction of motion
    ParticleStretch(1.0)
end
```

------------------------------------------------------------------------

[]{#ParticleSticky}

### ParticleSticky {#particlesticky .function}

``` funcdef
ParticleSticky(s0, [s1], [interpolation], [fadein], [fadeout])
```

Arguments\
[s0]{.argname} [(number)]{.argtype} -- Sticky (0.0 - 1.0)\
[s1]{.argname} [(number, optional)]{.argtype} -- End sticky (0.0 - 1.0)\
[interpolation]{.argname} [(string, optional)]{.argtype} --
Interpolation method: linear, smooth, easein, easeout or constant.
Default is linear.\
[fadein]{.argname} [(number, optional)]{.argtype} -- Fade in between t=0
and t=fadein. Default is zero.\
[fadeout]{.argname} [(number, optional)]{.argtype} -- Fade out between
t=fadeout and t=1. Default is one.\

Return value\
[none]{.retname}

Make particle stick when in contact with objects. This can be used for
friction.

```lua
function init()
    --Make particles stick to objects
    ParticleSticky(0.5)
end
```

------------------------------------------------------------------------

[]{#ParticleCollide}

### ParticleCollide {#particlecollide .function}

``` funcdef
ParticleCollide(c0, [c1], [interpolation], [fadein], [fadeout])
```

Arguments\
[c0]{.argname} [(number)]{.argtype} -- Collide (0.0 - 1.0)\
[c1]{.argname} [(number, optional)]{.argtype} -- End collide (0.0 -
1.0)\
[interpolation]{.argname} [(string, optional)]{.argtype} --
Interpolation method: linear, smooth, easein, easeout or constant.
Default is linear.\
[fadein]{.argname} [(number, optional)]{.argtype} -- Fade in between t=0
and t=fadein. Default is zero.\
[fadeout]{.argname} [(number, optional)]{.argtype} -- Fade out between
t=fadeout and t=1. Default is one.\

Return value\
[none]{.retname}

Control particle collisions. A value of zero means that collisions are
ignored. One means full collision. It is sometimes useful to animate
this value from zero to one in order to not collide with objects around
the emitter.

```lua
function init()
    --Disable collisions
    ParticleCollide(0)

    --Enable collisions over time
    ParticleCollide(0, 1)

    --Ramp up collisions very quickly, only skipping the first 5% of lifetime
    ParticleCollide(1, 1, "constant", 0.05)
end
```

------------------------------------------------------------------------

[]{#ParticleFlags}

### ParticleFlags {#particleflags .function}

``` funcdef
ParticleFlags(bitmask)
```

Arguments\
[bitmask]{.argname} [(number)]{.argtype} -- Particle flags (bitmask
0-65535)\

Return value\
[none]{.retname}

Set particle bitmask. The value 256 means fire extinguishing particles
and is currently the only flag in use. There might be support for custom
flags and queries in the future.

```lua
function tick()
    --Fire extinguishing particle
    ParticleFlags(256)
    SpawnParticle(Vec(0, 10, 0), -0.1, math.random() + 1)
end
```

------------------------------------------------------------------------

[]{#SpawnParticle}

### SpawnParticle {#spawnparticle .function}

``` funcdef
SpawnParticle(pos, velocity, lifetime)
```

Arguments\
[pos]{.argname} [(TVec)]{.argtype} -- World space point as vector\
[velocity]{.argname} [(TVec)]{.argtype} -- World space velocity as
vector\
[lifetime]{.argname} [(number)]{.argtype} -- Particle lifetime in
seconds\

Return value\
[none]{.retname}

Spawn particle using the previously set up particle state. You can call
this multiple times using the same particle state, but with different
position, velocity and lifetime. You can also modify individual
properties in the particle state in between calls to to this function.

```lua
function tick()
    ParticleReset()
    ParticleType("smoke")
    ParticleColor(0.7, 0.6, 0.5)
    --Spawn particle at world origo with upwards velocity and a lifetime of ten seconds
    SpawnParticle(Vec(0, 5, 0), Vec(0, 1, 0), 10.0)
end
```

------------------------------------------------------------------------

[]{#Spawn}

### Spawn {#spawn .function}

``` funcdef
entities = Spawn(xml, transform, [allowStatic], [jointExisting])
```

Arguments\
[xml]{.argname} [(string)]{.argtype} -- File name or xml string\
[transform]{.argname} [(TTransform)]{.argtype} -- Spawn transform\
[allowStatic]{.argname} [(boolean, optional)]{.argtype} -- Allow
spawning static shapes and bodies (default false)\
[jointExisting]{.argname} [(boolean, optional)]{.argtype} -- Allow
joints to connect to existing scene geometry (default false)\

Return value\
[entities]{.retname} [(table)]{.argtype} -- Indexed table with handles
to all spawned entities\

The first argument can be either a prefab XML file in your mod folder or
a string with XML content. It is also possible to spawn prefabs from
other mods, by using the mod id followed by colon, followed by the
prefab path. Spawning prefabs from other mods should be used with
causion since the referenced mod might not be installed.

```lua
function init()
    Spawn("MOD/prefab/mycar.xml", Transform(Vec(0, 5, 0)))
    Spawn("<voxbox size='10 10 10' prop='true' material='wood'/>", Transform(Vec(0, 10, 0)))
end
```

------------------------------------------------------------------------

[]{#SpawnLayer}

### SpawnLayer {#spawnlayer .function}

``` funcdef
entities = SpawnLayer(xml, layer, transform, [allowStatic], [jointExisting])
```

Arguments\
[xml]{.argname} [(string)]{.argtype} -- File name or xml string\
[layer]{.argname} [(string)]{.argtype} -- Vox layer name\
[transform]{.argname} [(TTransform)]{.argtype} -- Spawn transform\
[allowStatic]{.argname} [(boolean, optional)]{.argtype} -- Allow
spawning static shapes and bodies (default false)\
[jointExisting]{.argname} [(boolean, optional)]{.argtype} -- Allow
joints to connect to existing scene geometry (default false)\

Return value\
[entities]{.retname} [(table)]{.argtype} -- Indexed table with handles
to all spawned entities\

Same functionality as Spawn(), except using a specific layer in the
vox-file

```lua
function init()
    Spawn("MOD/prefab/mycar.xml", "some_vox_layer", Transform(Vec(0, 5, 0)))
    Spawn("<voxbox size='10 10 10' prop='true' material='wood'/>", "some_vox_layer", Transform(Vec(0, 10, 0)))
end
```

------------------------------------------------------------------------

[]{#Shoot}

### Shoot {#shoot .function}

``` funcdef
Shoot(origin, direction, [type], [strength], [maxDist])
```

Arguments\
[origin]{.argname} [(TVec)]{.argtype} -- Origin in world space as
vector\
[direction]{.argname} [(TVec)]{.argtype} -- Unit length direction as
world space vector\
[type]{.argname} [(string, optional)]{.argtype} -- Shot type, see
description, default is \"bullet\"\
[strength]{.argname} [(number, optional)]{.argtype} -- Strength scaling,
default is 1.0\
[maxDist]{.argname} [(number, optional)]{.argtype} -- Maximum distance,
default is 100.0\

Return value\
[none]{.retname}

Fire projectile. Type can be one of \"bullet\", \"rocket\", \"gun\" or
\"shotgun\". For backwards compatilbility, type also accept a number,
where 1 is same as \"rocket\" and anything else \"bullet\" Note that
this function will only spawn the projectile, not make any sound Also
note that \"bullet\" and \"rocket\" are the only projectiles that can
hurt the player.

```lua
function tick()
    Shoot(Vec(0, 10, 0), Vec(0, -1, 0), "shotgun")
end
```

------------------------------------------------------------------------

[]{#Paint}

### Paint {#paint .function}

``` funcdef
Paint(origin, radius, [type], [probability])
```

Arguments\
[origin]{.argname} [(TVec)]{.argtype} -- Origin in world space as
vector\
[radius]{.argname} [(number)]{.argtype} -- Affected radius, in range 0.0
to 5.0\
[type]{.argname} [(string, optional)]{.argtype} -- Paint type. Can be
\"explosion\" or \"spraycan\". Default is spraycan.\
[probability]{.argname} [(number, optional)]{.argtype} -- Dithering
probability between zero and one, default is 1.0\

Return value\
[none]{.retname}

Tint the color of objects within radius to either black or yellow.

```lua
function tick()
    Paint(Vec(0, 2, 0), 5.0, "spraycan")
end
```

------------------------------------------------------------------------

[]{#PaintRGBA}

### PaintRGBA {#paintrgba .function}

``` funcdef
PaintRGBA(origin, radius, red, green, blue, [alpha], [probability])
```

Arguments\
[origin]{.argname} [(TVec)]{.argtype} -- Origin in world space as
vector\
[radius]{.argname} [(number)]{.argtype} -- Affected radius, in range 0.0
to 5.0\
[red]{.argname} [(number)]{.argtype} -- red color value, in range 0.0 to
1.0\
[green]{.argname} [(number)]{.argtype} -- green color value, in range
0.0 to 1.0\
[blue]{.argname} [(number)]{.argtype} -- blue color value, in range 0.0
to 1.0\
[alpha]{.argname} [(number, optional)]{.argtype} -- alpha channel value,
in range 0.0 to 1.0\
[probability]{.argname} [(number, optional)]{.argtype} -- Dithering
probability between zero and one, default is 1.0\

Return value\
[none]{.retname}

Tint the color of objects within radius to custom RGBA color.

```lua
function tick()
    PaintRGBA(Vec(0, 5, 0), 5.5, 1.0, 0.0, 0.0)
end
```

------------------------------------------------------------------------

[]{#MakeHole}

### MakeHole {#makehole .function}

``` funcdef
count = MakeHole(position, r0, [r1], [r2], [silent])
```

Arguments\
[position]{.argname} [(TVec)]{.argtype} -- Hole center point\
[r0]{.argname} [(number)]{.argtype} -- Hole radius for soft materials\
[r1]{.argname} [(number, optional)]{.argtype} -- Hole radius for medium
materials. May not be bigger than r0. Default zero.\
[r2]{.argname} [(number, optional)]{.argtype} -- Hole radius for hard
materials. May not be bigger than r1. Default zero.\
[silent]{.argname} [(boolean, optional)]{.argtype} -- Make hole without
playing any break sounds.\

Return value\
[count]{.retname} [(number)]{.argtype} -- Number of voxels that was cut
out. This will be zero if there were no changes to any shape.\

Make a hole in the environment. Radius is given in meters. Soft
materials: glass, foliage, dirt, wood, plaster and plastic. Medium
materials: concrete, brick and weak metal. Hard materials: hard metal
and hard masonry.

```lua
function init()
    MakeHole(Vec(0, 0, 0), 5.0, 1.0)
end
```

------------------------------------------------------------------------

[]{#Explosion}

### Explosion {#explosion .function}

``` funcdef
Explosion(pos, size)
```

Arguments\
[pos]{.argname} [(TVec)]{.argtype} -- Position in world space as vector\
[size]{.argname} [(number)]{.argtype} -- Explosion size from 0.5 to 4.0\

Return value\
[none]{.retname}

```lua
function init()
    Explosion(Vec(0, 5, 0), 1)
end
```

------------------------------------------------------------------------

[]{#SpawnFire}

### SpawnFire {#spawnfire .function}

``` funcdef
SpawnFire(pos)
```

Arguments\
[pos]{.argname} [(TVec)]{.argtype} -- Position in world space as vector\

Return value\
[none]{.retname}

```lua
function tick()
    SpawnFire(Vec(0, 2, 0))
end
```

------------------------------------------------------------------------

[]{#GetFireCount}

### GetFireCount {#getfirecount .function}

``` funcdef
count = GetFireCount()
```

Arguments\
[none]{.argname}

Return value\
[count]{.retname} [(number)]{.argtype} -- Number of active fires in
level\

```lua
function tick()
    local c = GetFireCount()
    DebugPrint("Fire count " .. c)
end
```

------------------------------------------------------------------------

[]{#QueryClosestFire}

### QueryClosestFire {#queryclosestfire .function}

``` funcdef
hit, pos = QueryClosestFire(origin, maxDist)
```

Arguments\
[origin]{.argname} [(TVec)]{.argtype} -- World space position as vector\
[maxDist]{.argname} [(number)]{.argtype} -- Maximum search distance\

Return value\
[hit]{.retname} [(boolean)]{.argtype} -- A fire was found within search
distance\
[pos]{.retname} [(TVec)]{.argtype} -- Position of closest fire\

```lua
function tick()
    local hit, pos = QueryClosestFire(GetPlayerTransform().pos, 5.0)
    if hit then
        --There is a fire within 5 meters to the player. Mark it with a debug cross.
        DebugCross(pos)
    end
end
```

------------------------------------------------------------------------

[]{#QueryAabbFireCount}

### QueryAabbFireCount {#queryaabbfirecount .function}

``` funcdef
count = QueryAabbFireCount(min, max)
```

Arguments\
[min]{.argname} [(TVec)]{.argtype} -- Aabb minimum point\
[max]{.argname} [(TVec)]{.argtype} -- Aabb maximum point\

Return value\
[count]{.retname} [(number)]{.argtype} -- Number of active fires in
bounding box\

```lua
function tick()
    local count = QueryAabbFireCount(Vec(0,0,0), Vec(10,10,10))
    DebugPrint(count)
end
```

------------------------------------------------------------------------

[]{#RemoveAabbFires}

### RemoveAabbFires {#removeaabbfires .function}

``` funcdef
count = RemoveAabbFires(min, max)
```

Arguments\
[min]{.argname} [(TVec)]{.argtype} -- Aabb minimum point\
[max]{.argname} [(TVec)]{.argtype} -- Aabb maximum point\

Return value\
[count]{.retname} [(number)]{.argtype} -- Number of fires removed\

```lua
function tick()
    local removedCount= RemoveAabbFires(Vec(0,0,0), Vec(10,10,10))
    DebugPrint(removedCount)
end
```

------------------------------------------------------------------------

[]{#GetCameraTransform}

### GetCameraTransform {#getcameratransform .function}

``` funcdef
transform = GetCameraTransform()
```

Arguments\
[none]{.argname}

Return value\
[transform]{.retname} [(TTransform)]{.argtype} -- Current camera
transform\

```lua
function tick()
    local t = GetCameraTransform()
    DebugPrint(TransformStr(t))
end
```

------------------------------------------------------------------------

[]{#SetCameraTransform}

### SetCameraTransform {#setcameratransform .function}

``` funcdef
SetCameraTransform(transform, [fov])
```

Arguments\
[transform]{.argname} [(TTransform)]{.argtype} -- Desired camera
transform\
[fov]{.argname} [(number, optional)]{.argtype} -- Optional horizontal
field of view in degrees (default: 90)\

Return value\
[none]{.retname}

Override current camera transform for this frame. Call continuously to
keep overriding. When transform of some shape or body used to calculate
camera transform, consider use of AttachCameraTo, because you might be
using transform from previous physics update (that was on previous frame
or even earlier depending on fps and timescale).

```lua
function tick()
    SetCameraTransform(Transform(Vec(0, 10, 0), QuatEuler(0, 90, 0)))
end
```

------------------------------------------------------------------------

[]{#RequestFirstPerson}

### RequestFirstPerson {#requestfirstperson .function}

``` funcdef
RequestFirstPerson(transition)
```

Arguments\
[transition]{.argname} [(boolean)]{.argtype} -- Use transition\

Return value\
[none]{.retname}

Use this function to switch to first-person view, overriding the
player\'s selected third-person view. This is particularly useful for
scenarios like looking through a camera viewfinder or a rifle scope.
Call the function continuously to maintain the override.

```lua
function tick()
    if useViewFinder then
        RequestFirstPerson(true)
    end
end

function draw()
    if useViewFinder and !GetBool("game.thirdperson") then
        -- Draw view finder overlay
    end
end
```

------------------------------------------------------------------------

[]{#RequestThirdPerson}

### RequestThirdPerson {#requestthirdperson .function}

``` funcdef
RequestThirdPerson(transition)
```

Arguments\
[transition]{.argname} [(boolean)]{.argtype} -- Use transition\

Return value\
[none]{.retname}

Use this function to switch to third-person view, overriding the
player\'s selected first-person view. Call the function continuously to
maintain the override.

```lua
function tick()
    if useThirdPerson then
        RequestThirdPerson(true)
    end
end
```

------------------------------------------------------------------------

[]{#SetCameraOffsetTransform}

### SetCameraOffsetTransform {#setcameraoffsettransform .function}

``` funcdef
SetCameraOffsetTransform(transform, [stackable])
```

Arguments\
[transform]{.argname} [(TTransform)]{.argtype} -- Desired camera offset
transform\
[stackable]{.argname} [(boolean, optional)]{.argtype} -- True if camera
offset should summ up with multiple calls per tick\

Return value\
[none]{.retname}

Call this function continously to apply a camera offset. Can be used for
camera effects such as shake and wobble.

```lua
function tick()
    local tPosX = Transform(Vec(math.sin(GetTime()*3.0) * 0.2, 0, 0))
    local tPosY = Transform(Vec(0, math.cos(GetTime()*3.0) * 0.2, 0), QuatAxisAngle(Vec(0, 0, 0)))

    SetCameraOffsetTransform(tPosX, true)
    SetCameraOffsetTransform(tPosY, true)
end
```

------------------------------------------------------------------------

[]{#AttachCameraTo}

### AttachCameraTo {#attachcamerato .function}

``` funcdef
AttachCameraTo(handle, [ignoreRotation])
```

Arguments\
[handle]{.argname} [(number)]{.argtype} -- Body or shape handle\
[ignoreRotation]{.argname} [(boolean, optional)]{.argtype} -- True to
ignore rotation and use position only, false to use full transform\

Return value\
[none]{.retname}

Attach current camera transform for this frame to body or shape. Call
continuously to keep overriding. In tick function we have coordinates of
bodies and shapes that are not yet updated by physics, that\'s why
camera can not be in sync with it using SetCameraTransform, instead use
this function and SetCameraOffsetTransform to place camera around any
body or shape without lag.

```lua
function tick()
    local vehicle = GetPlayerVehicle()
    if vehicle ~= 0 then
        AttachCameraTo(GetVehicleBody(vehicle))
        SetCameraOffsetTransform(Transform(Vec(1, 2, 3)))
    end
end
```

------------------------------------------------------------------------

[]{#SetPivotClipBody}

### SetPivotClipBody {#setpivotclipbody .function}

``` funcdef
SetPivotClipBody(bodyHandle, mainShapeIdx)
```

Arguments\
[bodyHandle]{.argname} [(number)]{.argtype} -- Handle of a body, shapes
of which should be\
[mainShapeIdx]{.argname} [(number)]{.argtype} -- Optional index of a
shape among the given\

Return value\
[none]{.retname}

treated as pivots when clipping body\'s shapes which is used to
calculate clipping parameters (default: -1) Enforce camera clipping for
this frame and mark the given body as a pivot for clipping. Call
continuously to keep overriding.

```lua
local body_1 = 0
local body_2 = 0
function init()
    body_1 = FindBody("body_1")
    body_2 = FindBody("body_2")
end

function tick()
    SetPivotClipBody(body_1, 0) -- this overload should be called once and
    -- only once per frame to take effect
    SetPivotClipBody(body_2)
end
```

------------------------------------------------------------------------

[]{#ShakeCamera}

### ShakeCamera {#shakecamera .function}

``` funcdef
ShakeCamera(strength)
```

Arguments\
[strength]{.argname} [(number)]{.argtype} -- Normalized strength of
shaking\

Return value\
[none]{.retname}

Shakes the player camera

```lua
function tick()
    ShakeCamera(0.5)
end
```

------------------------------------------------------------------------

[]{#SetCameraFov}

### SetCameraFov {#setcamerafov .function}

``` funcdef
SetCameraFov(degrees)
```

Arguments\
[degrees]{.argname} [(number)]{.argtype} -- Horizontal field of view in
degrees (10-170)\

Return value\
[none]{.retname}

Override field of view for the next frame for all camera modes, except
when explicitly set in SetCameraTransform

```lua
function tick()
    SetCameraFov(60)
end
```

------------------------------------------------------------------------

[]{#SetCameraDof}

### SetCameraDof {#setcameradof .function}

``` funcdef
SetCameraDof(distance, [amount])
```

Arguments\
[distance]{.argname} [(number)]{.argtype} -- Depth of field distance\
[amount]{.argname} [(number, optional)]{.argtype} -- Optional amount of
blur (default 1.0)\

Return value\
[none]{.retname}

Override depth of field for the next frame for all camera modes. Depth
of field will be used even if turned off in options.

```lua
function tick()
    --Set depth of field to 10 meters
    SetCameraDof(10)
end
```

------------------------------------------------------------------------

[]{#PointLight}

### PointLight {#pointlight .function}

``` funcdef
PointLight(pos, r, g, b, [intensity])
```

Arguments\
[pos]{.argname} [(TVec)]{.argtype} -- World space light position\
[r]{.argname} [(number)]{.argtype} -- Red\
[g]{.argname} [(number)]{.argtype} -- Green\
[b]{.argname} [(number)]{.argtype} -- Blue\
[intensity]{.argname} [(number, optional)]{.argtype} -- Intensity.
Default is 1.0.\

Return value\
[none]{.retname}

Add a temporary point light to the world for this frame. Call
continuously for a steady light.

```lua
function tick()
    --Pulsating, yellow light above world origo
    local intensity = 3 + math.sin(GetTime())
    PointLight(Vec(0, 5, 0), 1, 1, 0, intensity)
end
```

------------------------------------------------------------------------

[]{#SetTimeScale}

### SetTimeScale {#settimescale .function}

``` funcdef
SetTimeScale(scale)
```

Arguments\
[scale]{.argname} [(number)]{.argtype} -- Time scale 0.0 to 2.0\

Return value\
[none]{.retname}

Experimental. Scale time in order to make a slow-motion or acceleration
effect. Audio will also be affected. (v1.4 and below: this function will
affect physics behavior and is not intended for gameplay purposes.)
Starting from v1.5 this function does not affect physics behavior and
rely on rendering interpolation. Scaling time up may decrease
performance, and is not recommended for gameplay purposes. Calling this
function will change time scale for the next frame only. Call every
frame from tick function to get steady slow-motion.

```lua
function tick()
    --Slow down time when holding down a key
    if InputDown('t') then
        SetTimeScale(0.2)
    end
end
```

------------------------------------------------------------------------

[]{#SetEnvironmentDefault}

### SetEnvironmentDefault {#setenvironmentdefault .function}

``` funcdef
SetEnvironmentDefault()
```

Arguments\
[none]{.argname}

Return value\
[none]{.retname}

Reset the environment properties to default. This is often useful before
setting up a custom environment.

```lua
function init()
    SetEnvironmentDefault()
end
```

------------------------------------------------------------------------

[]{#SetEnvironmentProperty}

### SetEnvironmentProperty {#setenvironmentproperty .function}

``` funcdef
SetEnvironmentProperty(name, value0, [value1], [value2], [value3])
```

Arguments\
[name]{.argname} [(string)]{.argtype} -- Property name\
[value0]{.argname} [(any)]{.argtype} -- Property value (type depends on
property)\
[value1]{.argname} [(any, optional)]{.argtype} -- Extra property value
(only some properties)\
[value2]{.argname} [(any, optional)]{.argtype} -- Extra property value
(only some properties)\
[value3]{.argname} [(any, optional)]{.argtype} -- Extra property value
(only some properties)\

Return value\
[none]{.retname}

This function is used for manipulating the environment properties. The
available properties are exactly the same as in the editor, except for
\"snowonground\" which is not currently supported.

```lua
function init()
    SetEnvironmentDefault()
    SetEnvironmentProperty("skybox", "cloudy.dds")
    SetEnvironmentProperty("rain", 0.7)
    SetEnvironmentProperty("fogcolor", 0.5, 0.5, 0.8)
    SetEnvironmentProperty("nightlight", false)
end
```

------------------------------------------------------------------------

[]{#GetEnvironmentProperty}

### GetEnvironmentProperty {#getenvironmentproperty .function}

``` funcdef
value0, value1, value2, value3, value4 = GetEnvironmentProperty(name)
```

Arguments\
[name]{.argname} [(string)]{.argtype} -- Property name\

Return value\
[value0]{.retname} [(any)]{.argtype} -- Property value (type depends on
property)\
[value1]{.retname} [(any)]{.argtype} -- Property value (only some
properties)\
[value2]{.retname} [(any)]{.argtype} -- Property value (only some
properties)\
[value3]{.retname} [(any)]{.argtype} -- Property value (only some
properties)\
[value4]{.retname} [(any)]{.argtype} -- Property value (only some
properties)\

This function is used for querying the current environment properties.
The available properties are exactly the same as in the editor.

```lua
function init()
    local skyboxPath = GetEnvironmentProperty("skybox")
    local rainValue = GetEnvironmentProperty("rain")
    local r,g,b = GetEnvironmentProperty("fogcolor")
    local enabled = GetEnvironmentProperty("nightlight")
    DebugPrint(skyboxPath)
    DebugPrint(rainValue)
    DebugPrint(r .. " " .. g .. " " .. b)
    DebugPrint(enabled)
end
```

------------------------------------------------------------------------

[]{#SetPostProcessingDefault}

### SetPostProcessingDefault {#setpostprocessingdefault .function}

``` funcdef
SetPostProcessingDefault()
```

Arguments\
[none]{.argname}

Return value\
[none]{.retname}

Reset the post processing properties to default.

```lua
function tick()
    SetPostProcessingProperty("saturation", 0.4)
    SetPostProcessingProperty("colorbalance", 1.3, 1.0, 0.7)
    SetPostProcessingDefault()
end
```

------------------------------------------------------------------------

[]{#SetPostProcessingProperty}

### SetPostProcessingProperty {#setpostprocessingproperty .function}

``` funcdef
SetPostProcessingProperty(name, value0, [value1], [value2])
```

Arguments\
[name]{.argname} [(string)]{.argtype} -- Property name\
[value0]{.argname} [(number)]{.argtype} -- Property value\
[value1]{.argname} [(number, optional)]{.argtype} -- Extra property
value (only some properties)\
[value2]{.argname} [(number, optional)]{.argtype} -- Extra property
value (only some properties)\

Return value\
[none]{.retname}

This function is used for manipulating the post processing properties.
The available properties are exactly the same as in the editor.

```lua
--Sepia post processing
function tick()
    SetPostProcessingProperty("saturation", 0.4)
    SetPostProcessingProperty("colorbalance", 1.3, 1.0, 0.7)
end
```

------------------------------------------------------------------------

[]{#GetPostProcessingProperty}

### GetPostProcessingProperty {#getpostprocessingproperty .function}

``` funcdef
value0, value1, value2 = GetPostProcessingProperty(name)
```

Arguments\
[name]{.argname} [(string)]{.argtype} -- Property name\

Return value\
[value0]{.retname} [(number)]{.argtype} -- Property value\
[value1]{.retname} [(number)]{.argtype} -- Property value (only some
properties)\
[value2]{.retname} [(number)]{.argtype} -- Property value (only some
properties)\

This function is used for querying the current post processing
properties. The available properties are exactly the same as in the
editor.

```lua
function tick()
    SetPostProcessingProperty("saturation", 0.4)
    SetPostProcessingProperty("colorbalance", 1.3, 1.0, 0.7)
    local saturation = GetPostProcessingProperty("saturation")
    local r,g,b = GetPostProcessingProperty("colorbalance")
    DebugPrint("saturation " .. saturation)
    DebugPrint("colorbalance " .. r .. " " .. g .. " " .. b)
end
```

------------------------------------------------------------------------

[]{#DrawLine}

### DrawLine {#drawline .function}

``` funcdef
DrawLine(p0, p1, [r], [g], [b], [a])
```

Arguments\
[p0]{.argname} [(TVec)]{.argtype} -- World space point as vector\
[p1]{.argname} [(TVec)]{.argtype} -- World space point as vector\
[r]{.argname} [(number, optional)]{.argtype} -- Red\
[g]{.argname} [(number, optional)]{.argtype} -- Green\
[b]{.argname} [(number, optional)]{.argtype} -- Blue\
[a]{.argname} [(number, optional)]{.argtype} -- Alpha\

Return value\
[none]{.retname}

Draw a 3D line. In contrast to DebugLine, it will not show behind
objects. Default color is white.

```lua
function tick()
    --Draw white debug line
    DrawLine(Vec(0, 0, 0), Vec(-10, 5, -10))

    --Draw red debug line
    DrawLine(Vec(0, 0, 0), Vec(10, 5, 10), 1, 0, 0)
end
```

------------------------------------------------------------------------

[]{#DebugLine}

### DebugLine {#debugline .function}

``` funcdef
DebugLine(p0, p1, [r], [g], [b], [a])
```

Arguments\
[p0]{.argname} [(TVec)]{.argtype} -- World space point as vector\
[p1]{.argname} [(TVec)]{.argtype} -- World space point as vector\
[r]{.argname} [(number, optional)]{.argtype} -- Red\
[g]{.argname} [(number, optional)]{.argtype} -- Green\
[b]{.argname} [(number, optional)]{.argtype} -- Blue\
[a]{.argname} [(number, optional)]{.argtype} -- Alpha\

Return value\
[none]{.retname}

Draw a 3D debug overlay line in the world. Default color is white.

```lua
function tick()
    --Draw white debug line
    DebugLine(Vec(0, 0, 0), Vec(-10, 5, -10))

    --Draw red debug line
    DebugLine(Vec(0, 0, 0), Vec(10, 5, 10), 1, 0, 0)
end
```

------------------------------------------------------------------------

[]{#DebugCross}

### DebugCross {#debugcross .function}

``` funcdef
DebugCross(p0, [r], [g], [b], [a])
```

Arguments\
[p0]{.argname} [(TVec)]{.argtype} -- World space point as vector\
[r]{.argname} [(number, optional)]{.argtype} -- Red\
[g]{.argname} [(number, optional)]{.argtype} -- Green\
[b]{.argname} [(number, optional)]{.argtype} -- Blue\
[a]{.argname} [(number, optional)]{.argtype} -- Alpha\

Return value\
[none]{.retname}

Draw a debug cross in the world to highlight a location. Default color
is white.

```lua
function tick()
    DebugCross(Vec(10, 5, 5))
end
```

------------------------------------------------------------------------

[]{#DebugTransform}

### DebugTransform {#debugtransform .function}

``` funcdef
DebugTransform(transform, [scale])
```

Arguments\
[transform]{.argname} [(TTransform)]{.argtype} -- The transform\
[scale]{.argname} [(number, optional)]{.argtype} -- Length of the axis\

Return value\
[none]{.retname}

Draw the axis of the transform

```lua
function tick()
    DebugTransform(GetPlayerCameraTransform(), 0.5)
end
```

------------------------------------------------------------------------

[]{#DebugWatch}

### DebugWatch {#debugwatch .function}

``` funcdef
DebugWatch(name, value, [lineWrapping])
```

Arguments\
[name]{.argname} [(string)]{.argtype} -- Name\
[value]{.argname} [(string)]{.argtype} -- Value\
[lineWrapping]{.argname} [(boolean, optional)]{.argtype} -- True if you
need to wrap Table lines. Works only with tables.\

Return value\
[none]{.retname}

Show a named valued on screen for debug purposes. Up to 32 values can be
shown simultaneously. Values updated the current frame are drawn opaque.
Old values are drawn transparent in white.

The function will also recognize tables and convert them to strings
automatically.

```lua
function tick()
    DebugWatch("Player camera transform", GetPlayerCameraTransform())

    local anyTable = {
        "teardown",
        {
            name = "Alex",
            age = 25,
            child = { name = "Lena" }
        },
        nil,
        version = "1.6.0",
        true
    }
    DebugWatch("table", anyTable);
end
```

------------------------------------------------------------------------

[]{#DebugPrint}

### DebugPrint {#debugprint .function}

``` funcdef
DebugPrint(message, [lineWrapping])
```

Arguments\
[message]{.argname} [(string)]{.argtype} -- Message to display\
[lineWrapping]{.argname} [(boolean, optional)]{.argtype} -- True if you
need to wrap Table lines. Works only with tables.\

Return value\
[none]{.retname}

Display message on screen. The last 20 lines are displayed. The function
will also recognize tables and convert them to strings automatically.

```lua
function init()
    DebugPrint("time")

    DebugPrint(GetPlayerCameraTransform())

    local anyTable = {
        "teardown",
        {
            name = "Alex",
            age = 25,
            child = { name = "Lena" }
        },
        nil,
        version = "1.6.0",
        true,
    }
    DebugPrint(anyTable)
end
```

------------------------------------------------------------------------

[]{#RegisterListenerTo}

### RegisterListenerTo {#registerlistenerto .function}

``` funcdef
RegisterListenerTo(eventName, listenerFunction)
```

Arguments\
[eventName]{.argname} [(string)]{.argtype} -- Event name\
[listenerFunction]{.argname} [(string)]{.argtype} -- Listener function
name\

Return value\
[none]{.retname}

Binds the callback function on the event

```lua
function onLangauageChanged()
    DebugPrint("langauageChanged")
end

function init()
    RegisterListenerTo("LanguageChanged", "onLangauageChanged")
    TriggerEvent("LanguageChanged")
end
```

------------------------------------------------------------------------

[]{#UnregisterListener}

### UnregisterListener {#unregisterlistener .function}

``` funcdef
UnregisterListener(eventName, listenerFunction)
```

Arguments\
[eventName]{.argname} [(string)]{.argtype} -- Event name\
[listenerFunction]{.argname} [(string)]{.argtype} -- Listener function
name\

Return value\
[none]{.retname}

Unbinds the callback function from the event

```lua
function onLangauageChanged()
    DebugPrint("langauageChanged")
end

function init()
    RegisterListenerTo("LanguageChanged", "onLangauageChanged")
    UnregisterListener("LanguageChanged", "onLangauageChanged")
    TriggerEvent("LanguageChanged")
end
```

------------------------------------------------------------------------

[]{#TriggerEvent}

### TriggerEvent {#triggerevent .function}

``` funcdef
TriggerEvent(eventName, [args])
```

Arguments\
[eventName]{.argname} [(string)]{.argtype} -- Event name\
[args]{.argname} [(string, optional)]{.argtype} -- Event parameters\

Return value\
[none]{.retname}

Triggers an event for all registered listeners

```lua
function onLangauageChanged()
    DebugPrint("langauageChanged")
end

function init()
    RegisterListenerTo("LanguageChanged", "onLangauageChanged")
    UnregisterListener("LanguageChanged", "onLangauageChanged")
    TriggerEvent("LanguageChanged")
end
```

------------------------------------------------------------------------

[]{#LoadHaptic}

### LoadHaptic {#loadhaptic .function}

``` funcdef
handle = LoadHaptic(filepath)
```

Arguments\
[filepath]{.argname} [(string)]{.argtype} -- Path to Haptic effect to
play\

Return value\
[handle]{.retname} [(string)]{.argtype} -- Haptic effect handle\

```lua
-- Rumble with gun Haptic effect
function init()
    haptic_effect = LoadHaptic("haptic/gun_fire.xml")
end

function tick()
    if trigHaptic then
        PlayHaptic(haptic_effect, 1)
    end
end
```

------------------------------------------------------------------------

[]{#CreateHaptic}

### CreateHaptic {#createhaptic .function}

``` funcdef
handle = CreateHaptic(leftMotorRumble, rightMotorRumble, leftTriggerRumble, rightTriggerRumble)
```

Arguments\
[leftMotorRumble]{.argname} [(number)]{.argtype} -- Amount of rumble for
left motor\
[rightMotorRumble]{.argname} [(number)]{.argtype} -- Amount of rumble
for right motor\
[leftTriggerRumble]{.argname} [(number)]{.argtype} -- Amount of rumble
for left trigger\
[rightTriggerRumble]{.argname} [(number)]{.argtype} -- Amount of rumble
for right trigger\

Return value\
[handle]{.retname} [(string)]{.argtype} -- Haptic effect handle\

```lua
-- Rumble with gun Haptic effect
function init()
    haptic_effect = CreateHaptic(1, 1, 0, 0)
end

function tick()
    if trigHaptic then
        PlayHaptic(haptic_effect, 1)
    end
end
```

------------------------------------------------------------------------

[]{#PlayHaptic}

### PlayHaptic {#playhaptic .function}

``` funcdef
PlayHaptic(handle, amplitude)
```

Arguments\
[handle]{.argname} [(string)]{.argtype} -- Handle of haptic effect\
[amplitude]{.argname} [(number)]{.argtype} -- Amplidute used for
calculation of Haptic effect.\

Return value\
[none]{.retname}

If Haptic already playing, restarts it.

```lua
-- Rumble with gun Haptic effect
function init()
    haptic_effect = LoadHaptic("haptic/gun_fire.xml")
end

function tick()
    if trigHaptic then
        PlayHaptic(haptic_effect, 1)
    end
end
```

------------------------------------------------------------------------

[]{#PlayHapticDirectional}

### PlayHapticDirectional {#playhapticdirectional .function}

``` funcdef
PlayHapticDirectional(handle, direction, amplitude)
```

Arguments\
[handle]{.argname} [(string)]{.argtype} -- Handle of haptic effect\
[direction]{.argname} [(TVec)]{.argtype} -- Direction in which effect
must be played\
[amplitude]{.argname} [(number)]{.argtype} -- Amplidute used for
calculation of Haptic effect.\

Return value\
[none]{.retname}

If Haptic already playing, restarts it.

```lua
-- Rumble with gun Haptic effect
local haptic_effect
function init()
    haptic_effect = LoadHaptic("haptic/gun_fire.xml")
end

function tick()
    if InputPressed("interact") then
        PlayHapticDirectional(haptic_effect, Vec(-1, 0, 0), 1)
    end
end
```

------------------------------------------------------------------------

[]{#HapticIsPlaying}

### HapticIsPlaying {#hapticisplaying .function}

``` funcdef
flag = HapticIsPlaying(handle)
```

Arguments\
[handle]{.argname} [(string)]{.argtype} -- Handle of haptic effect\

Return value\
[flag]{.retname} [(boolean)]{.argtype} -- is current Haptic playing or
not\

```lua
-- Rumble infinitely
local haptic_effect
function init()
    haptic_effect = LoadHaptic("haptic/gun_fire.xml")
end

function tick()
    if not HapticIsPlaying(haptic_effect) then
        PlayHaptic(haptic_effect, 1)
    end
end
```

------------------------------------------------------------------------

[]{#SetToolHaptic}

### SetToolHaptic {#settoolhaptic .function}

``` funcdef
SetToolHaptic(id, handle, [amplitude])
```

Arguments\
[id]{.argname} [(string)]{.argtype} -- Tool unique identifier\
[handle]{.argname} [(string)]{.argtype} -- Handle of haptic effect\
[amplitude]{.argname} [(number, optional)]{.argtype} -- Amplitude
multiplier. Default (1.0)\

Return value\
[none]{.retname}

Register haptic as a \"Tool haptic\" for custom tools. \"Tool haptic\"
will be played on repeat while this tool is active. Also it can be used
for Active Triggers of DualSense controller

```lua
function init()
    RegisterTool("minigun", "loc@MINIGUN", "MOD/vox/minigun.vox")
    toolHaptic = LoadHaptic("MOD/haptic/tool.xml")
    SetToolHaptic("minigun", toolHaptic) 
end
```

------------------------------------------------------------------------

[]{#StopHaptic}

### StopHaptic {#stophaptic .function}

``` funcdef
StopHaptic(handle)
```

Arguments\
[handle]{.argname} [(string)]{.argtype} -- Handle of haptic effect\

Return value\
[none]{.retname}

```lua
-- Rumble infinitely
local haptic_effect
function init()
    haptic_effect = LoadHaptic("haptic/gun_fire.xml")
end

function tick()
    if InputDown("interact") then
        StopHaptic(haptic_effect)
    elseif not HapticIsPlaying(haptic_effect) then
        PlayHaptic(haptic_effect, 1)
    end
end
```

------------------------------------------------------------------------

[]{#SetVehicleHealth}

### SetVehicleHealth {#setvehiclehealth .function}

``` funcdef
SetVehicleHealth(vehicle, health)
```

Arguments\
[vehicle]{.argname} [(number)]{.argtype} -- Vehicle handle\
[health]{.argname} [(number)]{.argtype} -- Set vehicle health (between
zero and one)\

Return value\
[none]{.retname}

Works only for vehicles with \'customhealth\' tag. \'customhealth\'
disables the common vehicles damage system. So this function needed for
custom vehicle damage systems.

```lua
function tick()
    if InputPressed("usetool") then
        SetVehicleHealth(FindVehicle("car", true), 0.0)
    end
end
```

------------------------------------------------------------------------

[]{#QueryRaycastWater}

### QueryRaycastWater {#queryraycastwater .function}

``` funcdef
hit, dist, hitPos = QueryRaycastWater(origin, direction, maxDist)
```

Arguments\
[origin]{.argname} [(TVec)]{.argtype} -- Raycast origin as world space
vector\
[direction]{.argname} [(TVec)]{.argtype} -- Unit length raycast
direction as world space vector\
[maxDist]{.argname} [(number)]{.argtype} -- Raycast maximum distance.
Keep this as low as possible for good performance.\

Return value\
[hit]{.retname} [(boolean)]{.argtype} -- True if raycast hit something\
[dist]{.retname} [(number)]{.argtype} -- Hit distance from origin\
[hitPos]{.retname} [(TVec)]{.argtype} -- Hit point as world space
vector\

This will perform a raycast query looking for water.

```lua
function init()
    --Raycast from a high point straight downwards, looking for water
    local hit, d = QueryRaycast(Vec(0, 100, 0), Vec(0, -1, 0), 100)
    if hit then
        DebugPrint(d)
    end
end
```

------------------------------------------------------------------------

[]{#AddHeat}

### AddHeat {#addheat .function}

``` funcdef
AddHeat(shape, pos, amount)
```

Arguments\
[shape]{.argname} [(number)]{.argtype} -- Shape handle\
[pos]{.argname} [(TVec)]{.argtype} -- World space point as vector\
[amount]{.argname} [(number)]{.argtype} -- amount of heat\

Return value\
[none]{.retname}

Adds heat to shape. It works similar to blowtorch. As soon as the heat
of the voxel reaches a critical value, it destroys and can ignite the
surrounding voxels.

```lua
function tick(dt)
    if InputDown("usetool") then
        local playerCameraTransform = GetPlayerCameraTransform()
        local dir = TransformToParentVec(playerCameraTransform, Vec(0, 0, -1))

        -- Cast ray out of player camera and add heat to shape if we can find one
        local hit, dist, normal, shape = QueryRaycast(playerCameraTransform.pos, dir, 50)

        if hit then
            local hitPos = VecAdd(playerCameraTransform.pos, VecScale(dir, dist))
            AddHeat(shape, hitPos, 2 * dt)
        end

        DrawLine(VecAdd(playerCameraTransform.pos, Vec(0.5, 0, 0)), VecAdd(playerCameraTransform.pos, VecScale(dir, dist)), 1, 0, 0, 1)
    end
end
```

------------------------------------------------------------------------

[]{#GetGravity}

### GetGravity {#getgravity .function}

``` funcdef
vector = GetGravity()
```

Arguments\
[none]{.argname}

Return value\
[vector]{.retname} [(TVec)]{.argtype} -- Gravity vector\

Returns the gravity value on the scene.

```lua
function tick()
    DebugPrint(VecStr(GetGravity()))
end
```

------------------------------------------------------------------------

[]{#SetGravity}

### SetGravity {#setgravity .function}

``` funcdef
SetGravity(vec)
```

Arguments\
[vec]{.argname} [(TVec)]{.argtype} -- Gravity vector\

Return value\
[none]{.retname}

Sets the gravity value on the scene. When the scene restarts, it resets
to the default value (0, -10, 0).

```lua
local isMoonGravityEnabled = false

function tick()
    if InputPressed("g") then
        isMoonGravityEnabled = not isMoonGravityEnabled
        if isMoonGravityEnabled then
            SetGravity(Vec(0, -1.6, 0))
        else
            SetGravity(Vec(0, -10.0, 0))
        end
    end
end
```

------------------------------------------------------------------------

[]{#SetPlayerOrientation}

### SetPlayerOrientation {#setplayerorientation .function}

``` funcdef
SetPlayerOrientation(orientation)
```

Arguments\
[orientation]{.argname} [(Quat)]{.argtype} -- Base orientation\

Return value\
[none]{.retname}

Sets the base orientation when gravity is disabled with SetGravity. This
will determine what direction is \"up\", \"right\" and \"forward\" as
gravity is completely turned off.

```lua
function tick()
    SetGravity(Vec(0, 0, 0))

    -- Turn player upside-down.
    local base = QuatAxisAngle(Vec(1,0,0), 180)
    SetPlayerOrientation(base)
end
```

------------------------------------------------------------------------

[]{#GetPlayerOrientation}

### GetPlayerOrientation {#getplayerorientation .function}

``` funcdef
orientation = GetPlayerOrientation()
```

Arguments\
[none]{.argname}

Return value\
[orientation]{.retname} [(TQuat)]{.argtype} -- Player base orientation\

Gets the base orientation of the player. This can be used to retrieve
the base orientation of the player when using a custom gravity vector.

```lua
function tick(dt)
    SetGravity(Vec(0, 0, 0))
    -- Spin the player if using zero gravity 
    local base = QuatRotateQuat(GetPlayerOrientation(), QuatAxisAngle(Vec(1,0,0), dt))
    SetPlayerOrientation(base)
end
```

------------------------------------------------------------------------

[]{#GetPlayerUp}

### GetPlayerUp {#getplayerup .function}

``` funcdef
up = GetPlayerUp()
```

Arguments\
[none]{.argname}

Return value\
[up]{.retname} [(TVec)]{.argtype} -- Player up vector\

Returns the current \"up\" vector derived from the player\'s base
orientation. This can be used to retrieve the player\'s up vector when
using a custom gravity vector.

```lua
function tick(dt)
    local up = GetPlayerUp()
end
```

------------------------------------------------------------------------

[]{#GetFps}

### GetFps {#getfps .function}

``` funcdef
fps = GetFps()
```

Arguments\
[none]{.argname}

Return value\
[fps]{.retname} [(number)]{.argtype} -- Frames per second\

Returns the fps value based on general game timestep. It doesn\'t depend
on whether it is called from tick or update.

```lua
function tick()
    DebugWatch("fps", GetFps())
end
```

------------------------------------------------------------------------

[]{#UiMakeInteractive}

### UiMakeInteractive {#uimakeinteractive .function}

``` funcdef
UiMakeInteractive()
```

Arguments\
[none]{.argname}

Return value\
[none]{.retname}

Calling this function will disable game input, bring up the mouse
pointer and allow Ui interaction with the calling script without pausing
the game. This can be useful to make interactive user interfaces from
scripts while the game is running. Call this continuously every frame as
long as Ui interaction is desired.

```lua
UiMakeInteractive()
```

------------------------------------------------------------------------

[]{#UiPush}

### UiPush {#uipush .function}

``` funcdef
UiPush()
```

Arguments\
[none]{.argname}

Return value\
[none]{.retname}

Push state onto stack. This is used in combination with UiPop to
remember a state and restore to that state later.

```lua
UiColor(1,0,0)
UiText("Red")
UiPush()
    UiColor(0,1,0)
    UiText("Green")
UiPop()
UiText("Red")
```

------------------------------------------------------------------------

[]{#UiPop}

### UiPop {#uipop .function}

``` funcdef
UiPop()
```

Arguments\
[none]{.argname}

Return value\
[none]{.retname}

Pop state from stack and make it the current one. This is used in
combination with UiPush to remember a previous state and go back to it
later.

```lua
UiColor(1,0,0)
UiText("Red")
UiPush()
    UiColor(0,1,0)
    UiText("Green")
UiPop()
UiText("Red")
```

------------------------------------------------------------------------

[]{#UiWidth}

### UiWidth {#uiwidth .function}

``` funcdef
width = UiWidth()
```

Arguments\
[none]{.argname}

Return value\
[width]{.retname} [(number)]{.argtype} -- Width of draw context\

```lua
local w = UiWidth()
```

------------------------------------------------------------------------

[]{#UiHeight}

### UiHeight {#uiheight .function}

``` funcdef
height = UiHeight()
```

Arguments\
[none]{.argname}

Return value\
[height]{.retname} [(number)]{.argtype} -- Height of draw context\

```lua
local h = UiHeight()
```

------------------------------------------------------------------------

[]{#UiCenter}

### UiCenter {#uicenter .function}

``` funcdef
center = UiCenter()
```

Arguments\
[none]{.argname}

Return value\
[center]{.retname} [(number)]{.argtype} -- Half width of draw context\

```lua
local c = UiCenter()
--Same as 
local c = UiWidth()/2
```

------------------------------------------------------------------------

[]{#UiMiddle}

### UiMiddle {#uimiddle .function}

``` funcdef
middle = UiMiddle()
```

Arguments\
[none]{.argname}

Return value\
[middle]{.retname} [(number)]{.argtype} -- Half height of draw context\

```lua
local m = UiMiddle()
--Same as
local m = UiHeight()/2
```

------------------------------------------------------------------------

[]{#UiColor}

### UiColor {#uicolor .function}

``` funcdef
UiColor(r, g, b, [a])
```

Arguments\
[r]{.argname} [(number)]{.argtype} -- Red channel\
[g]{.argname} [(number)]{.argtype} -- Green channel\
[b]{.argname} [(number)]{.argtype} -- Blue channel\
[a]{.argname} [(number, optional)]{.argtype} -- Alpha channel. Default
1.0\

Return value\
[none]{.retname}

```lua
--Set color yellow
UiColor(1,1,0)
```

------------------------------------------------------------------------

[]{#UiColorFilter}

### UiColorFilter {#uicolorfilter .function}

``` funcdef
UiColorFilter(r, g, b, [a])
```

Arguments\
[r]{.argname} [(number)]{.argtype} -- Red channel\
[g]{.argname} [(number)]{.argtype} -- Green channel\
[b]{.argname} [(number)]{.argtype} -- Blue channel\
[a]{.argname} [(number, optional)]{.argtype} -- Alpha channel. Default
1.0\

Return value\
[none]{.retname}

Color filter, multiplied to all future colors in this scope

```lua
UiPush()
    --Draw menu in transparent, yellow color tint
    UiColorFilter(1, 1, 0, 0.5)
    drawMenu()
UiPop()
```

------------------------------------------------------------------------

[]{#UiResetColor}

### UiResetColor {#uiresetcolor .function}

``` funcdef
UiResetColor()
```

Arguments\
[none]{.argname}

Return value\
[none]{.retname}

Resets the ui context\'s color, outline color, shadow color, color
filter to default values.\
Remarkable that if some component, lets call it \"parent\", wants to
hide everyting in it\'s scope,\
it is possible that a child which uses UiResetColor would ignore the
hide logic, if its implemented via changing opacity.

```lua
function draw()
    UiPush()
        UiFont("bold.ttf", 44)
        UiTranslate(100, 100)
        UiColor(1, 0, 0)
        UiText("A")
        UiTranslate(100, 0)
        UiResetColor()
        UiText("B")
    UiPop()
end
```

------------------------------------------------------------------------

[]{#UiTranslate}

### UiTranslate {#uitranslate .function}

``` funcdef
UiTranslate(x, y)
```

Arguments\
[x]{.argname} [(number)]{.argtype} -- X component\
[y]{.argname} [(number)]{.argtype} -- Y component\

Return value\
[none]{.retname}

Translate cursor

```lua
UiPush()
    UiTranslate(100, 0)
    UiText("Indented")
UiPop()
```

------------------------------------------------------------------------

[]{#UiRotate}

### UiRotate {#uirotate .function}

``` funcdef
UiRotate(angle)
```

Arguments\
[angle]{.argname} [(number)]{.argtype} -- Angle in degrees, counter
clockwise\

Return value\
[none]{.retname}

Rotate cursor

```lua
UiPush()
    UiRotate(45)
    UiText("Rotated")
UiPop()
```

------------------------------------------------------------------------

[]{#UiScale}

### UiScale {#uiscale .function}

``` funcdef
UiScale(x, [y])
```

Arguments\
[x]{.argname} [(number)]{.argtype} -- X component\
[y]{.argname} [(number, optional)]{.argtype} -- Y component. Default
value is x.\

Return value\
[none]{.retname}

Scale cursor either uniformly (one argument) or non-uniformly (two
arguments)

```lua
UiPush()
    UiScale(2)
    UiText("Double size")
UiPop()
```

------------------------------------------------------------------------

[]{#UiGetScale}

### UiGetScale {#uigetscale .function}

``` funcdef
x, y = UiGetScale()
```

Arguments\
[none]{.argname}

Return value\
[x]{.retname} [(number)]{.argtype} -- X scale\
[y]{.retname} [(number)]{.argtype} -- Y scale\

Returns the ui context\'s scale

```lua
function draw()
    UiPush()
        UiScale(2)
        x, y = UiGetScale()
        DebugPrint(x .. " " .. y)
    UiPop()
end
```

------------------------------------------------------------------------

[]{#UiClipRect}

### UiClipRect {#uicliprect .function}

``` funcdef
UiClipRect(width, height, [inherit])
```

Arguments\
[width]{.argname} [(number)]{.argtype} -- Rect width\
[height]{.argname} [(number)]{.argtype} -- Rect height\
[inherit]{.argname} [(boolean, optional)]{.argtype} -- True if must
include the parent\'s clip rect\

Return value\
[none]{.retname}

Specifies the area beyond which ui is cut off and not drawn.\
If inherit is true the resulting rect clip will be equal to the
overlapped area of both rects

```lua
function draw()
    UiTranslate(200, 200)
    UiPush()
        UiClipRect(100, 50)
        UiTranslate(5, 15)
        UiFont("regular.ttf", 50)
        UiText("Text")
    UiPop()
end

```

------------------------------------------------------------------------

[]{#UiWindow}

### UiWindow {#uiwindow .function}

``` funcdef
UiWindow(width, height, [clip], [inherit])
```

Arguments\
[width]{.argname} [(number)]{.argtype} -- Window width\
[height]{.argname} [(number)]{.argtype} -- Window height\
[clip]{.argname} [(boolean, optional)]{.argtype} -- Clip content outside
window. Default is false.\
[inherit]{.argname} [(boolean, optional)]{.argtype} -- Inherit current
clip region (for nested clip regions)\

Return value\
[none]{.retname}

Set up new bounds. Calls to UiWidth, UiHeight, UiCenter and UiMiddle
will operate in the context of the window size. If clip is set to true,
contents of window will be clipped to bounds (only works properly for
non-rotated windows).

```lua
UiPush()
    UiWindow(400, 200)
    local w = UiWidth()
    --w is now 400
UiPop()
```

------------------------------------------------------------------------

[]{#UiGetCurrentWindow}

### UiGetCurrentWindow {#uigetcurrentwindow .function}

``` funcdef
tl_x, tl_y, br_x, br_y = UiGetCurrentWindow()
```

Arguments\
[none]{.argname}

Return value\
[tl_x]{.retname} [(number)]{.argtype} -- Top left x\
[tl_y]{.retname} [(number)]{.argtype} -- Top left y\
[br_x]{.retname} [(number)]{.argtype} -- Bottom right x\
[br_y]{.retname} [(number)]{.argtype} -- Bottom right y\

Returns the top left & bottom right points of the current window

```lua
function draw()
    UiPush()
        UiWindow(400, 200)
        tl_x, tl_y, br_x, br_y = UiGetCurrentWindow()
        -- do something
    UiPop()
end
```

------------------------------------------------------------------------

[]{#UiIsInCurrentWindow}

### UiIsInCurrentWindow {#uiisincurrentwindow .function}

``` funcdef
val = UiIsInCurrentWindow(x, y)
```

Arguments\
[x]{.argname} [(number)]{.argtype} -- X\
[y]{.argname} [(number)]{.argtype} -- Y\

Return value\
[val]{.retname} [(boolean)]{.argtype} -- True if\

True if the specified point is within the boundaries of the current
window

```lua
function draw()
    UiPush()
        UiWindow(400, 200)
        DebugPrint("point 1: " .. tostring(UiIsInCurrentWindow(200, 100)))
        DebugPrint("point 2: " .. tostring(UiIsInCurrentWindow(450, 100)))
    UiPop()
end
```

------------------------------------------------------------------------

[]{#UiIsRectFullyClipped}

### UiIsRectFullyClipped {#uiisrectfullyclipped .function}

``` funcdef
value = UiIsRectFullyClipped(w, h)
```

Arguments\
[w]{.argname} [(number)]{.argtype} -- Width\
[h]{.argname} [(number)]{.argtype} -- Height\

Return value\
[value]{.retname} [(boolean)]{.argtype} -- True if rect is fully
clipped\

Checks whether a rectangle with width w and height h is completely
clipped

```lua
function draw()
    UiTranslate(200, 200)
    UiPush()
        UiClipRect(150, 150)
        UiColor(1.0, 1.0, 1.0, 0.15)
        UiRect(150, 150)
        UiRect(w, h)
        UiTranslate(-50, 30)
        UiColor(1, 0, 0)
        local w, h = 100, 100
        UiRect(w, h)
        DebugPrint(UiIsRectFullyClipped(w, h))
    UiPop()
end
```

------------------------------------------------------------------------

[]{#UiIsInClipRegion}

### UiIsInClipRegion {#uiisinclipregion .function}

``` funcdef
value = UiIsInClipRegion(x, y)
```

Arguments\
[x]{.argname} [(number)]{.argtype} -- X\
[y]{.argname} [(number)]{.argtype} -- Y\

Return value\
[value]{.retname} [(boolean)]{.argtype} -- True if point is in clip
region\

Checks whether a point is inside the clip region

```lua
function draw()
    UiPush()
        UiTranslate(200, 200)
        UiClipRect(150, 150)
        UiColor(1.0, 1.0, 1.0, 0.15)
        UiRect(150, 150)
        UiRect(w, h)

        DebugPrint("point 1: " .. tostring(UiIsInClipRegion(250, 250)))
        DebugPrint("point 2: " .. tostring(UiIsInClipRegion(350, 250)))
    UiPop()
end
```

------------------------------------------------------------------------

[]{#UiIsFullyClipped}

### UiIsFullyClipped {#uiisfullyclipped .function}

``` funcdef
value = UiIsFullyClipped(w, h)
```

Arguments\
[w]{.argname} [(number)]{.argtype} -- Width\
[h]{.argname} [(number)]{.argtype} -- Height\

Return value\
[value]{.retname} [(boolean)]{.argtype} -- True if rect is not
overlapping clip region\

Checks whether a rect is overlap the clip region

```lua
function draw()
    UiPush()
        UiTranslate(200, 200)
        UiClipRect(150, 150)
        UiColor(1.0, 1.0, 1.0, 0.15)
        UiRect(150, 150)
        UiRect(w, h)

        DebugPrint("rect 1: " .. tostring(UiIsFullyClipped(200, 200)))
        UiTranslate(200, 0)
        DebugPrint("rect 2: " .. tostring(UiIsFullyClipped(200, 200)))
    UiPop()
end
```

------------------------------------------------------------------------

[]{#UiSafeMargins}

### UiSafeMargins {#uisafemargins .function}

``` funcdef
x0, y0, x1, y1 = UiSafeMargins()
```

Arguments\
[none]{.argname}

Return value\
[x0]{.retname} [(number)]{.argtype} -- Left\
[y0]{.retname} [(number)]{.argtype} -- Top\
[x1]{.retname} [(number)]{.argtype} -- Right\
[y1]{.retname} [(number)]{.argtype} -- Bottom\

Return a safe drawing area that will always be visible regardless of
display aspect ratio. The safe drawing area will always be 1920 by 1080
in size. This is useful for setting up a fixed size UI.

```lua
function draw()
    local x0, y0, x1, y1 = UiSafeMargins()
    UiTranslate(x0, y0)
    UiWindow(x1-x0, y1-y0, true)
    --The drawing area is now 1920 by 1080 in the center of screen
    drawMenu()
end
```

------------------------------------------------------------------------

[]{#UiCanvasSize}

### UiCanvasSize {#uicanvassize .function}

``` funcdef
value = UiCanvasSize()
```

Arguments\
[none]{.argname}

Return value\
[value]{.retname} [(table)]{.argtype} -- Canvas width and height\

Returns the canvas size. \"Canvas\" means a coordinate space in which UI
is drawn

```lua
function draw()
    UiPush()
        local canvas = UiCanvasSize()
        UiWindow(canvas.w, canvas.h)
        --[[ 
            ...
        ]]
    UiPop()
end
```

------------------------------------------------------------------------

[]{#UiAlign}

### UiAlign {#uialign .function}

``` funcdef
UiAlign(alignment)
```

Arguments\
[alignment]{.argname} [(string)]{.argtype} -- Alignment keywords\

Return value\
[none]{.retname}

The alignment determines how content is aligned with respect to the
cursor.

 Alignment 

 Description

left

Horizontally align to the left

right

Horizontally align to the right

center

Horizontally align to the center

top

Vertically align to the top

bottom

Veritcally align to the bottom

middle

Vertically align to the middle

Alignment can contain combinations of these, for instance: \"center
middle\", \"left top\", \"center top\", etc. If horizontal or vertical
alginment is omitted it will depend on the element drawn. Text, for
instance has default vertical alignment at baseline.

```lua
UiAlign("left")
UiText("Aligned left at baseline")

UiAlign("center middle")
UiText("Fully centered")
```

------------------------------------------------------------------------

[]{#UiTextAlignment}

### UiTextAlignment {#uitextalignment .function}

``` funcdef
UiTextAlignment(alignment)
```

Arguments\
[alignment]{.argname} [(string)]{.argtype} -- Alignment keyword\

Return value\
[none]{.retname}

The alignment determines how text is aligned with respect to the cursor
and wrap width.

 Alignment 

 Description

left

Horizontally align to the left

right

Horizontally align to the right

center

Horizontally align to the center

Alignment can contain either \"center\", \"left\", or \"right\"

```lua
UiTextAlignment("left")
UiText("Aligned left at baseline")

UiTextAlignment("center")
UiText("Centered")
```

------------------------------------------------------------------------

[]{#UiModalBegin}

### UiModalBegin {#uimodalbegin .function}

``` funcdef
UiModalBegin([force])
```

Arguments\
[force]{.argname} [(boolean, optional)]{.argtype} -- Pass true if you
need to increase the priority of this modal in the context\

Return value\
[none]{.retname}

Disable input for everything, except what\'s between UiModalBegin and
UiModalEnd (or if modal state is popped)

```lua
UiModalBegin()
if UiTextButton("Okay") then
    --All other interactive ui elements except this one are disabled
end
UiModalEnd()

--This is also okay
UiPush()
    UiModalBegin()
    if UiTextButton("Okay") then
        --All other interactive ui elements except this one are disabled
    end
UiPop()
--No longer modal
```

------------------------------------------------------------------------

[]{#UiModalEnd}

### UiModalEnd {#uimodalend .function}

``` funcdef
UiModalEnd()
```

Arguments\
[none]{.argname}

Return value\
[none]{.retname}

Disable input for everything, except what\'s between UiModalBegin and
UiModalEnd Calling this function is optional. Modality is part of the
current state and will be lost if modal state is popped.

```lua
UiModalBegin()
if UiTextButton("Okay") then
    --All other interactive ui elements except this one are disabled
end
UiModalEnd()
```

------------------------------------------------------------------------

[]{#UiDisableInput}

### UiDisableInput {#uidisableinput .function}

``` funcdef
UiDisableInput()
```

Arguments\
[none]{.argname}

Return value\
[none]{.retname}

Disable input

```lua
UiPush()
    UiDisableInput()
    if UiTextButton("Okay") then
        --Will never happen
    end
UiPop()
```

------------------------------------------------------------------------

[]{#UiEnableInput}

### UiEnableInput {#uienableinput .function}

``` funcdef
UiEnableInput()
```

Arguments\
[none]{.argname}

Return value\
[none]{.retname}

Enable input that has been previously disabled

```lua
UiDisableInput()
if UiTextButton("Okay") then
    --Will never happen
end

UiEnableInput()
if UiTextButton("Okay") then
    --This can happen
end
```

------------------------------------------------------------------------

[]{#UiReceivesInput}

### UiReceivesInput {#uireceivesinput .function}

``` funcdef
receives = UiReceivesInput()
```

Arguments\
[none]{.argname}

Return value\
[receives]{.retname} [(boolean)]{.argtype} -- True if current context
receives input\

This function will check current state receives input. This is the case
if input is not explicitly disabled with (with UiDisableInput) and no
other state is currently modal (with UiModalBegin). Input functions and
UI elements already do this check internally, but it can sometimes be
useful to read the input state manually to trigger things in the UI.

```lua
if UiReceivesInput() then
    highlightItemAtMousePointer()
end
```

------------------------------------------------------------------------

[]{#UiGetMousePos}

### UiGetMousePos {#uigetmousepos .function}

``` funcdef
x, y = UiGetMousePos()
```

Arguments\
[none]{.argname}

Return value\
[x]{.retname} [(number)]{.argtype} -- X coordinate\
[y]{.retname} [(number)]{.argtype} -- Y coordinate\

Get mouse pointer position relative to the cursor

```lua
local x, y = UiGetMousePos()
```

------------------------------------------------------------------------

[]{#UiGetCanvasMousePos}

### UiGetCanvasMousePos {#uigetcanvasmousepos .function}

``` funcdef
x, y = UiGetCanvasMousePos()
```

Arguments\
[none]{.argname}

Return value\
[x]{.retname} [(number)]{.argtype} -- X coordinate\
[y]{.retname} [(number)]{.argtype} -- Y coordinate\

Returns position of mouse cursor in UI canvas space.\
The size of the canvas depends on the aspect ratio. For example, for
16:9, the maximum value will be 1920x1080, and for 16:10, it will be
1920x1200

```lua
function draw()
    local x, y = UiGetCanvasMousePos()
    DebugPrint("x :" .. x .. " y:" .. y)
end
```

------------------------------------------------------------------------

[]{#UiIsMouseInRect}

### UiIsMouseInRect {#uiismouseinrect .function}

``` funcdef
inside = UiIsMouseInRect(w, h)
```

Arguments\
[w]{.argname} [(number)]{.argtype} -- Width\
[h]{.argname} [(number)]{.argtype} -- Height\

Return value\
[inside]{.retname} [(boolean)]{.argtype} -- True if mouse pointer is
within rectangle\

Check if mouse pointer is within rectangle. Note that this function
respects alignment.

```lua
if UiIsMouseInRect(100, 100) then
    -- mouse pointer is in rectangle
end
```

------------------------------------------------------------------------

[]{#UiWorldToPixel}

### UiWorldToPixel {#uiworldtopixel .function}

``` funcdef
x, y, distance = UiWorldToPixel(point)
```

Arguments\
[point]{.argname} [(TVec)]{.argtype} -- 3D world position as vector\

Return value\
[x]{.retname} [(number)]{.argtype} -- X coordinate\
[y]{.retname} [(number)]{.argtype} -- Y coordinate\
[distance]{.retname} [(number)]{.argtype} -- Distance to point\

Convert world space position to user interface X and Y coordinate
relative to the cursor. The distance is in meters and positive if in
front of camera, negative otherwise.

```lua
local x, y, dist = UiWorldToPixel(point)
if dist > 0 then
UiTranslate(x, y)
UiText("Label")
end
```

------------------------------------------------------------------------

[]{#UiPixelToWorld}

### UiPixelToWorld {#uipixeltoworld .function}

``` funcdef
direction = UiPixelToWorld(x, y)
```

Arguments\
[x]{.argname} [(number)]{.argtype} -- X coordinate\
[y]{.argname} [(number)]{.argtype} -- Y coordinate\

Return value\
[direction]{.retname} [(TVec)]{.argtype} -- 3D world direction as
vector\

Convert X and Y UI coordinate to a world direction, as seen from current
camera. This can be used to raycast into the scene from the mouse
pointer position.

```lua
UiMakeInteractive()
local x, y = UiGetMousePos()
local dir = UiPixelToWorld(x, y)
local pos = GetCameraTransform().pos
local hit, dist = QueryRaycast(pos, dir, 100)
if hit then
    DebugPrint("hit distance: " .. dist)
end
```

------------------------------------------------------------------------

[]{#UiGetCursorPos}

### UiGetCursorPos {#uigetcursorpos .function}

``` funcdef
UiGetCursorPos()
```

Arguments\
[none]{.argname}

Return value\
[none]{.retname}

Returns the ui cursor\'s postion

```lua
function draw()
    UiTranslate(100, 50)
    x, y = UiGetCursorPos()
    DebugPrint("x: " .. x .. "; y: " .. y)
end
```

------------------------------------------------------------------------

[]{#UiBlur}

### UiBlur {#uiblur .function}

``` funcdef
UiBlur(amount)
```

Arguments\
[amount]{.argname} [(number)]{.argtype} -- Blur amount (0.0 to 1.0)\

Return value\
[none]{.retname}

Perform a gaussian blur on current screen content

```lua
UiBlur(1.0)
drawMenu()
```

------------------------------------------------------------------------

[]{#UiFont}

### UiFont {#uifont .function}

``` funcdef
UiFont(path, size)
```

Arguments\
[path]{.argname} [(string)]{.argtype} -- Path to TTF font file\
[size]{.argname} [(number)]{.argtype} -- Font size (10 to 100)\

Return value\
[none]{.retname}

```lua
UiFont("bold.ttf", 24)
UiText("Hello")
```

------------------------------------------------------------------------

[]{#UiFontHeight}

### UiFontHeight {#uifontheight .function}

``` funcdef
size = UiFontHeight()
```

Arguments\
[none]{.argname}

Return value\
[size]{.retname} [(number)]{.argtype} -- Font size\

```lua
local h = UiFontHeight()
```

------------------------------------------------------------------------

[]{#UiText}

### UiText {#uitext .function}

``` funcdef
w, h, x, y, linkId = UiText(text, [move], [maxChars])
```

Arguments\
[text]{.argname} [(string)]{.argtype} -- Print text at cursor location\
[move]{.argname} [(boolean, optional)]{.argtype} -- Automatically move
cursor vertically. Default false.\
[maxChars]{.argname} [(number, optional)]{.argtype} -- Maximum amount of
characters. Default 100000.\

Return value\
[w]{.retname} [(number)]{.argtype} -- Width of text\
[h]{.retname} [(number)]{.argtype} -- Height of text\
[x]{.retname} [(number)]{.argtype} -- End x-position of text.\
[y]{.retname} [(number)]{.argtype} -- End y-position of text.\
[linkId]{.retname} [(string)]{.argtype} -- Link id of clicked link\

```lua
UiFont("bold.ttf", 24)
UiText("Hello")

...

--Automatically advance cursor
UiText("First line", true)
UiText("Second line", true)



--Using links
UiFont("bold.ttf", 26)
UiTranslate(100,100)
--Using virtual links
link = "[[link;label=loc@UI_TEXT_FREE_ROAM_OPTIONS_LINK_NAME;id=options/game;color=#DDDD7FDD;underline=true]]"
someText = "Some text with a link: " .. link .. " and some more text"

w, h, x, y, linkId = UiText(someText)
if linkId:len() ~= 0 then
    if linkId == "options/game" then
        DebugPrint(linkId.." link clicked")
    elseif linkId == "options/sound" then
        --Do something else
    end
end
UiTranslate(0,50)

--Using game links, id attribute is required, color is optional, same as virtual links
link = "[[game://options;label=loc@UI_TEXT_FREE_ROAM_OPTIONS_LINK_NAME;id=game;color=#DDDD7FDD;underline=false]]"
someText = "Some text with a link: " .. link .. " and some more text"
w, h, x, y, linkId = UiText(someText)
if linkId:len() ~= 0 then
    DebugPrint(linkId.." link clicked")
end
UiTranslate(0,50)

--Using http/s links is also possible, link will be opened in the default browser
link = "[[http://www.example.com;label=loc@SOME_KEY;]]"
someText = "Goto: " .. link
UiText(someText)

```

------------------------------------------------------------------------

[]{#UiTextDisableWildcards}

### UiTextDisableWildcards {#uitextdisablewildcards .function}

``` funcdef
UiTextDisableWildcards(disable)
```

Arguments\
[disable]{.argname} [(boolean)]{.argtype} -- Enable or disable wildcard
\[\[\...\]\] substitution support in UiText\

Return value\
[none]{.retname}

```lua

UiFont("regular.ttf", 30)
UiPush()
    UiTextDisableWildcards(true)
    -- icon won't be embedded here, text will be left as is
    UiText("Text with embedded icon image [[menu:menu_accept;iconsize=42,42]]")
UiPop()

-- embedding works as expected
UiText("Text with embedded icon image [[menu:menu_accept;iconsize=42,42]]")
```

------------------------------------------------------------------------

[]{#UiTextUniformHeight}

### UiTextUniformHeight {#uitextuniformheight .function}

``` funcdef
UiTextUniformHeight(uniform)
```

Arguments\
[uniform]{.argname} [(boolean)]{.argtype} -- Enable or disable fixed
line height for text rendering\

Return value\
[none]{.retname}

This function toggles the use of a fixed line height for text rendering.
When enabled (true), the line height is set to a constant value
determined by the current font metrics, ensuring uniform spacing between
lines of text. This mode is useful for maintaining consistent line
spacing across different text elements, regardless of the specific
characters displayed. When disabled (false), the line height adjusts
dynamically to accommodate the tallest character in each line of text.

```lua
#include "script/common.lua"
enabled = false
group = 1
local desc = {
    {
        {"A mod desc without descenders"},
        {"Author: Abcd"},
        {"Tags: map, spawnable"},
    },
    {
        {"A mod with descenders, like g, j, p, q, y"},
        {"Author: Ggjyq"},
        {"Tags: map, spawnable"},
    },
}
-- Function to draw text with or without uniform line height
local function drawDescriptions()
    UiAlign("top")
    for _, text in ipairs(desc[group]) do
        UiTextUniformHeight(enabled)
        UiText(text[1], true)
    end
end

function draw()
    UiFont("regular.ttf", 22)
    UiTranslate(100, 100)

    UiPush()
        local r,g,b
        if enabled then
            r,g,b = 0,1,0
        else
            r,g,b = 1,0,0
        end
        UiColor(0,0,0)
        UiButtonImageBox("ui/common/box-solid-6.png", 6, 6, r,g,b)
        if UiTextButton("Uniform height "..(enabled and "enabled" or "disabled")) then
            enabled = not enabled
        end
        UiTranslate(0,35)
        if UiTextButton(">") then
            group = clamp(group + 1, 1, #desc)
        end
        UiTranslate(0,35)
        if UiTextButton("<") then
            group = clamp(group - 1, 1, #desc)
        end
    UiPop()
    UiTranslate(0,80)
    drawDescriptions()
end

```

------------------------------------------------------------------------

[]{#UiGetTextSize}

### UiGetTextSize {#uigettextsize .function}

``` funcdef
w, h, x, y = UiGetTextSize(text)
```

Arguments\
[text]{.argname} [(string)]{.argtype} -- A text string\

Return value\
[w]{.retname} [(number)]{.argtype} -- Width of text\
[h]{.retname} [(number)]{.argtype} -- Height of text\
[x]{.retname} [(number)]{.argtype} -- Offset x-component of text AABB\
[y]{.retname} [(number)]{.argtype} -- Offset y-component of text AABB\

```lua

local w, h = UiGetTextSize("Some text")
```

------------------------------------------------------------------------

[]{#UiMeasureText}

### UiMeasureText {#uimeasuretext .function}

``` funcdef
w, h = UiMeasureText(space, text/locale)
```

Arguments\
[space]{.argname} [(number)]{.argtype} -- Space between lines\
[text/locale]{.argname} [(string,)]{.argtype} -- , \... A text strings\

Return value\
[w]{.retname} [(number)]{.argtype} -- Width of biggest line\
[h]{.retname} [(number)]{.argtype} -- Height of all lines combined with
interval\

```lua

local w, h = UiMeasureText(0, "Some text", "loc@key")
```

------------------------------------------------------------------------

[]{#UiGetSymbolsCount}

### UiGetSymbolsCount {#uigetsymbolscount .function}

``` funcdef
count = UiGetSymbolsCount(text)
```

Arguments\
[text]{.argname} [(string)]{.argtype} -- Text\

Return value\
[count]{.retname} [(number)]{.argtype} -- Symbols count\

Returns the symbols count in the specified text.\
This function is intended to property count symbols in UTF 8 encoded
string

```lua
function draw()
    DebugPrint(UiGetSymbolsCount("Hello world!"))
end
```

------------------------------------------------------------------------

[]{#UiTextSymbolsSub}

### UiTextSymbolsSub {#uitextsymbolssub .function}

``` funcdef
substring = UiTextSymbolsSub(text, from, to)
```

Arguments\
[text]{.argname} [(string)]{.argtype} -- Text\
[from]{.argname} [(number)]{.argtype} -- From element index\
[to]{.argname} [(number)]{.argtype} -- To element index\

Return value\
[substring]{.retname} [(string)]{.argtype} -- Substring\

Returns the substring. This function is intended to properly work with
UTF8 encoded strings

```lua
function draw()
    DebugPrint(UiTextSymbolsSub("Hello world", 1, 5))
end
```

------------------------------------------------------------------------

[]{#UiWordWrap}

### UiWordWrap {#uiwordwrap .function}

``` funcdef
UiWordWrap(width)
```

Arguments\
[width]{.argname} [(number)]{.argtype} -- Maximum width of text\

Return value\
[none]{.retname}

```lua
UiWordWrap(200)
UiText("Some really long text that will get wrapped into several lines")
```

------------------------------------------------------------------------

[]{#UiTextLineSpacing}

### UiTextLineSpacing {#uitextlinespacing .function}

``` funcdef
UiTextLineSpacing(value)
```

Arguments\
[value]{.argname} [(number)]{.argtype} -- Text linespacing\

Return value\
[none]{.retname}

Sets the context\'s linespacing value of the text which is drawn using
UiText

```lua
function draw()
    UiTextLineSpacing(10)
    UiWordWrap(200)
    UiText("TEXT TEXT TEXT TEXT TEXT TEXT TEXT TEXT TEXT TEXT TEXT TEXT TEXT")
end
```

------------------------------------------------------------------------

[]{#UiTextOutline}

### UiTextOutline {#uitextoutline .function}

``` funcdef
UiTextOutline(r, g, b, a, [thickness])
```

Arguments\
[r]{.argname} [(number)]{.argtype} -- Red channel\
[g]{.argname} [(number)]{.argtype} -- Green channel\
[b]{.argname} [(number)]{.argtype} -- Blue channel\
[a]{.argname} [(number)]{.argtype} -- Alpha channel\
[thickness]{.argname} [(number, optional)]{.argtype} -- Outline
thickness. Default is 0.1\

Return value\
[none]{.retname}

```lua
--Black outline, standard thickness
UiTextOutline(0,0,0,1)
UiText("Text with outline")
```

------------------------------------------------------------------------

[]{#UiTextShadow}

### UiTextShadow {#uitextshadow .function}

``` funcdef
UiTextShadow(r, g, b, a, [distance], [blur])
```

Arguments\
[r]{.argname} [(number)]{.argtype} -- Red channel\
[g]{.argname} [(number)]{.argtype} -- Green channel\
[b]{.argname} [(number)]{.argtype} -- Blue channel\
[a]{.argname} [(number)]{.argtype} -- Alpha channel\
[distance]{.argname} [(number, optional)]{.argtype} -- Shadow distance.
Default is 1.0\
[blur]{.argname} [(number, optional)]{.argtype} -- Shadow blur. Default
is 0.5\

Return value\
[none]{.retname}

```lua
--Black drop shadow, 50% transparent, distance 2
UiTextShadow(0, 0, 0, 0.5, 2.0)
UiText("Text with drop shadow")
```

------------------------------------------------------------------------

[]{#UiRect}

### UiRect {#uirect .function}

``` funcdef
UiRect(w, h)
```

Arguments\
[w]{.argname} [(number)]{.argtype} -- Width\
[h]{.argname} [(number)]{.argtype} -- Height\

Return value\
[none]{.retname}

Draw solid rectangle at cursor position

```lua
--Draw full-screen black rectangle
UiColor(0, 0, 0)
UiRect(UiWidth(), UiHeight())

--Draw smaller, red, rotating rectangle in center of screen
UiPush()
    UiColor(1, 0, 0)
    UiTranslate(UiCenter(), UiMiddle())
    UiRotate(GetTime())
    UiAlign("center middle")
    UiRect(100, 100)
UiPop()
```

------------------------------------------------------------------------

[]{#UiRectOutline}

### UiRectOutline {#uirectoutline .function}

``` funcdef
UiRectOutline(width, height, thickness)
```

Arguments\
[width]{.argname} [(number)]{.argtype} -- Rectangle width\
[height]{.argname} [(number)]{.argtype} -- Rectangle height\
[thickness]{.argname} [(number)]{.argtype} -- Rectangle outline
thickness\

Return value\
[none]{.retname}

Draw rectangle outline at cursor position

```lua
--Draw a red rotating rectangle outline in center of screen
UiPush()
    UiColor(1, 0, 0)
    UiTranslate(UiCenter(), UiMiddle())
    UiRotate(GetTime())
    UiAlign("center middle")
    UiRectOutline(100, 100, 5)
UiPop()
```

------------------------------------------------------------------------

[]{#UiRoundedRect}

### UiRoundedRect {#uiroundedrect .function}

``` funcdef
UiRoundedRect(width, height, roundingRadius)
```

Arguments\
[width]{.argname} [(number)]{.argtype} -- Rectangle width\
[height]{.argname} [(number)]{.argtype} -- Rectangle height\
[roundingRadius]{.argname} [(number)]{.argtype} -- Round corners radius\

Return value\
[none]{.retname}

Draw a solid rectangle with round corners of specified radius

```lua
UiPush()
    UiColor(1, 0, 0)
    UiTranslate(UiCenter(), UiMiddle())
    UiRotate(GetTime())
    UiAlign("center middle")
    UiRoundedRect(100, 100, 8)
UiPop()
```

------------------------------------------------------------------------

[]{#UiRoundedRectOutline}

### UiRoundedRectOutline {#uiroundedrectoutline .function}

``` funcdef
UiRoundedRectOutline(width, height, roundingRadius, thickness)
```

Arguments\
[width]{.argname} [(number)]{.argtype} -- Rectangle width\
[height]{.argname} [(number)]{.argtype} -- Rectangle height\
[roundingRadius]{.argname} [(number)]{.argtype} -- Round corners radius\
[thickness]{.argname} [(number)]{.argtype} -- Rectangle outline
thickness\

Return value\
[none]{.retname}

Draw rectangle outline with round corners at cursor position

```lua
UiPush()
    UiColor(1, 0, 0)
    UiTranslate(UiCenter(), UiMiddle())
    UiRotate(GetTime())
    UiAlign("center middle")
    UiRoundedRectOutline(100, 100, 20, 5)
UiPop()
```

------------------------------------------------------------------------

[]{#UiCircle}

### UiCircle {#uicircle .function}

``` funcdef
UiCircle(radius)
```

Arguments\
[radius]{.argname} [(number)]{.argtype} -- Circle radius\

Return value\
[none]{.retname}

Draw a solid circle at cursor position

```lua
UiPush()
    UiColor(1, 0, 0)
    UiTranslate(UiCenter(), UiMiddle())
    UiAlign("center middle")
    UiCircle(100)
UiPop()
```

------------------------------------------------------------------------

[]{#UiCircleOutline}

### UiCircleOutline {#uicircleoutline .function}

``` funcdef
UiCircleOutline(radius, thickness)
```

Arguments\
[radius]{.argname} [(number)]{.argtype} -- Circle radius\
[thickness]{.argname} [(number)]{.argtype} -- Circle outline thickness\

Return value\
[none]{.retname}

Draw a circle outline at cursor position

```lua
--Draw a red rotating rectangle outline in center of screen
UiPush()
    UiColor(1, 0, 0)
    UiTranslate(UiCenter(), UiMiddle())
    UiAlign("center middle")
    UiCircleOutline(100, 8)
UiPop()
```

------------------------------------------------------------------------

[]{#UiFillImage}

### UiFillImage {#uifillimage .function}

``` funcdef
UiFillImage(path)
```

Arguments\
[path]{.argname} [(string)]{.argtype} -- Path to image (PNG or JPG
format)\

Return value\
[none]{.retname}

Image to fill for UiRoundedRect, UiCircle

```lua
UiPush()
    UiFillImage("ui/hud/tutorial/plank-lift.jpg")
    UiTranslate(UiCenter(), UiMiddle())
    UiRotate(GetTime())
    UiAlign("center middle")
    UiRoundedRect(100, 100, 8)
UiPop()
```

------------------------------------------------------------------------

[]{#UiImage}

### UiImage {#uiimage .function}

``` funcdef
w, h = UiImage(path, [x0], [y0], [x1], [y1])
```

Arguments\
[path]{.argname} [(string)]{.argtype} -- Path to image (PNG or JPG
format)\
[x0]{.argname} [(number, optional)]{.argtype} -- Lower x coordinate
(default is 0)\
[y0]{.argname} [(number, optional)]{.argtype} -- Lower y coordinate
(default is 0)\
[x1]{.argname} [(number, optional)]{.argtype} -- Upper x coordinate
(default is image width)\
[y1]{.argname} [(number, optional)]{.argtype} -- Upper y coordinate
(default is image height)\

Return value\
[w]{.retname} [(number)]{.argtype} -- Width of drawn image\
[h]{.retname} [(number)]{.argtype} -- Height of drawn image\

Draw image at cursor position. If x0, y0, x1, y1 is provided a cropped
version will be drawn in that coordinate range.

```lua
--Draw image in center of screen
UiPush()
    UiTranslate(UiCenter(), UiMiddle())
    UiAlign("center middle")
    UiImage("test.png")
UiPop()
```

------------------------------------------------------------------------

[]{#UiUnloadImage}

### UiUnloadImage {#uiunloadimage .function}

``` funcdef
UiUnloadImage(path)
```

Arguments\
[path]{.argname} [(string)]{.argtype} -- Path to image (PNG or JPG
format)\

Return value\
[none]{.retname}

Unloads a texture from the memory

```lua
local image = "gfx/cursor.png"

function draw()
    UiTranslate(300, 300)
    if UiHasImage(image) then
        if InputDown("interact") then
            UiUnloadImage("img/background.jpg")
        else
            UiImage(image)
        end
    end
end
```

------------------------------------------------------------------------

[]{#UiHasImage}

### UiHasImage {#uihasimage .function}

``` funcdef
exists = UiHasImage(path)
```

Arguments\
[path]{.argname} [(string)]{.argtype} -- Path to image (PNG or JPG
format)\

Return value\
[exists]{.retname} [(boolean)]{.argtype} -- Does the image exists at the
specified path\

```lua
local image = "gfx/circle.png"

function draw()
    if UiHasImage(image) then
        DebugPrint("image " .. image .. " exists")
    end
end
```

------------------------------------------------------------------------

[]{#UiGetImageSize}

### UiGetImageSize {#uigetimagesize .function}

``` funcdef
w, h = UiGetImageSize(path)
```

Arguments\
[path]{.argname} [(string)]{.argtype} -- Path to image (PNG or JPG
format)\

Return value\
[w]{.retname} [(number)]{.argtype} -- Image width\
[h]{.retname} [(number)]{.argtype} -- Image height\

Get image size

```lua
local w,h = UiGetImageSize("test.png")
```

------------------------------------------------------------------------

[]{#UiImageBox}

### UiImageBox {#uiimagebox .function}

``` funcdef
UiImageBox(path, width, height, [borderWidth], [borderHeight])
```

Arguments\
[path]{.argname} [(string)]{.argtype} -- Path to image (PNG or JPG
format)\
[width]{.argname} [(number)]{.argtype} -- Width\
[height]{.argname} [(number)]{.argtype} -- Height\
[borderWidth]{.argname} [(number, optional)]{.argtype} -- Border width.
Default 0\
[borderHeight]{.argname} [(number, optional)]{.argtype} -- Border
height. Default 0\

Return value\
[none]{.retname}

Draw 9-slice image at cursor position. Width should be at least
2\*borderWidth. Height should be at least 2\*borderHeight.

```lua
UiImageBox("menu-frame.png", 200, 200, 10, 10)
```

------------------------------------------------------------------------

[]{#UiSound}

### UiSound {#uisound .function}

``` funcdef
UiSound(path, [volume], [pitch], [panAzimuth], [panDepth])
```

Arguments\
[path]{.argname} [(string)]{.argtype} -- Path to sound file (OGG
format)\
[volume]{.argname} [(number, optional)]{.argtype} -- Playback volume.
Default 1.0\
[pitch]{.argname} [(number, optional)]{.argtype} -- Playback pitch.
Default 1.0\
[panAzimuth]{.argname} [(number, optional)]{.argtype} -- Playback stereo
panning azimuth (-PI to PI). Default 0.0.\
[panDepth]{.argname} [(number, optional)]{.argtype} -- Playback stereo
panning depth (0.0 to 1.0). Default 1.0.\

Return value\
[none]{.retname}

UI sounds are not affected by acoustics simulation. Use LoadSound /
PlaySound for that.

```lua
UiSound("click.ogg")
```

------------------------------------------------------------------------

[]{#UiSoundLoop}

### UiSoundLoop {#uisoundloop .function}

``` funcdef
UiSoundLoop(path, [volume], [pitch])
```

Arguments\
[path]{.argname} [(string)]{.argtype} -- Path to looping sound file (OGG
format)\
[volume]{.argname} [(number, optional)]{.argtype} -- Playback volume.
Default 1.0\
[pitch]{.argname} [(number, optional)]{.argtype} -- Playback pitch.
Default 1.0\

Return value\
[none]{.retname}

Call this continuously to keep playing loop. UI sounds are not affected
by acoustics simulation. Use LoadLoop / PlayLoop for that.

```lua
if animating then
    UiSoundLoop("screech.ogg")
end
```

------------------------------------------------------------------------

[]{#UiMute}

### UiMute {#uimute .function}

``` funcdef
UiMute(amount, [music])
```

Arguments\
[amount]{.argname} [(number)]{.argtype} -- Mute by this amount (0.0 to
1.0)\
[music]{.argname} [(boolean, optional)]{.argtype} -- Mute music as well\

Return value\
[none]{.retname}

Mute game audio and optionally music for the next frame. Call
continuously to stay muted.

```lua
if menuOpen then
    UiMute(1.0)
end
```

------------------------------------------------------------------------

[]{#UiButtonImageBox}

### UiButtonImageBox {#uibuttonimagebox .function}

``` funcdef
UiButtonImageBox(path, borderWidth, borderHeight, [r], [g], [b], [a])
```

Arguments\
[path]{.argname} [(string)]{.argtype} -- Path to image (PNG or JPG
format)\
[borderWidth]{.argname} [(number)]{.argtype} -- Border width\
[borderHeight]{.argname} [(number)]{.argtype} -- Border height\
[r]{.argname} [(number, optional)]{.argtype} -- Red multiply. Default
1.0\
[g]{.argname} [(number, optional)]{.argtype} -- Green multiply. Default
1.0\
[b]{.argname} [(number, optional)]{.argtype} -- Blue multiply. Default
1.0\
[a]{.argname} [(number, optional)]{.argtype} -- Alpha channel. Default
1.0\

Return value\
[none]{.retname}

Set up 9-slice image to be used as background for buttons.

```lua
UiButtonImageBox("button-9slice.png", 10, 10)
if UiTextButton("Test") then
    ...
end
```

------------------------------------------------------------------------

[]{#UiButtonHoverColor}

### UiButtonHoverColor {#uibuttonhovercolor .function}

``` funcdef
UiButtonHoverColor(r, g, b, [a])
```

Arguments\
[r]{.argname} [(number)]{.argtype} -- Red multiply\
[g]{.argname} [(number)]{.argtype} -- Green multiply\
[b]{.argname} [(number)]{.argtype} -- Blue multiply\
[a]{.argname} [(number, optional)]{.argtype} -- Alpha channel. Default
1.0\

Return value\
[none]{.retname}

Button color filter when hovering mouse pointer.

```lua
UiButtonHoverColor(1, 0, 0)
if UiTextButton("Test") then
    ...
end
```

------------------------------------------------------------------------

[]{#UiButtonPressColor}

### UiButtonPressColor {#uibuttonpresscolor .function}

``` funcdef
UiButtonPressColor(r, g, b, [a])
```

Arguments\
[r]{.argname} [(number)]{.argtype} -- Red multiply\
[g]{.argname} [(number)]{.argtype} -- Green multiply\
[b]{.argname} [(number)]{.argtype} -- Blue multiply\
[a]{.argname} [(number, optional)]{.argtype} -- Alpha channel. Default
1.0\

Return value\
[none]{.retname}

Button color filter when pressing down.

```lua
UiButtonPressColor(0, 1, 0)
if UiTextButton("Test") then
    ...
end
```

------------------------------------------------------------------------

[]{#UiButtonPressDist}

### UiButtonPressDist {#uibuttonpressdist .function}

``` funcdef
UiButtonPressDist(distX, distY)
```

Arguments\
[distX]{.argname} [(number)]{.argtype} -- Press distance along X axis\
[distY]{.argname} [(number)]{.argtype} -- Press distance along Y axis\

Return value\
[none]{.retname}

The button offset when being pressed

```lua
UiButtonPressDistance(4, 4)
if UiTextButton("Test") then
    ...
end
```

------------------------------------------------------------------------

[]{#UiButtonTextHandling}

### UiButtonTextHandling {#uibuttontexthandling .function}

``` funcdef
UiButtonTextHandling(type)
```

Arguments\
[type]{.argname} [(number)]{.argtype} -- One of the enum value\

Return value\
[none]{.retname}

indicating how to handle text overflow. Possible values are: 0 - AsIs,
1 - Slide, 2 - Truncate, 3 - Fade, 4 - Resize (Default)

```lua
UiButtonTextHandling(1)
if UiTextButton("Test") then
    ...
end
```

------------------------------------------------------------------------

[]{#UiTextButton}

### UiTextButton {#uitextbutton .function}

``` funcdef
pressed = UiTextButton(text, [w], [h])
```

Arguments\
[text]{.argname} [(string)]{.argtype} -- Text on button\
[w]{.argname} [(number, optional)]{.argtype} -- Button width\
[h]{.argname} [(number, optional)]{.argtype} -- Button height\

Return value\
[pressed]{.retname} [(boolean)]{.argtype} -- True if user clicked
button\

```lua
if UiTextButton("Test") then
    ...
end
```

------------------------------------------------------------------------

[]{#UiImageButton}

### UiImageButton {#uiimagebutton .function}

``` funcdef
pressed = UiImageButton(path)
```

Arguments\
[path]{.argname} [(string)]{.argtype} -- Image path (PNG or JPG file)\

Return value\
[pressed]{.retname} [(boolean)]{.argtype} -- True if user clicked
button\

```lua
if UiImageButton("image.png") then
    ...
end
```

------------------------------------------------------------------------

[]{#UiBlankButton}

### UiBlankButton {#uiblankbutton .function}

``` funcdef
pressed = UiBlankButton(w, h)
```

Arguments\
[w]{.argname} [(number)]{.argtype} -- Button width\
[h]{.argname} [(number)]{.argtype} -- Button height\

Return value\
[pressed]{.retname} [(boolean)]{.argtype} -- True if user clicked
button\

```lua
if UiBlankButton(30, 30) then
    ...
end
```

------------------------------------------------------------------------

[]{#UiSlider}

### UiSlider {#uislider .function}

``` funcdef
value, done = UiSlider(path, axis, current, min, max)
```

Arguments\
[path]{.argname} [(string)]{.argtype} -- Image path (PNG or JPG file)\
[axis]{.argname} [(string)]{.argtype} -- Drag axis, must be \"x\" or
\"y\"\
[current]{.argname} [(number)]{.argtype} -- Current value\
[min]{.argname} [(number)]{.argtype} -- Minimum value\
[max]{.argname} [(number)]{.argtype} -- Maximum value\

Return value\
[value]{.retname} [(number)]{.argtype} -- New value, same as current if
not changed\
[done]{.retname} [(boolean)]{.argtype} -- True if user is finished
changing (released slider)\

```lua
value = UiSlider("dot.png", "x", value, 0, 100)
```

------------------------------------------------------------------------

[]{#UiSliderHoverColorFilter}

### UiSliderHoverColorFilter {#uisliderhovercolorfilter .function}

``` funcdef
UiSliderHoverColorFilter(r, g, b, a)
```

Arguments\
[r]{.argname} [(number)]{.argtype} -- Red channel\
[g]{.argname} [(number)]{.argtype} -- Green channel\
[b]{.argname} [(number)]{.argtype} -- Blue channel\
[a]{.argname} [(number)]{.argtype} -- Alpha channel\

Return value\
[none]{.retname}

Sets the slider hover color filter

```lua
local slider = 0

function draw()
    local thumbPath = "common/thumb_I218_249_2430_49029.png"
    UiTranslate(200, 200)
    UiPush()
        UiMakeInteractive()
        UiPush()
            UiAlign("top right")
            UiTranslate(40, 3.4)
            UiColor(0.5291666388511658, 0.5291666388511658, 0.5291666388511658, 1)
            UiFont("regular.ttf", 27)
            UiText("slider")
        UiPop()
        UiTranslate(45.0, 3.0)
        UiPush()
            UiTranslate(0, 4.0)
            UiImageBox("common/rect_c#ffffff_o0.10_cr3.png", 301.0, 12.0, 4, 4)
        UiPop()
        UiTranslate(2, 0)
        UiSliderHoverColorFilter(1.0, 0.2, 0.2)
        UiSliderThumbSize(8, 20)
        slider = UiSlider(thumbPath, "x", slider * 295, 0, 295) / 295
    UiPop()
end
```

------------------------------------------------------------------------

[]{#UiSliderThumbSize}

### UiSliderThumbSize {#uisliderthumbsize .function}

``` funcdef
UiSliderThumbSize(width, height)
```

Arguments\
[width]{.argname} [(number)]{.argtype} -- Thumb width\
[height]{.argname} [(number)]{.argtype} -- Thumb height\

Return value\
[none]{.retname}

Sets the slider thumb size

```lua
local slider = 0

function draw()
    local thumbPath = "common/thumb_I218_249_2430_49029.png"
    UiTranslate(200, 200)
    UiPush()
        UiMakeInteractive()
        UiPush()
            UiAlign("top right")
            UiTranslate(40, 3.4)
            UiColor(0.5291666388511658, 0.5291666388511658, 0.5291666388511658, 1)
            UiFont("regular.ttf", 27)
            UiText("slider")
        UiPop()
        UiTranslate(45.0, 3.0)
        UiPush()
            UiTranslate(0, 4.0)
            UiImageBox("common/rect_c#ffffff_o0.10_cr3.png", 301.0, 12.0, 4, 4)
        UiPop()
        UiTranslate(2, 0)
        UiSliderHoverColorFilter(1.0, 0.2, 0.2)
        UiSliderThumbSize(8, 20)
        slider = UiSlider(thumbPath, "x", slider * 295, 0, 295) / 295
    UiPop()
end
```

------------------------------------------------------------------------

[]{#UiGetScreen}

### UiGetScreen {#uigetscreen .function}

``` funcdef
handle = UiGetScreen()
```

Arguments\
[none]{.argname}

Return value\
[handle]{.retname} [(number)]{.argtype} -- Handle to the screen running
this script or zero if none.\

```lua
--Turn off screen running current script
screen = UiGetScreen()
SetScreenEnabled(screen, false)
```

------------------------------------------------------------------------

[]{#UiNavComponent}

### UiNavComponent {#uinavcomponent .function}

``` funcdef
id = UiNavComponent(w, h)
```

Arguments\
[w]{.argname} [(number)]{.argtype} -- Width of the component\
[h]{.argname} [(number)]{.argtype} -- Height of the component\

Return value\
[id]{.retname} [(string)]{.argtype} -- Generated ID of the component
which can be used to get an info about the component state\

Declares a navigation component which participates in navigation using
dpad buttons of a gamepad. It\'s an abstract entity which can be
focused. It has it\'s own size and position on screen accroding to UI
cursor and passed arguments, but it won\'t be drawn on the screen. Note
that all navigation components which are located outside of UiWindow
borders won\'t participate in the navigation and will be considered as
inactive

```lua
function draw()
    -- window declaration is necessary for navigation to work
    UiWindow(1920, 1080)
    if LastInputDevice() == UI_DEVICE_GAMEPAD then
        -- active mouse cursor has higher priority over the gamepad control
        -- so it will reset focused components if the mouse moves
        UiSetCursorState(UI_CURSOR_HIDE_AND_LOCK)   
    end
    UiTranslate(960, 540)
    local id = UiNavComponent(100, 20)
    local isInFocus = UiIsComponentInFocus(id)
    if isInFocus then
        local rect = UiFocusedComponentRect()
        DebugPrint("Position: (" .. tostring(rect.x) .. ", " .. tostring(rect.y) .. "), Size: (" .. tostring(rect.w) .. ", " .. tostring(rect.h) .. ")")
    end
end
```

------------------------------------------------------------------------

[]{#UiIgnoreNavigation}

### UiIgnoreNavigation {#uiignorenavigation .function}

``` funcdef
UiIgnoreNavigation([ignore])
```

Arguments\
[ignore]{.argname} [(boolean, optional)]{.argtype} -- Whether ignore the
navigation in a current UI scope or not.\

Return value\
[none]{.retname}

Sets a flag to ingore the navgation in a current UI scope or not. By
default, if argument isn\'t specified, the function sets the flag to
true. If ignore is set to true, all components after the function call
won\'t participate in navigation as if they didn\'t exist on a scene.
Flag resets back to false after leaving the UI scope in which the
function was called.

```lua
function draw()
    -- window declaration is necessary for navigation to work
    UiWindow(1920, 1080)
    if LastInputDevice() == UI_DEVICE_GAMEPAD then
        -- active mouse cursor has higher priority over the gamepad control
        -- so it will reset focused components if the mouse moves
        UiSetCursorState(UI_CURSOR_HIDE_AND_LOCK)   
    end
    UiTranslate(960, 540)
    UiNavComponent(100, 20)

    UiTranslate(150, 40)
    UiPush()
        UiIgnoreNavigation(true)
        local id = UiNavComponent(100, 20)
        local isInFocus = UiIsComponentInFocus(id)
        -- will be always "false"
        DebugPrint(isInFocus)
    UiPop()
end
```

------------------------------------------------------------------------

[]{#UiResetNavigation}

### UiResetNavigation {#uiresetnavigation .function}

``` funcdef
UiResetNavigation()
```

Arguments\
[none]{.argname}

Return value\
[none]{.retname}

Resets navigation state as if none componets before the function call
were declared

```lua
function draw()
    -- window declaration is necessary for navigation to work
    UiWindow(1920, 1080)
    if LastInputDevice() == UI_DEVICE_GAMEPAD then
        -- active mouse cursor has higher priority over the gamepad control
        -- so it will reset focused components if the mouse moves
        UiSetCursorState(UI_CURSOR_HIDE_AND_LOCK)   
    end
    UiTranslate(960, 540)
    local id = UiNavComponent(100, 20)

    UiResetNavigation()
    UiTranslate(150, 40)
    UiNavComponent(100, 20)

    local isInFocus = UiIsComponentInFocus(id)
    -- will be always "false"
    DebugPrint(isInFocus)
end
```

------------------------------------------------------------------------

[]{#UiNavSkipUpdate}

### UiNavSkipUpdate {#uinavskipupdate .function}

``` funcdef
UiNavSkipUpdate()
```

Arguments\
[none]{.argname}

Return value\
[none]{.retname}

Skip update of the whole navigation state in a current draw. Could be
used to override behaviour of navigation in some cases. See an example.

```lua
function draw()
    -- window declaration is necessary for navigation to work
    UiWindow(1920, 1080)
    if LastInputDevice() == UI_DEVICE_GAMEPAD then
        -- active mouse cursor has higher priority over the gamepad control
        -- so it will reset focused components if the mouse moves
        UiSetCursorState(UI_CURSOR_HIDE_AND_LOCK)   
    end
    UiTranslate(960, 540)
    UiNavComponent(100, 20)

    UiTranslate(0, 50)
    local id = UiNavComponent(100, 20)
    local isInFocus = UiIsComponentInFocus(id)

    if isInFocus and InputPressed("menu_up") then
        -- don't let navigation to update and if component in focus
        -- and do different action
        UiNavSkipUpdate()
        DebugPrint("Navigation action UP is overrided")
    end
end
```

------------------------------------------------------------------------

[]{#UiIsComponentInFocus}

### UiIsComponentInFocus {#uiiscomponentinfocus .function}

``` funcdef
focus = UiIsComponentInFocus(id)
```

Arguments\
[id]{.argname} [(string)]{.argtype} -- Navigation id of the component\

Return value\
[focus]{.retname} [(boolean)]{.argtype} -- Flag whether the component in
focus on not\

Returns the flag whether the component with specified id is in focus or
not

```lua
function draw()
    -- window declaration is necessary for navigation to work
    UiWindow(1920, 1080)
    if LastInputDevice() == UI_DEVICE_GAMEPAD then
        -- active mouse cursor has higher priority over the gamepad control
        -- so it will reset focused components if the mouse moves
        UiSetCursorState(UI_CURSOR_HIDE_AND_LOCK)   
    end

    UiTranslate(960, 540)

    local gId = UiNavGroupBegin()

    UiNavComponent(100, 20)
    UiTranslate(0, 50)
    local id = UiNavComponent(100, 20)
    local isInFocus = UiIsComponentInFocus(id)

    UiNavGroupEnd()

    local groupInFocus = UiIsComponentInFocus(gId)


    if isInFocus then
        DebugPrint(groupInFocus)
    end
end
```

------------------------------------------------------------------------

[]{#UiNavGroupBegin}

### UiNavGroupBegin {#uinavgroupbegin .function}

``` funcdef
id = UiNavGroupBegin([id])
```

Arguments\
[id]{.argname} [(string, optional)]{.argtype} -- Name of navigation
group. If not presented, will be generated automatically.\

Return value\
[id]{.retname} [(string)]{.argtype} -- Generated ID of the group which
can be used to get an info about the group state\

Begins a scope of a new navigation group. Navigation group is an entity
which aggregates all navigation components which was declared in it\'s
scope. The group becomes a parent entity for all aggregated components
including inner group declarations. During the navigation update process
the game engine first checks the focused componet for proximity to
components in the same group, and then if none neighbour was found the
engine starts to search for the closest group and the closest component
inside that group. Navigation group has the same properties as
navigation component, that is id, width and height. Group size depends
on its children common bounding box or it can be set explicitly. Group
is considered in focus if any of its child is in focus.

```lua
function draw()
    -- window declaration is necessary for navigation to work
    UiWindow(1920, 1080)
    if LastInputDevice() == UI_DEVICE_GAMEPAD then
        -- active mouse cursor has higher priority over the gamepad control
        -- so it will reset focused components if the mouse moves
        UiSetCursorState(UI_CURSOR_HIDE_AND_LOCK)   
    end

    UiTranslate(960, 540)

    local gId = UiNavGroupBegin()

    UiNavComponent(100, 20)
    UiTranslate(0, 50)
    local id = UiNavComponent(100, 20)
    local isInFocus = UiIsComponentInFocus(id)

    UiNavGroupEnd()

    local groupInFocus = UiIsComponentInFocus(gId)


    if isInFocus then
        DebugPrint(groupInFocus)
    end
end
```

------------------------------------------------------------------------

[]{#UiNavGroupEnd}

### UiNavGroupEnd {#uinavgroupend .function}

``` funcdef
UiNavGroupEnd()
```

Arguments\
[none]{.argname}

Return value\
[none]{.retname}

Ends a scope of a new navigation group. All components before that call
become children of that navigation group.

```lua
function draw()
    -- window declaration is necessary for navigation to work
    UiWindow(1920, 1080)
    if LastInputDevice() == UI_DEVICE_GAMEPAD then
        -- active mouse cursor has higher priority over the gamepad control
        -- so it will reset focused components if the mouse moves
        UiSetCursorState(UI_CURSOR_HIDE_AND_LOCK)   
    end

    UiTranslate(960, 540)

    local gId = UiNavGroupBegin()

    UiNavComponent(100, 20)
    UiTranslate(0, 50)
    local id = UiNavComponent(100, 20)
    local isInFocus = UiIsComponentInFocus(id)

    UiNavGroupEnd()

    local groupInFocus = UiIsComponentInFocus(gId)


    if isInFocus then
        DebugPrint(groupInFocus)
    end
end
```

------------------------------------------------------------------------

[]{#UiNavGroupSize}

### UiNavGroupSize {#uinavgroupsize .function}

``` funcdef
UiNavGroupSize(w, h)
```

Arguments\
[w]{.argname} [(number)]{.argtype} -- Width of the component\
[h]{.argname} [(number)]{.argtype} -- Height of the component\

Return value\
[none]{.retname}

Set a size of current navigation group explicitly. Can be used in cases
when it\'s needed to limit area occupied by the group or make it bigger
than total occupied area by children in order to catch focus from near
neighbours.

```lua
function draw()
    -- window declaration is necessary for navigation to work
    UiWindow(1920, 1080)
    if LastInputDevice() == UI_DEVICE_GAMEPAD then
        -- active mouse cursor has higher priority over the gamepad control
        -- so it will reset focused components if the mouse moves
        UiSetCursorState(UI_CURSOR_HIDE_AND_LOCK)   
    end
    
    UiTranslate(960, 540)

    local gId = UiNavGroupBegin()
    UiNavGroupSize(500, 300)

    UiNavComponent(100, 20)
    UiTranslate(0, 50)
    local id = UiNavComponent(100, 20)
    local isInFocus = UiIsComponentInFocus(id)

    UiNavGroupEnd()

    local groupInFocus = UiIsComponentInFocus(gId)

    if groupInFocus then
        -- get a rect of the focused component parent 
        local rect = UiFocusedComponentRect(1)
        DebugPrint("Position: (" .. tostring(rect.x) .. ", " .. tostring(rect.y) .. "), Size: (" .. tostring(rect.w) .. ", " .. tostring(rect.h) .. ")")
    end
end
```

------------------------------------------------------------------------

[]{#UiForceFocus}

### UiForceFocus {#uiforcefocus .function}

``` funcdef
UiForceFocus(id)
```

Arguments\
[id]{.argname} [(string)]{.argtype} -- Id of the component\

Return value\
[none]{.retname}

Force focus to the component with specified id.

```lua
function draw()
    -- window declaration is necessary for navigation to work
    UiWindow(1920, 1080)
    if LastInputDevice() == UI_DEVICE_GAMEPAD then
        -- active mouse cursor has higher priority over the gamepad control
        -- so it will reset focused components if the mouse moves
        UiSetCursorState(UI_CURSOR_HIDE_AND_LOCK)   
    end
    
    UiPush()

    UiTranslate(960, 540)

    local id1 = UiNavComponent(100, 20)
    UiTranslate(0, 50)
    local id2 = UiNavComponent(100, 20)

    UiPop()

    local f1 = UiIsComponentInFocus(id1)
    local f2 = UiIsComponentInFocus(id2)

    local rect = UiFocusedComponentRect()
    UiPush()
        UiColor(1, 0, 0)
        UiTranslate(rect.x, rect.y)
        UiRect(rect.w, rect.h)
    UiPop()

    if InputPressed("menu_accept") then
        UiForceFocus(id2)
    end
end
```

------------------------------------------------------------------------

[]{#UiFocusedComponentId}

### UiFocusedComponentId {#uifocusedcomponentid .function}

``` funcdef
id = UiFocusedComponentId()
```

Arguments\
[none]{.argname}

Return value\
[id]{.retname} [(string)]{.argtype} -- Id of the focused component\

Returns an id of the currently focused component

```lua
function draw()
    -- window declaration is necessary for navigation to work
    UiWindow(1920, 1080)
    if LastInputDevice() == UI_DEVICE_GAMEPAD then
        -- active mouse cursor has higher priority over the gamepad control
        -- so it will reset focused components if the mouse moves
        UiSetCursorState(UI_CURSOR_HIDE_AND_LOCK)   
    end

    UiPush()
    
    UiTranslate(960, 540)

    local id1 = UiNavComponent(100, 20)
    UiTranslate(0, 50)
    local id2 = UiNavComponent(100, 20)

    UiPop()

    local f1 = UiIsComponentInFocus(id1)
    local f2 = UiIsComponentInFocus(id2)

    local rect = UiFocusedComponentRect()
    UiPush()
        UiColor(1, 0, 0)
        UiTranslate(rect.x, rect.y)
        UiRect(rect.w, rect.h)
    UiPop()

    DebugPrint(UiFocusedComponentId())
end
```

------------------------------------------------------------------------

[]{#UiFocusedComponentRect}

### UiFocusedComponentRect {#uifocusedcomponentrect .function}

``` funcdef
rect = UiFocusedComponentRect([n])
```

Arguments\
[n]{.argname} [(number, optional)]{.argtype} -- Take n-th parent of the
focused component insetad of the component itself\

Return value\
[rect]{.retname} [(table)]{.argtype} -- Rect object with info about the
component bounding rectangle\

Returns a bounding rect of the currently focused component. If the arg
\"n\" is specified the function return a rect of the n-th parent group
of the component. The rect contains the following fields: w - width of
the component h - height of the component x - x position of the
component on the canvas y - y position of the component on the canvas

```lua
function draw()
    -- window declaration is necessary for navigation to work
    UiWindow(1920, 1080)
    if LastInputDevice() == UI_DEVICE_GAMEPAD then
        -- active mouse cursor has higher priority over the gamepad control
        -- so it will reset focused components if the mouse moves
        UiSetCursorState(UI_CURSOR_HIDE_AND_LOCK)   
    end
    
    UiPush()

    UiTranslate(960, 540)

    local id1 = UiNavComponent(100, 20)
    UiTranslate(0, 50)
    local id2 = UiNavComponent(100, 20)

    UiPop()

    local f1 = UiIsComponentInFocus(id1)
    local f2 = UiIsComponentInFocus(id2)

    local rect = UiFocusedComponentRect()
    UiPush()
        UiColor(1, 0, 0)
        UiTranslate(rect.x, rect.y)
        UiRect(rect.w, rect.h)
    UiPop()
end
```

------------------------------------------------------------------------

[]{#UiGetItemSize}

### UiGetItemSize {#uigetitemsize .function}

``` funcdef
x, y = UiGetItemSize()
```

Arguments\
[none]{.argname}

Return value\
[x]{.retname} [(number)]{.argtype} -- Width\
[y]{.retname} [(number)]{.argtype} -- Height\

Returns the last ui item size

```lua
function draw()
    UiTranslate(200, 200)
    UiPush()
        UiBeginFrame()
            UiFont("regular.ttf", 30)
            UiText("Text")
        UiEndFrame()
        w, h = UiGetItemSize()
        DebugPrint(w .. " " .. h)
    UiPop()
end
```

------------------------------------------------------------------------

[]{#UiAutoTranslate}

### UiAutoTranslate {#uiautotranslate .function}

``` funcdef
UiAutoTranslate(value)
```

Arguments\
[value]{.argname} [(boolean)]{.argtype} --\

Return value\
[none]{.retname}

Enables/disables auto autotranslate function when measuring the item
size

```lua
function draw()
    UiPush()
        UiBeginFrame()
            if InputDown("interact") then
                UiAutoTranslate(false)
            else
                UiAutoTranslate(true)
            end
            
            UiRect(50, 50)
            local w, h = UiGetItemSize()
            DebugPrint(math.ceil(w) .. "x" .. math.ceil(h))
        UiEndFrame()
    UiPop()
end
```

------------------------------------------------------------------------

[]{#UiBeginFrame}

### UiBeginFrame {#uibeginframe .function}

``` funcdef
UiBeginFrame()
```

Arguments\
[none]{.argname}

Return value\
[none]{.retname}

Call to start measuring the content size. After drawing part of the
interface, call UiEndFrame to get its size. Useful when you want the
size of the image box to match the size of the content.

```lua
function draw()
    UiPush()
        UiBeginFrame()
            UiColor(1.0, 1.0, 0.8)
            UiTranslate(UiCenter(), 300)
            UiFont("bold.ttf", 40)
            UiText("Hello")
        local panelWidth, panelHeight = UiEndFrame()
        DebugPrint(math.ceil(panelWidth) .. "x" .. math.ceil(panelHeight))
    UiPop()
end
```

------------------------------------------------------------------------

[]{#UiResetFrame}

### UiResetFrame {#uiresetframe .function}

``` funcdef
UiResetFrame()
```

Arguments\
[none]{.argname}

Return value\
[none]{.retname}

Resets the current frame measured values

```lua
function draw()
    UiPush()
        UiTranslate(UiCenter(), 300)
        UiFont("bold.ttf", 40)
        UiBeginFrame()
            UiTextButton("Button1")
            UiTranslate(200, 0)
            UiTextButton("Button2")
        UiResetFrame()
        local panelWidth, panelHeight = UiEndFrame()
        DebugPrint("w: " .. panelWidth .. "; h:" .. panelHeight)
    UiPop()
end
```

------------------------------------------------------------------------

[]{#UiFrameOccupy}

### UiFrameOccupy {#uiframeoccupy .function}

``` funcdef
UiFrameOccupy(width, height)
```

Arguments\
[width]{.argname} [(number)]{.argtype} -- Width\
[height]{.argname} [(number)]{.argtype} -- Height\

Return value\
[none]{.retname}

Occupies some space for current frame (between UiBeginFrame and
UiEndFrame)

```lua
function draw()
    UiPush()
        UiBeginFrame()
            UiColor(1.0, 1.0, 0.8)
            UiRect(200, 200)
            UiRect(300, 200)
            UiFrameOccupy(500, 500)
        local panelWidth, panelHeight = UiEndFrame()
        DebugPrint(math.ceil(panelWidth) .. "x" .. math.ceil(panelHeight))
    UiPop()
end
```

------------------------------------------------------------------------

[]{#UiEndFrame}

### UiEndFrame {#uiendframe .function}

``` funcdef
width, height = UiEndFrame()
```

Arguments\
[none]{.argname}

Return value\
[width]{.retname} [(number)]{.argtype} -- Width of content drawn between
since UiBeginFrame was called\
[height]{.retname} [(number)]{.argtype} -- Height of content drawn
between since UiBeginFrame was called\

```lua
function draw()
    UiPush()
        UiBeginFrame()
            UiColor(1.0, 1.0, 0.8)
            UiRect(200, 200)
            UiRect(300, 200)
        local panelWidth, panelHeight = UiEndFrame()
        DebugPrint(math.ceil(panelWidth) .. "x" .. math.ceil(panelHeight))
    UiPop()
end
```

------------------------------------------------------------------------

[]{#UiFrameSkipItem}

### UiFrameSkipItem {#uiframeskipitem .function}

``` funcdef
UiFrameSkipItem(skip)
```

Arguments\
[skip]{.argname} [(boolean)]{.argtype} -- Should skip item\

Return value\
[none]{.retname}

Sets whether to skip items in current ui scope for current ui frame.
This items won\'t affect on the frame size

```lua
function draw()
    UiPush()
        UiBeginFrame()
            UiFrameSkipItem(true)
            --[[
                ...
            ]]
        UiEndFrame()
    UiPop()
end
```

------------------------------------------------------------------------

[]{#UiGetFrameNo}

### UiGetFrameNo {#uigetframeno .function}

``` funcdef
frameNo = UiGetFrameNo()
```

Arguments\
[none]{.argname}

Return value\
[frameNo]{.retname} [(number)]{.argtype} -- Frame number since the level
start\

```lua
function draw()
    local fNo = GetFrame()
    DebugPrint(fNo)
end
```

------------------------------------------------------------------------

[]{#UiGetLanguage}

### UiGetLanguage {#uigetlanguage .function}

``` funcdef
index = UiGetLanguage()
```

Arguments\
[none]{.argname}

Return value\
[index]{.retname} [(number)]{.argtype} -- Language index\

```lua
local n = UiGetLanguage()
```

------------------------------------------------------------------------

[]{#UiSetCursorState}

### UiSetCursorState {#uisetcursorstate .function}

``` funcdef
UiSetCursorState(state)
```

Arguments\
[state]{.argname} [(number)]{.argtype} --\

Return value\
[none]{.retname}

Possible values are:\
0 - show cursor (UI_CURSOR_SHOW)\
1 - hide cursor (UI_CURSOR_HIDE)\
2 - hide & lock cursor (UI_CURSOR_HIDE_AND_LOCK)\
\
Allows you to force visibilty of cursor for next frame. If the cursor is
hidden, gamepad navigation methods are used.\
By default, in case of entering interactive UI state with gamepad,
cursor will be shown and will be controlled using gamepad.\
Thus, if you need to implement navigation using the gamepad\'s D-pad,
you should call this function.

```lua
#include "ui/ui_helpers.lua"

function draw()
    UiPush()
        -- If the last input device was a gamepad, hide the cursor and proceed to control through D-pad navigation
        if LastInputDevice() == UI_DEVICE_GAMEPAD then
            UiSetCursorState(UI_CURSOR_HIDE_AND_LOCK)
        end

        UiMakeInteractive()
        UiAlign("center")
        UiColor(1.0, 1.0, 1.0)
        UiButtonHoverColor(1.0, 0.5, 0.5)
        UiFont("regular.ttf", 50)
        UiTranslate(UiCenter(), 200)
    
        UiTranslate(0, 100)
        if UiTextButton("1") then
            DebugPrint(1)
        end
        UiTranslate(0, 100)
        if UiTextButton("2") then
            DebugPrint(2)
        end
    UiPop()
end
```

------------------------------------------------------------------------
