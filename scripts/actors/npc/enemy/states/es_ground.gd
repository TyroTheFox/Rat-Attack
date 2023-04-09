extends enemy_state
class_name es_Ground

# Called every frame. 'delta' is the elapsed time since the previous frame.
func s_physics_update(delta):
	var movement_module_node = enemy.movement_module
	var ground_movement = movement_module_node.ground_movement
	
	enemy.set_velocity(ground_movement.process_movement(delta, enemy.velocity))
