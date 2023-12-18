extends State_Chart_Handler
class_name SCH_Base_Rat_Movement

@onready var movement_module: Enemy_Movement = $"../modules"

func _on_stunned():
	entity.stunned = true

func _on_unstunned():
	entity.stunned = false

func _on_pick_target_state_entered():
	var ground_movement = movement_module.ground_movement
	var rat_director = entity.rat_director
	
	if !rat_director:
		return
	
	if !movement_module.ready_to_start:
		return
	
	if not rat_director.active:
		return
	
	if rat_director.destructable_objects.size() == 0:
		return
	
	var new_destructable_target: SC_Destructable = rat_director.select_destructable_target()
	var destructable_position = new_destructable_target.get_position()
	
	movement_module.set_movement_target(destructable_position)
	
	entity.current_destructable_target = new_destructable_target

func _on_stand_still_state_entered():
	entity.model.look_at(entity.current_destructable_target.get_position(), Vector3.UP, true)
	movement_module.hault_movement = true
	
	#$model/mesh/meshbox.visible = true
	entity.set_collision_mask_value(2, true)

func _on_stand_still_state_exited():
	movement_module.hault_movement = false
