extends Player_Action_Module
class_name Player_Action_Module_Attack

func activate(_action_strength):
	super.activate(_action_strength)
	
	player.movement_SCH.send_chart_event('attack')
