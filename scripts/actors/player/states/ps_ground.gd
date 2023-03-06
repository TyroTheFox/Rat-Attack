extends player_state
class_name ps_Ground

# Called every frame. 'delta' is the elapsed time since the previous frame.
func s_physics_update(delta):
	var ground_movement = player.movement_module.ground_movement
	# Add the gravity.
	if not player.is_on_floor():
		#Move to in_air state
		state_machine.transition_to('in_air')
		return

	# Handle Jump.
	if Input.is_action_just_pressed("p_jump") and player.is_on_floor():
#		if !player.coyoteTime.is_stopped():
#			player.coyoteTime.stop()
		# Move to jump state
		state_machine.transition_to('jumping')
		return

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("p_move_left", "p_move_right", "p_move_up", "p_move_down")
	var cameraBasisVector = player.level_camera.get_global_transform().basis
	var direction = (cameraBasisVector * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction.y = 0
	
	player.velocity = ground_movement.process_movement(delta, player.velocity, direction)
	
