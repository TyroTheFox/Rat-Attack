extends Stage_Component
class_name SC_Has_Gathering_Area

@export_range(0, 500) var variance_distance = 5

var angle_variance = 160
var gathering_point: Marker3D
var spring_arm: SpringArm3D
var collision_shape: CollisionShape3D
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	super._ready()
	spring_arm = $spring_arm
	gathering_point = $spring_arm/gathering_point
	
	spring_arm.spring_length = variance_distance

func register_stage_instance(stage_instance: Stage):
	super.register_stage_instance(stage_instance)

## In global positions
func get_random_position_within_area() -> Vector3:
	var owner_node = owner
	var translation_vector = Vector3(1.0, 1.0, 1.0)
	var random_angle_variance = rng.randf_range(-angle_variance, angle_variance)
	var level_camera = stage.get_active_camera()
	spring_arm.position = owner_node.position
	
	var look_to_vector = spring_arm.global_position.direction_to(level_camera.global_position)
#	look_to_vector = look_to_vector.rotated(Vector3.UP, random_angle_variance)
#	spring_arm.rotation = Vector3.UP * look_to_angle
	spring_arm.rotation = look_to_vector
	
#	translation_vector = translation_vector.rotated(Vector3.UP, look_to_angle) * variance_distance
	
#	var rotated_vector = translation_vector.rotated(Vector3.UP, random_angle_variance).normalized() * variance_distance
	
#	var return_position = gathering_point.global_position * rotated_vector
	var return_position = gathering_point.global_position
#	var direction_vector = owner_node.position.direction_to(camera_position)
#	spring_arm.rotate(Vector3.UP, spring_arm.position.angle_to(camera_position))
#	direction_vector.rotated(Vector3.UP, deg_to_rad(random_angle_variance))
#	direction_vector = direction_vector.rotated(Vector3.UP, )
	
#	var stopping_position = direction_vector * col_shape_radius
#	var stopping_position = collision_shape.position
	
#	ray_cast.target_position = direction_vector
#	ray_cast.force_raycast_update()
#	if ray_cast.is_colliding():
#		return_position = ray_cast.get_collision_point()       
#	else:
#		return_position = direction_vector
#
#	$gathering_point/debug_block.position = return_position
	return return_position
