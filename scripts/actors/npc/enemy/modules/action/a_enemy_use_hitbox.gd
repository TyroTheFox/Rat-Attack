extends Enemy_Actions
class_name a_Enemy_use_hitbox

@export var hitbox_flash_duration: float = 0.5
@export_node_path("Area3D") var hitbox_node_path: NodePath

var timer_node: Timer
var hitbox_node: HitBox

func _ready():
	var timer_node = Timer.new()
	add_child(timer_node)
	hitbox_node = get_node_or_null(hitbox_node_path)
	assert(hitbox_node, "Hitbox Node not set or not found at given path")
	hitbox_node.visible = false
	timer_node.timeout.connect(_on_timer_timeout)

func flash_hitbox(flash_duration_override = null):
	hitbox_node.visible = true
	timer_node.stop()
	
	if flash_duration_override:
		timer_node.start(flash_duration_override)
	else:
		timer_node.start(hitbox_flash_duration)

func _on_timer_timeout():
	hitbox_node.visible = false
