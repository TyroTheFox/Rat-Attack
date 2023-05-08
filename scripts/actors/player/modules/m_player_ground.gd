extends Node
class_name m_Player_Ground_Movement

## Parent Module
var parent_module

## Player node
var player
## Player Mesh
var mesh
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
	
	parent_module = player.movement_module

## Handle movment
func process_movement(delta: float, linear_velocity: Vector3, dir: Vector3):	
	hv = Vector3(linear_velocity.x, 0, linear_velocity.z) # Horizontal velocity.
	
	hdir = hv.normalized() # Horizontal direction.
	hspeed = hv.length() # Horizontal speed.
	
#	$coyoteTime.stop()
	hv.x = 0
	hv.y = 0
	hv.z = 0
	_calculateFloorMovement( delta, dir )
	
	linear_velocity.x = hv.x
	linear_velocity.y = 0
	linear_velocity.z = hv.z
	
	return linear_velocity

func _calculateFloorMovement( delta, dir ):	
	var newAngle = rad_to_deg(hdir.angle_to(dir))
	var oppositionPercent = newAngle/180
	
	if dir.length() > 0:
		movement_dir = dir
		if hspeed > 0.001:
			hdir = parent_module.adjust_facing(
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
	
	if dir.length() > 0:
		var facing = movement_dir
		facing.y = 0
		mesh.look_at(-facing * TURN_SPEED, Vector3.UP)
	
	hv.x = hdir.x * hspeed
	hv.z = hdir.z * hspeed
	
