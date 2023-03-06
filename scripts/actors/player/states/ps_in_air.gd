extends player_state
class_name ps_In_Air

# Called every frame. 'delta' is the elapsed time since the previous frame.
func s_physics_update(delta):
	var in_air_movement = player.movement_module.air_movement
	
	if player.is_on_floor():
		#Move to ground state
		state_machine.transition_to('ground')
		return
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("p_move_left", "p_move_right", "p_move_up", "p_move_down")
	var cameraBasisVector = player.level_camera.get_global_transform().basis
	var direction = (cameraBasisVector * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction.y = 0
	
	player.velocity = in_air_movement.process_movement(delta, player.velocity, direction)
