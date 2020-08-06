extends Node2D

var base_tiles_array = [
	Globals.grass_tile,
	Globals.soil_tile
]

export (int, 0, 100) var tree_chance_threshold = 20


#### LOGIC ####

func generate_grid():
	randomize()
	var nb_tiles = Globals.GRID_TILE_SIZE
	var tile_size = Globals.TILE_SIZE
	var last_tile: Tile = null
	
	for i in range(nb_tiles.x):
		for j in range(nb_tiles.y):
			
			# Generate the tile at the right position
			var rng = randi() % 2
			var tile = base_tiles_array[rng].instance()
			var tile_pos = Vector2(i * tile_size.x, j * tile_size.y) + tile_size / 2
			tile.set_global_position(tile_pos)
			tile.set_grid_position(Vector2(i, j))
			
			call_deferred("add_child", tile)
			
			last_tile = tile
	
	yield(last_tile, "ready")
	
	for tile in get_children():
		if tile is Grass:
			generate_trees_on_tile(tile)
	
	
	$GridArea.adapt_grid_area(nb_tiles.x, tile_size)


# Generate trees (from one to three per tile) on the given grass tile
func generate_trees_on_tile(tile: Grass):
	randomize()
	var tree_array : Array = []
	var nb_tree_rng = randi() % 3 + 1
	for _i in range(nb_tree_rng):
		var rng_tree = randi() % 100
		if rng_tree < tree_chance_threshold:
			
			# Generate new positions until one is correct
			var pos = random_tile_position()
			while(!is_seed_correct_position(tree_array, pos)):
				pos = random_tile_position()
			
			var new_tree = Globals.tree_types[0].instance()
			tile.add_plant(new_tree, pos)
			tree_array.append(new_tree)


# Return true if the given position is far enough (the minimum distance is defined by min_dist)
# from every seed in the seed array
func is_seed_correct_position(seed_array: Array, pos: Vector2, min_dist: float = 2.0) -> bool:
	for current_seed in seed_array:
		if current_seed.get_position().distance_to(pos) < min_dist:
			return false
	return true


# Genenerate a random position in the tile
func random_tile_position() -> Vector2:
	var margin = Globals.TILE_SIZE / 20
	var min_pos = -Globals.TILE_SIZE / 2 + margin
	var max_pos = Globals.TILE_SIZE / 2 - margin
	
	return Vector2(rand_range(min_pos.x, max_pos.x), rand_range(min_pos.y, max_pos.y))


func get_tiles() -> Array:
	var tile_array : Array = []
	for child in get_children():
		if child is Tile:
			 tile_array.append(child)
	
	return tile_array
