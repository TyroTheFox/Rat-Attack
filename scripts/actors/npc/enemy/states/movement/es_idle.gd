extends enemy_state
class_name ES_Idle

func s_physics_update(delta):
	var movement_module_node = enemy.movement_module
	var in_air_movement = movement_module_node.in_air_movement
	
	if not enemy.is_on_floor():
		enemy.set_velocity(in_air_movement.process_movement(delta, enemy.velocity))
