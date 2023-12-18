extends Node
class_name Player_Movement_Module

## Player node
var player
## Parent Module
var parent_module
## Vector for the Level Camera
var cameraBasisVector
## Player Mesh
var mesh

## Direction the player is moving in
var movement_dir = Vector3()

## Horizontal velocity
var hv: Vector3 = Vector3(0, 0, 0)
## Horizontal direction
var hdir: Vector3 = Vector3(0, 0, 0)
## Horizontal speed
var hspeed = 0

# Called when the node enters the scene tree for the first time.
func init(owned_player: Player):
	player = owned_player
	assert(player != null)
	
	cameraBasisVector = player.level_camera.get_global_transform().basis
	mesh = player.model
	
	parent_module = get_parent()
