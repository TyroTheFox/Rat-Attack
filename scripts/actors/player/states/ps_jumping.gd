extends player_state
class_name ps_Jumping

# Called every frame. 'delta' is the elapsed time since the previous frame.
func s_physics_update(delta):
	var jump_movement: m_Player_Jump_Movement = player.movement_module.jump_movement
	var air_movement: m_Player_Air_Movement = player.movement_module.air_movement

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("p_move_left", "p_move_right", "p_move_up", "p_move_down")
	var cameraBasisVector = player.level_camera.get_global_transform().basis
	var direction = (cameraBasisVector * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction.y = 0
	
	var linear_velocity = air_movement.process_movement(delta, player.velocity, direction)
	
	air_movement.vv = jump_movement.jump_speed
	
	if Input.is_action_just_released("p_jump"):
		state_machine.transition_to('in_air')
		if air_movement.vv > jump_movement.early_jump_termination:
			air_movement.vv = jump_movement.early_jump_termination

	linear_velocity.y = air_movement.vv

	player.velocity = linear_velocity
	
	state_machine.transition_to('in_air')
