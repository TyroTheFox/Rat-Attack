extends enemy_state
class_name ES_Do_Nothing_Till_Movement_State

@export var movement_state_to_wait_for = "stand_still"
@export var action_state_to_transition_to = ""

func s_enter(msg: Dictionary = {}):
	var movement_state_machine: StateMachine = enemy.state_machine_movement
	movement_state_machine.connect('transitioned', _on_movement_state_machine_transitioning)

func _on_movement_state_machine_transitioning(state_name: String):
	var movement_state_machine: StateMachine = enemy.state_machine_movement
	
	if state_name == movement_state_to_wait_for:
		state_machine.transition_to(action_state_to_transition_to)
		movement_state_machine.disconnect('transitioned', _on_movement_state_machine_transitioning)
