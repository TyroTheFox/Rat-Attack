extends Resource
class_name RatData

enum RatRarity {COMMON = 4, UNCOMMON = 3, RARE = 2, UNIQUE = 1}

@export var name: String
@export var display_name: String
@export_file("e_*.tscn") var scene_path
@export var rarity: RatRarity

var scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _init(
	rat_name: String = "rat", 
	rat_display_name: String = "Rat", 
	rat_scene_path: String = "", 
	rat_rarity: RatRarity = RatRarity.COMMON
	):
	name = rat_name
	display_name = rat_display_name
	scene_path = rat_scene_path
	rarity = rat_rarity
