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

var previousSentEvent

var stunned = false

## Sets up player variables
func _ready():
	super._ready()
	movement_module = $movement/modules
	hurtbox = $interaction_areas/hurtbox

func _physics_process(delta):
	movement_module.hault_movement = stunned
	velocity = movement_module.process_movement(delta, velocity, is_on_floor())
	
	move_and_slide()

	if is_on_floor():
		if previousSentEvent != 'grounded':
			movement_state_chart.send_event('ground')
	else:
		if previousSentEvent != 'in_air':
			movement_state_chart.send_event('in_air')

func take_damage():
	movement_state_chart.send_event('stunned')
	action_state_chart.send_event('stunned')

func _on_hurt_destructable_state_entered():
	if current_destructable_target.is_destroyed():
		action_state_chart.send_event('target_destroyed')
	else:
		action_state_chart.send_event('hurt')

func _on_land_damage_state_entered():
	current_destructable_target.deal_damage(damage)
	
	if current_destructable_target.is_destroyed():
		action_state_chart.send_event('idle')
		action_state_chart.send_event('target_destroyed')
	else:
		make_attack_timer.start()
