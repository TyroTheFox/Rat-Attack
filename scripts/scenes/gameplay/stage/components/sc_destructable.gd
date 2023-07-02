extends Stage_Component
class_name SC_Destructable

signal damage_taken(id, damage_value, current_HP)
signal destroyed(id)

@export var MaxHP = 1

var id = -1 :
	get:
		return id
	set(new_id):
		id = new_id

var HP = 0
var position: Vector3

var has_gathering_area_component: SC_Has_Gathering_Area

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	HP = MaxHP
	var base_node = get_owner()
	base_node.add_to_group('destructable')
	position = get_parent().position
	has_gathering_area_component = $SC_Has_Gathering_Area

func get_position():
	if (has_gathering_area_component):
		return has_gathering_area_component.get_random_position_within_area()
	else:
		return get_parent().global_position

func is_destroyed():
	return HP <= 0

func deal_damage(damage_value: int):
	HP -= damage_value
	
	damage_taken.emit(id, damage_value, HP)
	
	if HP <= 0:
		get_parent().visible = false
		destroyed.emit(id)

func reset():
	HP = MaxHP
