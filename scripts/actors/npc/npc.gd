extends CharacterBody3D
class_name NPC

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

## NPC Model
var model
## Camera the player object is handed
var level_camera: Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	model = $model

func _physics_process(_delta):
	move_and_slide()
