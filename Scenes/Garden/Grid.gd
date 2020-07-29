extends Node2D

onready var soil_scene = preload("res://Scenes/Tiles/Soil/SoilTile.tscn")

func generate_grid():
	var nb_tiles = Globals.GRID_TILE_SIZE
	var tile_size = Globals.TILE_SIZE
	
	for i in range(nb_tiles.x):
		for j in range(nb_tiles.y):
			var tile = soil_scene.instance()
			tile.set_position(Vector2(i * tile_size.x, j * tile_size.y) + tile_size / 2)
			tile.set_grid_position(Vector2(i, j))
			add_child(tile)
	
	$GridArea.adapt_grid_area(nb_tiles.x, tile_size)


func get_grid_pixel_size():
	return Globals.TILE_SIZE * Globals.GRID_TILE_SIZE.x


func get_tiles() -> Array:
	var tile_array : Array = []
	for child in get_children():
		if child is Tile:
			 tile_array.append(child)
	
	return tile_array
