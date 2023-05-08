extends enemy_state
class_name es_Ground

# Called every frame. 'delta' is the elapsed time since the previous frame.
func s_physics_update(delta):
	var movement_module_node = enemy.movement_module
	var ground_movement = movement_module_node.ground_movement
	
		# Add the gravity.
	if enemy.is_on_floor():
		enemy.set_velocity(ground_movement.process_movement(delta, enemy.velocity))
	else:
		#Move to in_air state
		state_machine.transition_to('in_air')
		return