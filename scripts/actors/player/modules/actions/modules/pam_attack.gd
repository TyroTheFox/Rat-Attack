extends Player_Action_Module
class_name Player_Action_Module_Attack

func activate(_action_strength):
	super.activate(_action_strength)
	
	var action_state_machine = player.action_state_machine
	
	action_state_machine.transition_to('attack')
