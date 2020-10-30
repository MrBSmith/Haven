extends Node2D

onready var pathfinder = get_parent()
var point_size := Vector2(25, 25)

#### ACCESSORS ####



#### BUILT-IN ####

func _process(_delta):
	update()


func _draw():
	var astar : AStar2D = pathfinder.astar
	var points_id_array = astar.get_points()
	
	for id in points_id_array:
		var point_pos = pathfinder.get_world_pos_from_id(id) - point_size / 2
		if astar.is_point_disabled(id):
			draw_rect(Rect2(point_pos, point_size), Color.red)
		else:
			draw_rect(Rect2(point_pos, point_size), Color.transparent)


#### LOGIC ####




#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
