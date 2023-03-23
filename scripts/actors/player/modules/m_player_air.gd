extends Node
class_name m_Player_Air_Movement

## Parent Module
var parent_module

## Player node
var player
## Player Mesh
var mesh
## Player Mesh Transform
var mesh_xform
## Scale value for the model
var CHAR_SCALE
## Vector for the Level Camera
var cameraBasisVector

## Whether or not your movement deaccelerates while in the air
@export var air_idle_deaccel = true
## How fast you speed up
@export var accel = 90.0
## How fast you slow down
@export var deaccel = 22.5
## Player reactivity percentage, regarding suggently picking a different direction
#@export var reactivityPercent = 0.5
## Threshhold that's considered a sharp turn
#@export var sharp_turn_threshold = 140.0
## How fast you turn
@export var TURN_SPEED = 140
## How fast you run
@export var max_speed = 12.0

var vv

# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready
	player = owner as Player
	assert(player != null)

	cameraBasisVector = player.level_camera.get_global_transform().basis
	mesh = player.model
	mesh_xform = mesh.get_transform()
	
	vv = 0
	
	parent_module = player.movement_module

## Handle movment
func process_movement(delta: float, linear_velocity: Vector3, dir: Vector3):
	var ground_module = parent_module.ground_movement
	cameraBasisVector = player.level_camera.get_global_transform().basis
	
	vv = linear_velocity.y # Vertical velocity.
	
	ground_module.hv.x = 0
	ground_module.hv.z = 0
	_calculateAerialMovement( delta, dir )
	
	linear_velocity.x = ground_module.hv.x
	linear_velocity.z = ground_module.hv.z
	linear_velocity.y = ( Vector3.UP.y * vv ) - (parent_module.gravity * delta)

	return linear_velocity

func _calculateAerialMovement( delta, dir, update_facing = true ):
	var ground_module = parent_module.ground_movement
	
	var newAngle = rad_to_deg(ground_module.hdir.angle_to(dir))
	var oppositionPercent = newAngle/180
	
	if dir.length() > 0:
		if ground_module.hspeed > 0.001:
			ground_module.hdir = parent_module.adjust_facing(
				ground_module.hdir, 
				dir, 
				delta, 
				1.0 / ground_module.hspeed * TURN_SPEED, 
				Vector3.UP
			)
		else:
			ground_module.hdir = dir

		if ground_module.hspeed < max_speed:
			ground_module.hspeed += (accel - (accel * oppositionPercent)) * delta
#			ground_module.hspeed += accel * delta
	else:
		if air_idle_deaccel:
			ground_module.hspeed = ground_module.hspeed - (deaccel * delta)
			if ground_module.hspeed < 0:
				ground_module.hspeed = 0

	if update_facing:
		var facing_mesh = -mesh_xform.basis[0].normalized()
		facing_mesh = (facing_mesh - Vector3.UP * facing_mesh.dot(Vector3.UP)).normalized()

		if ground_module.hspeed > 0:
			facing_mesh = parent_module.adjust_facing(
				facing_mesh, 
				dir, 
				delta, 
				1.0 / ground_module.hspeed * TURN_SPEED, 
				Vector3.UP
			)
		ground_module.movement_dir = facing_mesh
		var m3 = Basis(-facing_mesh, Vector3.UP, -facing_mesh.cross(Vector3.UP).normalized())

		mesh.set_transform(Transform3D(m3, mesh_xform.origin))
	
	ground_module.hv.x = ground_module.hdir.x * ground_module.hspeed
	ground_module.hv.z = ground_module.hdir.z * ground_module.hspeed
