extends Node
class_name m_Player_Ground_Movement

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
## Direction the player is moving in
var movement_dir = Vector3()
## Vector for the Level Camera
var cameraBasisVector

## How fast you speed up
@export var accel = 90.0
## How fast you slow down
@export var deaccel = 80.0
## Player reactivity percentage, regarding suggently picking a different direction
@export var reactivityPercent = 0.5
## Threshhold that's considered a sharp turn
@export var sharp_turn_threshold = 140.0
## How fast you turn
@export var TURN_SPEED = 140
## How fast you run
@export var max_speed = 12.0
## How quickly you deaccelerate from max speed
@export var max_speed_deaccel_multiplier = 0.7

## Horizontal velocity
var hv: Vector3 = Vector3(0, 0, 0)
## Horizontal direction
var hdir: Vector3 = Vector3(0, 0, 0)
## Horizontal speed
var hspeed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready
	player = owner as Player
	assert(player != null)
	
	cameraBasisVector = player.level_camera.get_global_transform().basis
	mesh = player.model
	mesh_xform = mesh.get_transform()
	
	parent_module = player.movement_module

## Handle movment
func process_movement(delta: float, linear_velocity: Vector3, forward: Vector3):
	cameraBasisVector = player.level_camera.get_global_transform().basis
	
	hv = Vector3(linear_velocity.x, 0, linear_velocity.z) # Horizontal velocity.
	
	hdir = hv.normalized() # Horizontal direction.
	hspeed = hv.length() # Horizontal speed.
	
#	$coyoteTime.stop()
	hv.x = 0
	hv.y = 0
	hv.z = 0
	_calculateFloorMovement( delta, forward )
	
	linear_velocity = hv
	
	return linear_velocity

func _calculateFloorMovement( delta, dir ):
	var sharp_turn = hspeed > 0.1 and rad_to_deg(acos(dir.dot(hdir))) > sharp_turn_threshold
	
	var newAngle = rad_to_deg(hdir.angle_to(dir))
	var oppositionPercent = newAngle/180
	
	if dir.length() > 0.1 and !sharp_turn:
		if hspeed > 0.001:
			hdir = parent_module.adjust_facing(
				mesh_xform,
				hdir, 
				dir, 
				delta, 
				1.0 / hspeed * TURN_SPEED, 
				Vector3.UP
			)
		else:
			hdir = dir
		
		if hspeed < max_speed:
			hspeed += ( accel + (accel * oppositionPercent) ) * delta
		else:
			hspeed -= ( deaccel * delta ) * max_speed_deaccel_multiplier
	else:
		hspeed -= deaccel * delta
		if hspeed < 0:
			hspeed = 0
	
	hv = hdir * hspeed
	
	var facing_mesh = -mesh_xform.basis[0].normalized()
	facing_mesh = (facing_mesh - Vector3.UP * facing_mesh.dot(Vector3.UP)).normalized()
	
	if hspeed > 0:
		facing_mesh = parent_module.adjust_facing(
			mesh_xform,
			facing_mesh, 
			dir, 
			delta, 
			1.0 / hspeed * TURN_SPEED, 
			Vector3.UP
		)
	movement_dir = facing_mesh
	var m3 = Basis(-facing_mesh, Vector3.UP, -facing_mesh.cross(Vector3.UP).normalized())
	
	mesh.set_transform(Transform3D(m3, mesh_xform.origin))
