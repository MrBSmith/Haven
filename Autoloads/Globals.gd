extends Node

#### GLOBALS AUTOLOAD ####

const swamp_tile = preload("res://Scenes/Tiles/Swamp/SwampTile.tscn")
const soil_tile = preload("res://Scenes/Tiles/Soil/SoilTile.tscn")
const water_tile = preload("res://Scenes/Tiles/Water/WaterTile.tscn")
const forest_tile = preload("res://Scenes/Tiles/Forest/ForestTile.tscn")
const grass_tile = preload("res://Scenes/Tiles/Grass/GrassTile.tscn")

var tile_types = [soil_tile, grass_tile, forest_tile, water_tile, swamp_tile]

var window_width = ProjectSettings.get_setting("display/window/size/width")
var window_height = ProjectSettings.get_setting("display/window/size/height")
var window_size = Vector2(window_width, window_height)

const TILE_SIZE = Vector2(16, 16)
const GRID_TILE_SIZE = Vector2(6, 6)
