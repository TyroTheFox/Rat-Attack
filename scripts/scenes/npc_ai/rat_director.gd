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
var id_count = 0

var destructable_objects: Array[SC_Destructable]

var active = true : 
	get:
		return active

# Called when the node enters the scene tree for the first time.
func _ready():
	stage = get_parent()
	
	spawn_node = get_node(enemy_node_path)
	
	spawn_wait_time = stage.stage_data.spawn_delay
	
	generate_spawn_list()
	
	spawn_timer = Timer.new();
	add_child(spawn_timer)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

func start():
	for node in get_tree().get_nodes_in_group('destructable'):
		var destructable_component = node.find_child('SC_Destructable', true)
		if (destructable_component):
			destructable_objects.push_back(destructable_component)
			destructable_component.id = id_count
			id_count += 1
			destructable_component.connect('destroyed', _on_destructable_detroyed)
	
	active = true
	spawn_timer.start(spawn_wait_time)

func stop():
	active = false
	spawn_timer.stop()

func spawn_enemy(enemy: PackedScene, spawn_point: Vector3):
	var new_enemy = enemy.instantiate() as Enemy;
	
	new_enemy.rat_director = self
	spawn_node.add_child(new_enemy)
	new_enemy.translate(spawn_point)

func select_destructable_target() -> SC_Destructable:
	var random_index = randi() % destructable_objects.size()
	var random_destructable = destructable_objects[random_index]
	
	return random_destructable

func generate_spawn_list():
	for i in range(0, rat_list.size()):
		var rat_data: RatData = rat_list[i]
		
		if (rat_data.scene == null):
			rat_data.scene = load(rat_data.scene_path)
		
		for j in range(0, rat_data.rarity):
			spawn_queue.push_back(i)

func prepare_to_spawn_enemy():
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

func _on_destructable_detroyed(id: int):
	var destructable = destructable_objects.filter(func(object: SC_Destructable): return object.id == id)
	
	if destructable.size() > 0:
		if (destructable[0] as SC_Destructable).is_connected('destroyed', _on_destructable_detroyed):
			(destructable[0] as SC_Destructable).connect('destroyed', _on_destructable_detroyed)
		destructable_objects.erase(destructable[0])

func _on_spawn_timer_timeout():
	if not active:
		return
	
	prepare_to_spawn_enemy()
