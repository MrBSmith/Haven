extends Node2D

onready var grid_node = $Grid
onready var hand_node = $Hand

func _ready():
	var _err = Events.connect("single_plant_animation_finished", self, "_on_single_plant_animation_finished")
	
	grid_node.generate_grid()
	var grid_pxl_size = Globals.get_grid_pixel_size()
	
	var hand_space_size = Vector2(Globals.window_width, Globals.window_height - grid_pxl_size.y)
	hand_node.set_position(Vector2(Globals.window_width / 2, grid_pxl_size.y + hand_space_size.y / 2))


#### LOGIC ####

func is_flora_animation_finished() -> bool:
	for plant in get_tree().get_nodes_in_group("Plant"):
		if plant.get_state().name != "Idle":
			return false
	
	return true

#### SIGNALS RESPONSES ####

func _on_single_plant_animation_finished():
	if is_flora_animation_finished():
		Events.emit_signal("flora_animation_finished")
