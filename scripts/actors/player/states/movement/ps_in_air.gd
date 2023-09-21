extends player_state
class_name ps_In_Air

var coyote_time_active = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func s_physics_update(delta):
	var movement_module_node = player.movement_module
	var coyote_timer = player.coyote_time
	
	if player.is_on_floor():
		#Move to ground state
		state_machine.transition_to('ground')
		return
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var cameraBasisVector = player.level_camera.get_global_transform().basis
	
	player.velocity = movement_module_node.handleBasicAerialMovement(
		cameraBasisVector, 
		delta, 
		player.velocity 
	)
