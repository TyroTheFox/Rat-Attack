extends player_state
class_name ps_Ground

# Called every frame. 'delta' is the elapsed time since the previous frame.
func s_physics_update(delta):
	var movement_module_node = player.movement_module
	var coyote_timer = player.coyote_time
	
	# Add the gravity.
	if player.is_on_floor():
		if !coyote_timer.is_stopped():
			coyote_timer.stop()
	else:
		#Move to in_air state
		state_machine.transition_to('in_air_coyote_time')
		coyote_timer.start()
		return

#	# Handle Jump.
#	if Input.is_action_just_pressed("p_jump") and player.is_on_floor():
#		if !coyote_timer.is_stopped():
#			coyote_timer.stop()
#		# Move to jump state
#		state_machine.transition_to('jumping')
#		return

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var cameraBasisVector = player.level_camera.get_global_transform().basis
	
	player.velocity = movement_module_node.handleBasicGroundMovement(
		cameraBasisVector, 
		delta, 
		player.velocity 
	)
