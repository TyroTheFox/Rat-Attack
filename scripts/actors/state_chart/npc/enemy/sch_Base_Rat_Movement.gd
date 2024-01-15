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
	if entity.current_destructable_target:
		var lookAtTarget = entity.current_destructable_target.get_position()
		entity.rotation.y = lerp_angle(entity.rotation.y, atan2(lookAtTarget.x, lookAtTarget.z), 1)
	movement_module.hault_movement = true
	$"../../actions/state_chart".send_chart_event('hurt')
	
	#$model/mesh/meshbox.visible = true
	entity.set_collision_mask_value(2, true)

func _on_stand_still_state_exited():
	movement_module.hault_movement = false

func _on_land_damage_state_entered():
	var current_destructable_target = entity.current_destructable_target
	
	if not current_destructable_target:
		return
	
	if current_destructable_target.is_destroyed():
		send_chart_event('target_destroyed')
