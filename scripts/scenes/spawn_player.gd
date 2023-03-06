extends Node3D

var player_scene = preload("res://scenes/actors/player/test_player.tscn")

@export_node_path("Camera3D") var characterCamera

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = player_scene.instantiate()
	player.level_camera = get_node(characterCamera)
	add_child( player )
