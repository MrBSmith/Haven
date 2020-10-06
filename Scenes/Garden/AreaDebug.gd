extends Node2D

#### ACCESSORS ####



#### BUILT-IN ####

func _ready():
	if !visible:
		queue_free()


func _process(_delta):
	var grid_node = get_parent()
	var mouse_pos = get_global_mouse_position()
	
	var tile_under_mouse = grid_node.get_tile_at_world_pos(mouse_pos)
	if tile_under_mouse == null:
		return
	
	var tile_pos = tile_under_mouse.get_grid_position()
	var tiles_in_radius = grid_node.get_tiles_in_radius(tile_pos, 2)
	
	var area_node = $AOEarea
	area_node.clear()
	area_node.create_area(tiles_in_radius)


#### LOGIC ####



#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
