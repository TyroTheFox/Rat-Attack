extends CharacterBody3D
class_name Player

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

## Player Model
var model
## Camera the player object is handed
var level_camera: Camera3D
## Player State Machine
var state_machine: StateMachine
## Player Action State Machine
var action_state_machine: StateMachine

## Movement Module
var movement_module: Player_Movement
## Timer used to measure Coyote Time, a grace period where the player can still jump after falling off a ledge
var coyote_time: Timer

## Sets up player variables
func _ready():
	model = $model
	state_machine = $state_machine_movement
	action_state_machine = $state_machine_actions
	movement_module = $modules/movement
	coyote_time = $coyote_time

func _physics_process(_delta):
	move_and_slide()
