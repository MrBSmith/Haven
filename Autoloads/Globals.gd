extends Node

#### GLOBALS AUTOLOAD ####

const swamp_tile = preload("res://Scenes/Tiles/Swamp/SwampTile.tscn")
const soil_tile = preload("res://Scenes/Tiles/Soil/SoilTile.tscn")
const water_tile = preload("res://Scenes/Tiles/Water/WaterTile.tscn")
const forest_tile = preload("res://Scenes/Tiles/Forest/ForestTile.tscn")
const grass_tile = preload("res://Scenes/Tiles/Grass/GrassTile.tscn")

const base_tree = preload("res://Scenes/Trees/Tree.tscn")

var tile_types = [soil_tile, grass_tile, forest_tile, water_tile, swamp_tile]
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

#### INPUT ####

func _input(event: InputEvent):
	if event.is_action_pressed("toggle_debug"):
		toggle_debug_state()
