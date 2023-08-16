extends Node
class_name Player_Action_Module

var player

var activated = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# The states are children of the `Player` node so their `_ready()` callback will execute first.
	# That's why we wait for the `owner` to be ready first.
	await owner.ready
	# The `as` keyword casts the `owner` variable to the `Player` type.
	# If the `owner` is not a `Player`, we'll get `null`.
	player = owner as Player
	# This check will tell us if we inadvertently assign a derived state script
	# in a scene other than `Player.tscn`, which would be unintended. This can
	# help prevent some bugs that are difficult to understand.
	assert(player != null)
	
	set_up()

func set_up():
	pass

func activate( _delta, _button ):
	pass

func update( _delta, _button ):
	pass
