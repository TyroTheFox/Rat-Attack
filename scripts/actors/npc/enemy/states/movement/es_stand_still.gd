extends enemy_state
class_name ES_Stand_Still

@export_node_path("MeshInstance3D") var meshbox

func s_enter(_msg := {}) -> void:
	enemy.model.look_at(enemy.current_destructable_target.get_position(), Vector3.UP, true)
	enemy.model.rotation.x = 0
	enemy.model.rotation.z = 0
	
	get_node(meshbox).visible = true
	enemy.set_collision_mask_value(2, true)

func s_physics_update(delta):
	var movement_module_node = enemy.movement_module
	var ground_movement = movement_module_node.ground_movement
	var in_air_movement = movement_module_node.in_air_movement
	
	enemy.velocity.x = 0;
	enemy.velocity.z = 0;
	
	if !enemy.is_on_floor():
		enemy.set_velocity(in_air_movement.process_movement(delta, enemy.velocity))
