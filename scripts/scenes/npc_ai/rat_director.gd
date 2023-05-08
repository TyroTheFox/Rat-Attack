extends Node
class_name Rat_Director

@export var rat_list: Array[RatData]
@export_node_path("Node") var enemy_node_path

# Nodes
var stage: Stage
var spawn_timer: Timer
var spawn_node: Node

# Spawn Variables
var spawn_queue: Array[int]
var spawn_wait_time = 10.0
var unique_spawned_rats: Array[int]

var _active = true

# Called when the node enters the scene tree for the first time.
func _ready():
	stage = get_parent()
	
	spawn_node = get_node(enemy_node_path)
	
	spawn_wait_time = stage.stage_data.spawn_delay
	
	generate_spawn_list()
	
	spawn_timer = Timer.new();
	add_child(spawn_timer)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start(spawn_wait_time)

func start():
	_active = true
	spawn_timer.start(spawn_wait_time)

func stop():
	_active = false
	spawn_timer.stop()

func spawn_enemy(enemy: PackedScene, spawn_point: Vector3):
	var new_enemy = enemy.instantiate() as Enemy;
	spawn_node.add_child(new_enemy)
	new_enemy.translate(spawn_point)

func generate_spawn_list():
	for i in range(0, rat_list.size()):
		var rat_data: RatData = rat_list[i]
		
		if (rat_data.scene == null):
			rat_data.scene = load(rat_data.scene_path)
		
		for j in range(0, rat_data.rarity):
			spawn_queue.push_back(i)

func _on_spawn_timer_timeout():
	if not _active:
		return
	
	if spawn_queue.size() == 0:
		generate_spawn_list()
	
	var spawn_points = stage.enemy_spawn_points
	var rand_spawn_point = spawn_points[randi() % spawn_points.size()]
	var enemy_index = spawn_queue.pop_front()
	var enemy_data = rat_list[enemy_index]
	
	var is_UNIQUE = enemy_data.rarity == RatData.RatRarity.UNIQUE
	var UNIQUE_has_been_spawned = unique_spawned_rats.find(enemy_index)
	
	# If Enemy is Unique, make sure to only ever spawn only one of them
	if is_UNIQUE and UNIQUE_has_been_spawned:
		spawn_timer.start(spawn_wait_time)
		return
	else:
		unique_spawned_rats.push_back(enemy_index)
	
	spawn_enemy(enemy_data.scene, rand_spawn_point)
	spawn_timer.start(spawn_wait_time)
