extends enemy_state
class_name ES_Idle

func s_physics_update(delta):
	if not enemy.is_on_floor():
		state_machine.transition_to('in_air')
