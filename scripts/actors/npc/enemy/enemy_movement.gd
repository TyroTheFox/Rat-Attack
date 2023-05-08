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

# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready
	enemy = owner as Enemy
	assert(enemy != null)

	gravity = enemy.gravity

	ground_movement = $ground_movement
	in_air_movement = $air_movement
	
	navigation_agent = enemy.navigation_agent
	movement_target_position = enemy.global_transform.origin
	
	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func set_movement_target(movement_target: Vector3):
	movement_target_position = movement_target
	navigation_agent.set_target_position(movement_target)

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	
	ready_to_start = true

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position)
