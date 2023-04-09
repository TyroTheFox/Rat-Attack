extends enemy_state
class_name ES_Idle

func s_physics_update(delta):
	var movement_module_node = enemy.movement_module
	var ground_movement = movement_module_node.ground_movement
	
	if !movement_module_node.ready_to_start:
		return
	
	movement_module_node.set_movement_target(Vector3(-3.0,0.0,2.0))
	
	state_machine.transition_to('ground')
