extends enemy_state
class_name ES_Hurt_Destructable

var destruction_target: SC_Destructable

func s_enter(msg: Dictionary = {}):
	var make_attack_timer = enemy.make_attack_timer
	
	make_attack_timer.connect('timeout', _on_timeout)
	make_attack_timer.start()
	destruction_target = enemy.current_destructable_target

func _on_timeout():
	var make_attack_timer = enemy.make_attack_timer
	var movement_state_machine = enemy.state_machine_movement
	var damage_to_deal = enemy.damage
	destruction_target.deal_damage(damage_to_deal)
	
	if destruction_target.is_destroyed():
		state_machine.transition_to('do_nothing_till_idle')
		movement_state_machine.transition_to('pick_target')
		make_attack_timer.disconnect('timeout', _on_timeout)
	else:
		make_attack_timer.start()
