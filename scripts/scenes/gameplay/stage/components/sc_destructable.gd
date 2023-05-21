extends Node
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

# Called when the node enters the scene tree for the first time.
func _ready():
	HP = MaxHP
	add_to_group('destructable')

func get_position():
	return get_parent().position

func is_destroyed():
	return HP <= 0

func deal_damage(damage_value: int):
	HP -= damage_value
	
	damage_taken.emit(id, damage_value, HP)
	
	if HP <= 0:
		destroyed.emit(id)

func reset():
	HP = MaxHP
