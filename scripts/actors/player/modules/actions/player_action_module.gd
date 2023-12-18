extends Node
class_name Player_Action_Module

var player: Player

var activated = false

# Called when the node enters the scene tree for the first time.
func init(owned_player: Player):
	player = owned_player
	assert(player != null)
	
	set_up()

func set_up():
	pass

func activate( _action_strength ):
	activated = true

func release():
	activated = false

func update( _delta, _button ):
	pass
