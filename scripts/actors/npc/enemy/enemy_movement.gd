extends Node
class_name Enemy_Movement

# Movement Modules
## Ground Movement Module
var ground_movement: m_Enemy_Ground_Movement
## In-Air Movement Module
var in_air_movement: m_Enemy_Air_Movement

## Enemy Gravity
var gravity
## Base Enemy Node
var enemy
## Movement Target
var movement_target_position: Vector3

var navigation_agent: NavigationAgent3D

## Whether or not the Navmesh is ready to use yet
var ready_to_start: bool = false
## Stops the movement while active
var hault_movement = false

@onready var movement_state_chart = $"../state_chart"

# Called when the node enters the scene tree for the first time.
func init(owned_enemy: Enemy):
	enemy = owned_enemy
	gravity = enemy.gravity

	ground_movement = $ground_movement
	in_air_movement = $air_movement
	
	ground_movement.init(enemy)
	in_air_movement.init(enemy)
	
	navigation_agent = enemy.navigation_agent
	movement_target_position = enemy.position
	
	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func set_movement_target(movement_target: Vector3):
	movement_target_position = movement_target
	navigation_agent.set_target_position(movement_target)

func distance_to_target():
	return navigation_agent.distance_to_target()

func is_navigation_finished():
	return navigation_agent.is_navigation_finished()

func is_target_reached():
	return navigation_agent.is_target_reached()

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	
	ready_to_start = true

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position)

	$"../state_chart"._on_pick_target_state_entered()

func process_movement(delta: float, velocity: Vector3, is_on_floor: bool):
	var returnVelocity: Vector3 = Vector3()

	if is_on_floor:
		#$model/mesh/meshbox.visible = false
		enemy.set_collision_mask_value(2, false)
		returnVelocity = handleBasicGroundMovement(
			delta,
			velocity
		)
	else:
		returnVelocity = handleBasicIn_AirMovement(
			delta,
			velocity
		)
	
		returnVelocity = calculateGravity(delta, returnVelocity)
	
	if is_target_reached():
		movement_state_chart.send_chart_event('target_reached')
	
	if hault_movement:
		returnVelocity.x = 0
		returnVelocity.z = 0
	
	return returnVelocity

func handleBasicGroundMovement(delta, velocity):
	return ground_movement.process_movement(delta, velocity)

func handleBasicIn_AirMovement(delta, velocity):
	return in_air_movement.process_movement(delta, velocity)

func calculateGravity(delta, velocity):
	velocity.y = -gravity

	return velocity
