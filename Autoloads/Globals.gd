extends Node

#### GLOBALS AUTOLOAD ####

const tile = preload("res://Scenes/Tiles/Tile.tscn")

var tiles_type = {
	"Swamp" : preload("res://Scenes/Tiles/TileType/Swamp/SwampTile.tscn"),
	"Soil" : preload("res://Scenes/Tiles/TileType/Soil/SoilTile.tscn"),
	"Water" : preload("res://Scenes/Tiles/TileType/Water/WaterTile.tscn"),
	"Grass" : preload("res://Scenes/Tiles/TileType/Grass/GrassTile.tscn"),
	"Sand" : preload("res://Scenes/Tiles/TileType/Sand/SandTile.tscn")
}

const base_tree = preload("res://Scenes/Plants/Trees/Tree.tscn")
const grass = preload("res://Scenes/Plants/SmallPlants/Grass.tscn")
const blue_flower = preload("res://Scenes/Plants/SmallPlants/Flowers/BlueFlower/BlueFlower.tscn")
const red_flower = preload("res://Scenes/Plants/SmallPlants/Flowers/RedFlower/RedFlower.tscn")

var tree_types = [base_tree]
var flower_types = [blue_flower, red_flower]

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
