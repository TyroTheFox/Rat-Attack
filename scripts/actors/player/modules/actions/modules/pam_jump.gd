extends Player_Action_Module
class_name Player_Action_Module_Jump

func activate(_action_strength):
	if activated:
		return
	
	super.activate(_action_strength)
	
	player.movement_module.jumping = true

func release():
	super.release()
	
	var movement_SCH = player.movement_SCH
	
	movement_SCH.send_chart_event("early_release")
