extends Node2D

onready var grid_node = $Grid
onready var hand_node = $Hand

signal garden_change_finished

func _ready():
	var _err = connect("garden_change_finished", hand_node, "on_nature_turn_finished")
	
	grid_node.generate_grid()
	var grid_pxl_size = Globals.get_grid_pixel_size()
	
	var hand_space_size = Vector2(Globals.window_width, Globals.window_height - grid_pxl_size.y)
	hand_node.set_position(Vector2(Globals.window_width / 2, grid_pxl_size.y + hand_space_size.y / 2))


func _on_turn_finished():
	emit_signal("garden_change_finished")
