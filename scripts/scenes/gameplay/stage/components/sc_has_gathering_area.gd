extends Stage_Component
class_name SC_Has_Gathering_Area

@export_range(0, 500) var variance_distance = 5
@export_range(0, 360) var angle_variance = 10
@export_node_path("SpringArm3D") var spring_arm_path
@export_node_path("Marker3D") var gathering_point_path

var gathering_point: Marker3D
var spring_arm: SpringArm3D
var collision_shape: CollisionShape3D
var rng = RandomNumberGenerator.new()

var distribution_state = -1

func _ready() -> void:
	super._ready()
	spring_arm = get_node(spring_arm_path)
	gathering_point = get_node(gathering_point_path)
	
	spring_arm.spring_length = variance_distance

func register_stage_instance(stage_instance: Stage):
	super.register_stage_instance(stage_instance)

## In global positions
func get_random_position_within_area() -> Vector3:
	var owner_node = owner
	
	var level_camera = stage.get_active_camera()
	var camera_position = Vector3(level_camera.global_position.x, 0, level_camera.global_position.z)

	spring_arm.look_at(level_camera.position, Vector3.UP, true)
	spring_arm.rotation.x = 0
	spring_arm.rotation.z = 0
	spring_arm.rotation_degrees.y += angle_variance * distribution_state
	
	distribution_state += 0.5
	
	if distribution_state > 1:
		distribution_state = -1
	var return_position = gathering_point.global_position

	return return_position
