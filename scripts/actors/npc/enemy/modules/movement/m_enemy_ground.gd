extends Node
class_name m_Enemy_Ground_Movement

## Parent Module
var parent_module

## Enemy node
var enemy
## Enemy Mesh
var mesh
## Direction the Enemy is moving in
var movement_dir = Vector3()

## How fast you speed up
@export var movement_speed = 2.0
## How fast you turn
@export var TURN_SPEED = 140

# Called when the node enters the scene tree for the first time.
func init(owned_enemy: Enemy):
	enemy = owned_enemy
	mesh = enemy.model	
	parent_module = enemy.movement_module

## Handle movment
func process_movement(_delta: float, linear_velocity: Vector3):
	var navigation_agent: NavigationAgent3D = parent_module.navigation_agent
	if navigation_agent.is_target_reached():
		linear_velocity.x = 0
		linear_velocity.y = 0
		linear_velocity.z = 0
	
		return linear_velocity

	var current_agent_position: Vector3 = enemy.position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	var new_velocity: Vector3 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	
	movement_dir = new_velocity
	
	linear_velocity.x = new_velocity.x * movement_speed
	linear_velocity.y = 0
	linear_velocity.z = new_velocity.z * movement_speed
	
	if linear_velocity.length() > 0:
		var facing = movement_dir
		facing.y = 0
		var newFacing = facing * TURN_SPEED
		enemy.rotation.y = lerp_angle(enemy.rotation.y, atan2(newFacing.x, newFacing.z), 1)
	
	return linear_velocity
