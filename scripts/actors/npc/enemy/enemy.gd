extends NPC
class_name Enemy

@export var damage: int = 1

## Movement Module
var movement_module: Enemy_Movement
## Timer used to measure Coyote Time, a grace period where the player can still jump after falling off a ledge
var make_attack_timer: Timer

## Director node handling central data and AI co-ordination
var rat_director: Rat_Director

## Nav Mesh Navigation Agent Instance
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

var current_destructable_target: SC_Destructable

var hurtbox: HurtBox

## Sets up player variables
func _ready():
	super._ready()
	movement_module = $modules/movement
	make_attack_timer = $make_attack
	hurtbox = $interaction_areas/hurtbox

func _physics_process(_delta):
	move_and_slide()

func take_damage():
	state_machine_actions.transition_to('stunned')
