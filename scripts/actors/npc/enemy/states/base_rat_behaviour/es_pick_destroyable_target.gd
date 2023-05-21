extends enemy_state
class_name ES_Pick_Destoryable_Target

func s_physics_update(delta):
	var movement_module_node = enemy.movement_module
	var ground_movement = movement_module_node.ground_movement
	var rat_director = enemy.rat_director
	
	if !movement_module_node.ready_to_start:
		return
	
	if not rat_director.active:
		return
	
	if rat_director.destructable_objects.size() == 0:
		return
	
	var new_destructable_target: SC_Destructable = rat_director.select_destructable_target()
	var destructable_position = new_destructable_target.get_position()
	
	movement_module_node.set_movement_target(destructable_position)
	
	enemy.current_destructable_target = new_destructable_target
	
	if enemy.is_on_floor():
		state_machine.transition_to('ground')
	else:
		state_machine.transition_to('in_air')

