extends Node2D

onready var pathfinder = get_parent()

#### ACCESSORS ####



#### BUILT-IN ####

func _process(_delta):
	update()


func _draw():
	var astar : AStar2D = pathfinder.astar
	var points_id_array = astar.get_points()
	for id in points_id_array:
		if astar.is_point_disabled(id):
			draw_rect(Rect2(pathfinder.get_pos_from_id(id), Vector2.ONE), Color.black)
		else:
			draw_rect(Rect2(pathfinder.get_pos_from_id(id), Vector2.ONE), Color.white)


#### LOGIC ####




#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
