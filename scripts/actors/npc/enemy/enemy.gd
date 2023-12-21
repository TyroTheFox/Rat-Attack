extends NPC
class_name Enemy

## Movement Module
@onready var movement_module: Enemy_Movement = $base_rat_movement/movement/modules
@onready var movement_SCH: SCH_Base_Rat_Movement = $base_rat_movement/movement/state_chart
@onready var actions_module: Enemy_Actions = $base_rat_movement/actions/modules
@onready var actions_SCH: SCH_Base_Rat_Actions = $base_rat_movement/actions/state_chart
## Timer used to measure Coyote Time, a grace period where the player can still jump after falling off a ledge
var make_attack_timer: Timer

## Director node handling central data and AI co-ordination
var rat_director: Rat_Director

## Nav Mesh Navigation Agent Instance
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

var current_destructable_target: SC_Destructable

@onready var hurtbox: HurtBox = $interaction_areas/hurtbox

var previousSentEvent

var stunned = false

## Sets up player variables
func _ready():
	super._ready()

func init(r_d: Rat_Director):
	rat_director = r_d
	
	movement_module.init(self)
	movement_SCH.init(self)
	
	actions_module.init(self)
	actions_SCH.init(self)

func _physics_process(delta):
	movement_module.hault_movement = stunned
	velocity = movement_module.process_movement(delta, velocity, is_on_floor())
	
	move_and_slide()

	if is_on_floor():
		if previousSentEvent != 'grounded':
			movement_SCH.send_chart_event('ground')
	else:
		if previousSentEvent != 'in_air':
			movement_SCH.send_chart_event('in_air')

func take_damage():
	movement_SCH.send_chart_event('stunned')
	actions_SCH.send_chart_event('stunned')
