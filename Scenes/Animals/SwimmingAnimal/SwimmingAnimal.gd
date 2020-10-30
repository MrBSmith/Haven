extends Animal
class_name SwimmingAnimal

onready var pathfinder = get_tree().get_current_scene().find_node("WaterPathfinder")

#### ACCESSORS ####

func is_class(type): return type == "SwimmingAnimal" or .is_class(type)
func get_class(): return "SwimmingAnimal"

#### BUILT-IN ####



#### LOGIC ####

# Set the move path (Straight line to the target)
func set_move_path(path_point_array: Array):
	path_curve.clear_points()
	path_curve.add_point(global_position)
	
	for point in path_point_array:
		var last_point = path_curve.get_baked_points()[0]
		
		if point == last_point:
			continue
		
		var path_segment = pathfinder.get_simple_path(last_point, point)
		
		if path_segment.empty():
			path = []
			return
		
		for segment_point in path_segment:
			path_curve.add_point(segment_point)
	
	path = path_curve.get_baked_points()



#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
