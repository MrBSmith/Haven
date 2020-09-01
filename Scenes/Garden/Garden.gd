extends Node2D

onready var grid_node = $Grid
onready var hand_node = $Hand

func _ready():
	var _err = Events.connect("single_plant_animation_finished", self, "_on_single_plant_animation_finished")
	
	grid_node.generate_grid()
	var grid_pxl_size = Globals.get_grid_pixel_size()
	
	var clouds_node = $Grid/MeteoEffects/Clouds
	clouds_node.set_position(grid_pxl_size / 2)
	clouds_node.get_node("CloudShader").set_region(true)
	clouds_node.get_node("CloudShader").set_region_rect(Rect2(Vector2.ZERO, grid_pxl_size))
	clouds_node.get_node("ShadowsShader").set_region(true)
	clouds_node.get_node("ShadowsShader").set_region_rect(Rect2(Vector2.ZERO, grid_pxl_size))
	
	var hand_space_size = Vector2(Globals.window_width, Globals.window_height - grid_pxl_size.y)
	hand_node.set_position(Vector2(Globals.window_width / 2, grid_pxl_size.y + hand_space_size.y / 2))


#### LOGIC ####

func is_flora_animation_finished() -> bool:
	for plant in get_tree().get_nodes_in_group("Plant"):
		if plant.get_state() == null or plant.get_state().name != "Idle":
			return false
	
	return true

#### SIGNALS RESPONSES ####

func _on_single_plant_animation_finished():
	if is_flora_animation_finished():
		Events.emit_signal("flora_animation_finished")


func _on_new_turn_started():
	propagate_call("new_turn")
