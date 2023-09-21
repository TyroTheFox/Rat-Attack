extends Player_Action_Module
class_name Player_Action_Module_Jump

func activate(_action_strength):
	if activated:
		return
	
	super.activate(_action_strength)
	
	var coyote_timer = player.coyote_time
	var movement_state = player.state_machine
	
	if player.is_on_floor():
		if !coyote_timer.is_stopped():
			coyote_timer.stop()
		# Move to jump state
		movement_state.transition_to('jumping')
		return
	else:
		if !coyote_timer.is_stopped():
			coyote_timer.stop()
			# Move to jump state
			movement_state.transition_to('jumping')
			return

func release():
	super.release()
	
	var movement_state = player.state_machine
	var jump_movement: m_Player_Jump = player.movement_module.jump_movement
	var air_movement: m_Player_Air_Movement = player.movement_module.air_movement
	
	movement_state.transition_to('in_air')
	if air_movement.vv > jump_movement.early_jump_termination:
		air_movement.vv = jump_movement.early_jump_termination
