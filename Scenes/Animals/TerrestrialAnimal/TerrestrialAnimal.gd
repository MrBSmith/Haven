extends Animal
class_name TerrestrialAnimal

onready var pathfinder = get_tree().get_current_scene().find_node("Pathfinder")

#### ACCESSORS ####



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


func reach_for_target(tar: PhysicsBody2D):
	.reach_for_target(tar)

#### VIRTUALS ####



#### INPUTS ####

func _input(event : InputEvent):
	if event.is_action_released("click"):
		var mouse_pos = get_global_mouse_position()
		move_to(mouse_pos)

#### SIGNAL RESPONSES ####
