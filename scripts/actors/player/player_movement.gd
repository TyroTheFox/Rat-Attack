extends Node
class_name Player_Movement

# Movement Key Binds
## Left Movement
@export var key_bind_left: String = "p_move_left"
## Right Movement
@export var key_bind_right: String = "p_move_right"
## Up Movement
@export var key_bind_up: String = "p_move_up"
## Down Movement
@export var key_bind_down: String = "p_move_down"

# Movement Modules
## Ground Movement Module
var ground_movement: m_Player_Ground_Movement
## In-Air Movement Module
var air_movement: m_Player_Air_Movement
## Jump Movement Module
var jump_movement: m_Player_Jump

var jumping = false
var early_release = false

## Player Gravity
var gravity

# Called when the node enters the scene tree for the first time.
func init(owned_player: Player):
	ground_movement = $ground_movement
	air_movement = $air_movement
	jump_movement = $jump_movement
	
	ground_movement.init(owned_player)
	air_movement.init(owned_player)
	jump_movement.init(owned_player)
	
	gravity = jump_movement.gravity

func process_movement(velocity: Vector3, is_on_floor: bool, delta: float, cameraBasisVector: Basis):
	var returnVelocity: Vector3 = Vector3()
	
	if is_on_floor:
		returnVelocity = handleBasicGroundMovement(
			cameraBasisVector, 
			delta, 
			velocity 
		)
	else:
		returnVelocity = handleBasicAerialMovement(
			cameraBasisVector, 
			delta, 
			velocity 
		)

		returnVelocity = calculateGravity(delta, returnVelocity)
	
	return returnVelocity

# Calculates the direction a character should move, based on where the camera is in relation to the
# player character, assuming that pushing up on the controller should move away from the camera
func calculateMovementVectorBasedOnCameraOrientation(cameraBasisVector):
	var input_dir = Input.get_vector(key_bind_left, key_bind_right, key_bind_up, key_bind_down)
	return calculateForwardVector(input_dir, cameraBasisVector)

func calculateGravity(delta, velocity):
	velocity.y = ( Vector3.UP.y * velocity.y ) - (gravity * delta)

	return velocity

# Handles basic ground movement
func handleBasicGroundMovement(cameraBasisVector, delta, velocity):
	var direction = calculateMovementVectorBasedOnCameraOrientation(cameraBasisVector)
	return ground_movement.process_movement(delta, velocity, direction)

# Handles basic aerial movement
func handleBasicAerialMovement(cameraBasisVector, delta, velocity):
	var direction = calculateMovementVectorBasedOnCameraOrientation(cameraBasisVector)
	return air_movement.process_movement(delta, velocity, direction)

# Handles basic jumping movement
func handleJumpingMovement(velocity: Vector3, state_chart: StateChart):
	velocity.y = jump_movement.jump_speed
	jumping = false
	early_release = true
	state_chart.send_event("jump")
	return velocity

func handleEarlyJumpTermination(velocity: Vector3, state_chart: StateChart):
	velocity.y = jump_movement.jump_minSpeed
	state_chart.send_event("early_release")
	early_release = false
	return velocity

# Calculates a 'Forward' vector, based on where the player character is in relation to the camera.
# A forward vector being 'forward' according to the camera's perspective, that is to say, moving
# away from the camera
func calculateForwardVector(input_dir, cameraBasisVector):
	var dir = Vector3() # Where does the player intend to walk to.
	dir = (input_dir.x) * cameraBasisVector[0]
	dir += (input_dir.y) * cameraBasisVector[2]
	dir.y = 0
	dir = dir.normalized()
	return dir

## Adjust the direction the player is facing
func adjust_facing(p_facing, p_target, p_step, p_adjust_rate, current_gn):
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
