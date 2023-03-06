extends Node
class_name Player_Movement

# Movement Modules
## Ground Movement Module
var ground_movement: m_Player_Ground_Movement
## In-Air Movement Module
var air_movement: m_Player_Air_Movement
## Jump Movement Module
var jump_movement: m_Player_Jump_Movement

## Player Gravity
var gravity

# Called when the node enters the scene tree for the first time.
func _ready():
	ground_movement = $ground_movement
	air_movement = $air_movement
	jump_movement = $jump_movement
	
	gravity = jump_movement.jump_height/2*(jump_movement.jump_time * jump_movement.jump_time)

## Adjust the direction the model is facing
func adjust_facing(mesh_xform, p_facing, p_target, p_step, p_adjust_rate, current_gn):
	var n = p_target # Normal.
	var t = n.cross(current_gn).normalized()

	var x = n.dot(p_facing)
	var y = t.dot(p_facing)

	var ang = atan2(y,x)

	if abs(ang) < 0.001: # Too small.
		return p_facing

	var s = sign(ang)
	ang = ang * s
	var turn = ang * p_adjust_rate * p_step
	var a
	if ang < turn:
		a = ang
	else:
		a = turn
	ang = (ang - a) * s

	return (n * cos(ang) + t * sin(ang)) * p_facing.length()
