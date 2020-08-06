extends Node2D

export (int, 0, 100) var tree_chance_threshold = 20


#### LOGIC ####

func generate_grid():
	randomize()
	
	var nb_tiles = Globals.GRID_TILE_SIZE
	var tile_size = Globals.TILE_SIZE
	var soil_tile_scene = Globals.soil_tile
	var last_tile: Tile = null
	
	for i in range(nb_tiles.x):
		for j in range(nb_tiles.y):
			
			var tile = soil_tile_scene.instance()
			var tile_pos = Vector2(i * tile_size.x, j * tile_size.y) + tile_size / 2
			tile.set_global_position(tile_pos)
			tile.set_grid_position(Vector2(i, j))
			
			call_deferred("add_child", tile)
			
			last_tile = tile
	
	yield(last_tile, "ready")
	
	var grass_scene = Globals.grass
	
	for child in get_children():
		if child is Tile:
			child.generate_plant(grass_scene, 8, 70)
	
	$GridArea.adapt_grid_area(nb_tiles.x, tile_size)


func get_tiles() -> Array:
	var tile_array : Array = []
	for child in get_children():
		if child is Tile:
			 tile_array.append(child)
	
	return tile_array
