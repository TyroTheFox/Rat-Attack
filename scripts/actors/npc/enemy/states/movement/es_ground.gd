extends enemy_state
class_name ES_Ground

@export var next_state_on_target_reached = 'idle'

# Called every frame. 'delta' is the elapsed time since the previous frame.
func s_physics_update(delta):
	var movement_module_node = enemy.movement_module
	var ground_movement = movement_module_node.ground_movement
	
	if movement_module_node.is_target_reached():
		state_machine.transition_to(next_state_on_target_reached)	
	
	if enemy.is_on_floor():
		enemy.set_velocity(ground_movement.process_movement(delta, enemy.velocity))
	else:
		#Move to in_air state
		state_machine.transition_to('in_air')
		return
