extends Node
class_name Stage_Component

var stage: Stage = null

func _ready():
	add_to_group('stage_component')

func register_stage_instance(stage_instance: Stage):
	stage = stage_instance
