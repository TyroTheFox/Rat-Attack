extends Stage_Component
class_name SC_Has_Gathering_Area

@export_range(0, 360) var variance_angle

var ray_cast: RayCast3D
var collision_shape: CollisionShape3D
var level_camera: Camera3D
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	super._ready()
	collision_shape = $gathering_area/area_shape
	ray_cast = $raycast

func register_stage_instance(stage_instance: Stage):
	super.register_stage_instance(stage_instance)

## In global positions
func get_random_position_within_area() -> Vector3:
	var owner_node = owner
	var bounds_shape = collision_shape.shape
	var col_shape_radius = 0
	
	level_camera = stage.get_active_camera()
	
	if "radius" in bounds_shape:
		col_shape_radius = bounds_shape.radius
	else:
		col_shape_radius = (bounds_shape.size.x * bounds_shape.size.z) / 2
	
	var return_position = Vector3(0, 0, 0)
	var random_angle_variance = rng.randf_range(-variance_angle, variance_angle)
	var camera_position = level_camera.position
	
	var direction_vector = owner_node.position.direction_to(camera_position)
	direction_vector.rotate(Vector3.UP, deg_to_rad(random_angle_variance))
#	direction_vector = direction_vector.rotated(Vector3.UP, )
	
	var stopping_position = direction_vector * col_shape_radius
	
	ray_cast.target_position = direction_vector
	ray_cast.force_raycast_update()
	if ray_cast.is_colliding():
		return_position = ray_cast.get_collision_point()       
	else:
		return_position = direction_vector
	
	$debug_block.translate(return_position)
	return return_position
