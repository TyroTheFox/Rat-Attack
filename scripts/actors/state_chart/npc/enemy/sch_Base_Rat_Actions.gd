extends State_Chart_Handler
class_name SCH_Base_Rat_Actions 

func _on_hurt_destructable_state_entered():
	if entity.current_destructable_target and entity.current_destructable_target.is_destroyed():
		send_chart_event('target_destroyed')
	else:
		send_chart_event('hurt')

func _on_land_damage_state_entered():
	var current_destructable_target = entity.current_destructable_target
	
	if not current_destructable_target:
		return
	
	if current_destructable_target.is_destroyed():
		send_chart_event('target_destroyed')
	else:
		current_destructable_target.deal_damage($"../modules".damage)
		send_chart_event('hurt')
		#make_attack_timer.start()
