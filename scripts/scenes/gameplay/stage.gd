extends Node3D
class_name Stage

@export var stage_data: Stage_Data

var player_scene = preload("res://scenes/actors/player/test_player.tscn")

var player_spawn_points: Array[Vector3]
var enemy_spawn_points: Array[Vector3]
var unused_player_spawn_points: Array[Vector3]

var rat_director: Rat_Director

var player_node

@export_node_path("Camera3D") var characterCamera

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(stage_data != null, "Error: Scene " + name + " has no scene data.")
	
	var player_spawn_node = $nav_mesh/level/player_spawn_points
	var enemy_spawn_node = $nav_mesh/level/enemy_spawn_points
	
	for node in player_spawn_node.get_children():
		player_spawn_points.push_back(node.position)
	
	for node in enemy_spawn_node.get_children():
		enemy_spawn_points.push_back(node.position)
	
	unused_player_spawn_points = player_spawn_points.duplicate()
	
	player_node = $players
	
	rat_director = $rat_director
	
	if (player_spawn_points.size() == 0): 
		player_spawn_points.push_back(Vector3(0, 0, 0))
	
	if (enemy_spawn_points.size() == 0): 
		enemy_spawn_points.push_back(Vector3(0, 0, 0))
	
	spawn_players()

func spawn_players():
	var rand_spawn_point = unused_player_spawn_points[randi() % unused_player_spawn_points.size()]
	
	var player = player_scene.instantiate() as Player
	player.level_camera = get_node(characterCamera)
	player_node.add_child( player )
	player.translate(rand_spawn_point);

	
