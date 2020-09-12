extends CanvasLayer

var grid_node : Node2D

#### ACCESSORS ####



#### BUILT-IN ####

func _ready():
	yield(get_parent(), "ready")
	grid_node = get_parent()


#### LOGIC ####

func _physics_process(_delta):
	$VBoxContainer.set_visible(Globals.debug_state)
	
	if Globals.debug_state == true:
		update_cursor_tile_label()


func update_cursor_tile_label():
	var mouse_pos = grid_node.get_global_mouse_position()
	var current_tile = grid_node.get_tile_at_world_pos(mouse_pos)
	
	if current_tile == null:
		return
	
	var current_tile_pos = current_tile.get_grid_position()
	$VBoxContainer/CursorTile.set_text("CursorTile: " + String(current_tile_pos))
	$VBoxContainer/CursorPos.set_text("CursorPos: " + String(mouse_pos))


#### INPUTS ####



#### SIGNAL RESPONSES ####
