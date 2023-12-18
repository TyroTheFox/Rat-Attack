extends CharacterBody3D
class_name Player

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

## Player Model
@onready var model = $model
## Movement Module
@onready var movement_module: Player_Movement = $player_movement/movement/modules
## Player Actions Handler
@onready var player_actions: Player_Action_Handler = $player_movement/actions/player_actions
## Movement State Chart
@onready var movement_SCH: SCH_Player_Movement = $player_movement/movement/state_chart
## State Chart
@onready var action_SCH: SCH_Player_Actions = $player_movement/actions/state_chart
## Camera the player object is handed
var level_camera: Camera3D

var previousSentEvent

func _ready():
	movement_module.init(self)
	player_actions.init(self)
	movement_SCH.init(self)
	action_SCH.init(self)

func _physics_process(delta):
	var cameraBasisVector = level_camera.get_global_transform().basis
	
	velocity = movement_module.process_movement(velocity, is_on_floor(), delta, cameraBasisVector)

	move_and_slide()

	if is_on_floor():
		if previousSentEvent != 'grounded':
			movement_SCH.send_chart_event('grounded')
			previousSentEvent = 'grounded'
	else:
		if previousSentEvent != 'in_air':
			movement_SCH.send_chart_event('in_air')
			previousSentEvent = 'in_air'

func _on_attack_state_entered():
	var hitBox: HitBox = $interaction_areas/attack_hitbox
	
	hitBox.visible = true
	movement_SCH.send_chart_event('idle')

func _on_attack_state_exited():
	var hitBox: HitBox = $interaction_areas/attack_hitbox
	
	hitBox.visible = false
