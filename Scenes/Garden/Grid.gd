extends Node2D

onready var soil_scene = preload("res://Scenes/Tiles/Soil/SoilTile.tscn")

const TILE_SIZE = Vector2(16, 16)
const NB_TILES = 5


func _ready():
	generate_grid()
	$GridArea.adapt_grid_area(NB_TILES, TILE_SIZE)


func generate_grid():
	for i in range(NB_TILES):
		for j in range(NB_TILES):
			var tile = soil_scene.instance()
			tile.set_position(Vector2(i * TILE_SIZE.x, j * TILE_SIZE.y) + TILE_SIZE / 2)
			add_child(tile)


func get_tiles() -> Array:
	var tile_array : Array = []
	for child in get_children():
		if child is Tile:
			 tile_array.append(child)
	
	return tile_array
