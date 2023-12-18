extends Player_Movement_Module
class_name m_Player_Jump

## How high you jump
@export var jump_height = 6.0
## Time to arc of jump
@export var jump_time = 4.0
## Percentage of a full jump the Minimum Height comes to
@export var minumum_jump_height_percentage = 0.5

## Minimum height a jump can manage
var jump_minHeight = jump_height * minumum_jump_height_percentage
## Calculated Force of Gravity used to calculate a usable jump arc
var gravity
## Speed you jump with
var jump_speed
## Minimum Speed a Jump can create
var jump_minSpeed

# Called when the node enters the scene tree for the first time.
func init(owned_player):
	super.init(owned_player)
	gravity = jump_height/2*(jump_time * jump_time)
	jump_speed = sqrt(2 * jump_height * gravity)
	jump_minSpeed = sqrt(2 * jump_minHeight * gravity)
