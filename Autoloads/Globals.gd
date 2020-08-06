extends Node

#### GLOBALS AUTOLOAD ####

const swamp_tile = preload("res://Scenes/Tiles/Swamp/SwampTile.tscn")
const soil_tile = preload("res://Scenes/Tiles/Soil/SoilTile.tscn")
const water_tile = preload("res://Scenes/Tiles/Water/WaterTile.tscn")

const base_tree = preload("res://Scenes/Plants/Trees/Tree.tscn")

const grass = preload("res://Scenes/Plants/SmallPlants/Grass.tscn")


var tile_types = [soil_tile, water_tile, swamp_tile]
var tree_types = [base_tree]

var window_width = ProjectSettings.get_setting("display/window/size/width")
var window_height = ProjectSettings.get_setting("display/window/size/height")
var window_size = Vector2(window_width, window_height)

const TILE_SIZE = Vector2(16, 16)
const GRID_TILE_SIZE = Vector2(6, 6)


var debug_state : bool = false setget set_debug_state, get_debug_state

#### ACCESSORS ####

func set_debug_state(value: bool):
	debug_state = value

func get_debug_state() -> bool:
	return debug_state

func toggle_debug_state():
	set_debug_state(!get_debug_state())

#### LOGIC ####

# Return the size of the grid in pixels
func get_grid_pixel_size():
	return TILE_SIZE * GRID_TILE_SIZE

#### INPUT ####

func _input(event: InputEvent):
	if event.is_action_pressed("toggle_debug"):
		toggle_debug_state()
