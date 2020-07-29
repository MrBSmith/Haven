extends Node2D

onready var grid_node = $Grid
onready var hand_node = $Hand

func _ready():
	$Grid.generate_grid()
	var grid_pxl_size = $Grid.get_grid_pixel_size()
	
	var hand_space_size = Vector2(Globals.window_width, Globals.window_height - grid_pxl_size.y)
	hand_node.set_position(Vector2(Globals.window_width / 2, grid_pxl_size.y + hand_space_size.y / 2))
