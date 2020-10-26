extends Node2D

#### GLOBALS AUTOLOAD ####

const tile = preload("res://Scenes/Tiles/Tile.tscn")

var tiles_type = {
	"Swamp" : preload("res://Scenes/Tiles/TileType/WetTiles/Swamp/SwampTile.tscn"),
	"Soil" : preload("res://Scenes/Tiles/TileType/DryTiles/Soil/SoilTile.tscn"),
	"Water" : preload("res://Scenes/Tiles/TileType/WetTiles/Water/WaterTile.tscn"),
	"Grass" : preload("res://Scenes/Tiles/TileType/DryTiles/Grass/GrassTile.tscn"),
	"Sand" : preload("res://Scenes/Tiles/TileType/DryTiles/Sand/SandTile.tscn")
}

const base_tree = preload("res://Scenes/Plants/Trees/Tree.tscn")
const grass = preload("res://Scenes/Plants/SmallPlants/Grass.tscn")
const blue_flower = preload("res://Scenes/Plants/SmallPlants/Flowers/BlueFlower/BlueFlower.tscn")
const red_flower = preload("res://Scenes/Plants/SmallPlants/Flowers/RedFlower/RedFlower.tscn")

var tree_types = [base_tree]
var flower_types = [blue_flower, red_flower]

const lightning_scene = preload("res://Scenes/Projectile/Lightning.tscn")
const lighting_main_branch = preload("res://Scenes/Projectile/LightingMainBranch.tscn")
const lighting_branch = preload("res://Scenes/Projectile/LightingProjectile.tscn")

const fire_fx = preload("res://Scenes/VFX/Fire.tscn")

var window_width = ProjectSettings.get_setting("display/window/size/width")
var window_height = ProjectSettings.get_setting("display/window/size/height")
var window_size = Vector2(window_width, window_height)

const TILE_SIZE = Vector2(500, 500)
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

# Retrun the upsacling of the current tile size form the former 16*16 size
func get_tile_upscale() -> Vector2:
	return Vector2(TILE_SIZE / Vector2(16, 16))

#### INPUT ####

func _input(_event: InputEvent):
	if Input.is_action_just_pressed("toggle_debug"):
		toggle_debug_state()
		
	# Lightning test onclick generation
#	if Input.is_action_just_pressed("click"):
#		generate_thunder_debug(get_global_mouse_position())


#### DEBUG FUNCTIONS ####

func generate_thunder_debug(pos: Vector2):
	var lightning = lightning_scene.instance()
	lightning.impact_point = pos
	add_child(lightning)
  
