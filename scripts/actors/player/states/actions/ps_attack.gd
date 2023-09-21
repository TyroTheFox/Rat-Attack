extends player_state
class_name PS_Attack

@export_node_path("Area3D") var hitbox_path

var hitBox: HitBox

func _ready():
	hitBox = get_node(hitbox_path)
	$attack_duration.start()
	$attack_duration.connect("timeout", self._on_attack_duration_end)

func s_enter(_msg := {}) -> void:
	if hitBox.visible and !$attack_duration.is_stopped():
		return
	
	hitBox.visible = true
	$attack_duration.stop()

func _on_attack_duration_end():
	hitBox.visible = false
	state_machine.transition_to('idle')
