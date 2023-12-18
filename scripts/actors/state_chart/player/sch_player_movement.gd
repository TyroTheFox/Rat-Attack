extends State_Chart_Handler
class_name SCH_Player_Movement

@onready var movement_module: Player_Movement = $"../modules"

func _handle_jumping(_delta):
	if movement_module.jumping:
		entity.velocity = movement_module.handleJumpingMovement(entity.velocity, state_chart)

func _on_jumping_event_received(event):
	if event == "early_release" and movement_module.early_release:
		entity.velocity = movement_module.handleEarlyJumpTermination(entity.velocity, state_chart)

func _on_cannot_jump_state_entered():
	movement_module.early_release = false
