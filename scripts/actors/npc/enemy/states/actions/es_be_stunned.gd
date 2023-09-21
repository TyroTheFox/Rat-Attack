extends enemy_state
class_name ES_Be_Stunned

var stun_timer: Timer

func _ready():
	super._ready()
	stun_timer = $stun_timer
	stun_timer.connect('timeout', _on_timeout)

func s_enter(msg: Dictionary = {}):
	stun_timer.stop()
	stun_timer.start()
	enemy.state_machine_movement.transition_to('stand_still')

func _on_timeout():
	state_machine.transition_to('do_nothing_till_idle')
	enemy.state_machine_movement.transition_to('pick_target')
