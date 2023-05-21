extends NPC
class_name Enemy

## Movement Module
var movement_module: Enemy_Movement
## Timer used to measure Coyote Time, a grace period where the player can still jump after falling off a ledge
var make_attack_timer: Timer

## Director node handling central data and AI co-ordination
var rat_director: Rat_Director

## Nav Mesh Navigation Agent Instance
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

var current_destructable_target: SC_Destructable

var damage = 1

## Sets up player variables
func _ready():
	model = $model
	state_machine_movement = $state_machine_movement
	state_machine_actions = $state_machine_actions
	movement_module = $modules/movement
	make_attack_timer = $make_attack

func _physics_process(_delta):
	move_and_slide()
