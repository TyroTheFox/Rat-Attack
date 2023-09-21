extends enemy_state
class_name ES_Idle

@export var next_state_on_exit = 'pick_target'

func s_exit() -> void:
	state_machine.transition_to(next_state_on_exit)
