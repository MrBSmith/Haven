extends Node2D

##### TURN ORDER #####

### -> See the statemachine Phases ###

# 0) The player draw a new card, which triggers his new turn
# 1) The player choose his meteo effect he wants to play
# 2) The meteo effect take place, and affect tiles
# 3) The new animals appear
# 4) The animals behave
# 5) The leaving animal leave the board

onready var grid_node = $Grid
onready var hand_node = $Hand
onready var camera_node = $Camera2D

onready var phase_state_machine = $Phases

#### ACCESSORS ####

func set_phase(value: String): phase_state_machine.set_state(value)
func get_phase_name() -> String: return phase_state_machine.get_state_name()


#### BUILT-IN ####

func _ready():
	var _err = Events.connect("single_plant_animation_finished", self, "_on_single_plant_animation_finished")
	_err = Events.connect("meteo_animation_started", self, "_on_meteo_animation_started")
	_err = Events.connect("meteo_animation_finished", self, "_on_meteo_animation_finished")
	
	_err = phase_state_machine.connect("state_changed", $Grid/DebugPanel, "on_phase_changed")
	
	grid_node.generate_grid()
	var grid_pxl_size = Globals.get_grid_pixel_size()
	
	init_clouds(grid_pxl_size)
	init_hand_size(grid_pxl_size)


#### LOGIC ####

func is_flora_animation_finished() -> bool:
	for plant in get_tree().get_nodes_in_group("Plant"):
		if plant.get_state() == null or plant.get_state().name != "Idle":
			return false
	
	return true


func init_clouds(grid_pxl_size: Vector2):
	var clouds_node = $Grid/MeteoEffects/Clouds
	clouds_node.set_position(grid_pxl_size / 2)
	
	clouds_node.get_node("CloudShader").set_region(true)
	clouds_node.get_node("CloudShader").set_region_rect(Rect2(Vector2.ZERO, grid_pxl_size))
	clouds_node.get_node("ShadowsShader").set_region(true)
	clouds_node.get_node("ShadowsShader").set_region_rect(Rect2(Vector2.ZERO, grid_pxl_size))


func init_hand_size(grid_pxl_size: Vector2):
	var screen_size = Globals.window_size * camera_node.get_zoom()
	
	var hand_space_size = Vector2(screen_size.x, screen_size.y - grid_pxl_size.y)
	var hand_pos = Vector2(screen_size.x / 2, grid_pxl_size.y + hand_space_size.y / 2)
	hand_node.hand_size = hand_space_size
	hand_node.set_position(hand_pos)


#### INPUTS ####


#### SIGNALS RESPONSES ####

func _on_single_plant_animation_finished():
	if is_flora_animation_finished():
		Events.emit_signal("flora_animation_finished")


func _on_meteo_animation_started():
	set_phase("MeteoAnimation")

func _on_meteo_animation_finished():
	set_phase("PlantBehaviour")
