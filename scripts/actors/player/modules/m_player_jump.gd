extends Node
class_name m_Player_Jump_Movement

## Parent Module
var parent_module

## Player node
var player

## How high you jump
@export var jump_height = 6.0
## Time to arc of jump
@export var jump_time = 4.0

## Minimum height a jump can manage
var jump_minHeight = jump_height / 0.5

## Speed you jump with
var jump_speed
## When you can stop a jump early
var early_jump_termination

# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready
	player = owner as Player
	assert(player != null)
	
	parent_module = player.movement_module
	
	jump_speed = sqrt(2 * jump_height * parent_module.gravity)
	early_jump_termination = parent_module.gravity / jump_speed
