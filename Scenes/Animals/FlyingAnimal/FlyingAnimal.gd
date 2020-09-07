extends Animal
class_name FlyingAnimal

export var path_max_curvature : float = 100.0
export var path_min_curvature : float = 20.0

#### ACCESSORS ####



#### BUILT-IN ####



#### LOGIC ####


# Set the path to the target with a random curvature
func set_move_path(path_point_array: Array):
	path_curve.clear_points()
	path_curve.add_point(global_position)
	
	for point in path_point_array:
		var last_point = path_curve.get_baked_points()[0]
		
		if point == last_point:
			continue
		
		var dist = last_point.distance_to(point)
		var curvature = clamp(path_max_curvature * (1 / dist), path_min_curvature, path_max_curvature)
		
		path_curve.add_point(point, 
		Vector2(rand_range(-curvature, curvature), rand_range(-curvature, curvature)), 
		Vector2(rand_range(-curvature, curvature), rand_range(-curvature, curvature)))
	
	path = path_curve.get_baked_points()



#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
