extends enemy_state
class_name ES_In_Air

# Called every frame. 'delta' is the elapsed time since the previous frame.
func s_physics_update(delta):
	var movement_module_node = enemy.movement_module
	var in_air_movement = movement_module_node.in_air_movement
	
			# Add the gravity.
	if enemy.is_on_floor():
		state_machine.transition_to('ground')
	else:
		#Move to in_air state
		enemy.set_velocity(in_air_movement.process_movement(delta, enemy.velocity))
		return
