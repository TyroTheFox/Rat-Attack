extends NPC
class_name Enemy

## Movement Module
var movement_module: Enemy_Movement
## Timer used to measure Coyote Time, a grace period where the player can still jump after falling off a ledge
var coyote_time: Timer

## Nav Mesh Navigation Agent Instance
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

## Sets up player variables
func _ready():
	model = $model
	state_machine = $state_machine
	movement_module = $modules/movement

func _physics_process(_delta):
	move_and_slide()
