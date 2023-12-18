extends Player_Movement_Module
class_name m_Player_Air_Movement

## Whether or not your movement deaccelerates while in the air
@export var air_idle_deaccel = true
## How fast you speed up
@export var accel = 90.0
## How fast you slow down
@export var deaccel = 22.5
## How fast you turn
@export var TURN_SPEED = 140
## How fast you run
@export var max_speed = 12.0
## Whether or not your character changes the direction they face while in the air
@export var update_facing = true
## How quickly you deaccelerate from max speed
@export var max_speed_deaccel_multiplier = 0.7

## Handle movment
func process_movement(delta: float, linear_velocity: Vector3, dir: Vector3):
	cameraBasisVector = player.level_camera.get_global_transform().basis

	hv = Vector3(linear_velocity.x, 0, linear_velocity.z) # Horizontal velocity.

	hdir = hv.normalized() # Horizontal direction.
	hspeed = hv.length() # Horizontal speed.

	hv.x = 0
	hv.z = 0
	_calculateAerialMovement( delta, dir )
	
	linear_velocity.x = hv.x
	linear_velocity.z = hv.z

	return linear_velocity

func _calculateAerialMovement( delta, dir ):	
	# var newAngle = rad_to_deg(hdir.angle_to(dir))
	# var oppositionPercent = newAngle/180
	
	if dir.length() > 0:
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
			# hspeed += (accel - (accel * oppositionPercent)) * delta
			hspeed += accel * delta
		else:
			hspeed -= ( deaccel * delta ) * max_speed_deaccel_multiplier
	else:
		if air_idle_deaccel:
			hspeed = hspeed - (deaccel * delta)
			if hspeed < 0:
				hspeed = 0

	if update_facing:
		movement_dir = dir
	
	if dir.length() > 0:
		var facing = movement_dir
		facing.y = 0
		mesh.look_at(-facing * TURN_SPEED, Vector3.UP)

	hv.x = hdir.x * hspeed
	hv.z = hdir.z * hspeed
