extends Node2D

#### ACCESSORS ####

func get_tile_array() -> Array:
	var tile_array : Array = []
	for child in get_children():
		if child is Tile:
			tile_array.append(child)
	return tile_array

#### LOGIC ####

# Generate each tile of the grid
func generate_grid():
	randomize()
	
	var nb_tiles = Globals.GRID_TILE_SIZE
	var free_pos_array = []
	
	for i in range(nb_tiles.x):
		for j in range(nb_tiles.y):
			free_pos_array.append(Vector2(i, j))
	
	# Determine the number of water tile to place btw 5-8, then places it
	var nb_water_tile = randi() % 4 + 5
	place_tiles_on_grid(Globals.water_tile, free_pos_array, nb_water_tile)
	
	# Determine the number of grass tile to place btw 5-8, then places it
	var nb_grass_tile = randi() % 5 + 15
	place_tiles_on_grid(Globals.grass_tile, free_pos_array, nb_grass_tile)
	
	# Fill the rest with soil tiles
	place_tiles_on_grid(Globals.soil_tile, free_pos_array)
	
	for child in get_children():
		if child is Tile:
			child.generate_flora()
	
	$GridArea.adapt_grid_area(nb_tiles.x, Globals.TILE_SIZE)


# Place the given type of tile, the given number of time, in the free slot in the grid (stocked in the free_pos_array)
# If no tile number is provided, fill the rest of the grid
func place_tiles_on_grid(tile_type: PackedScene, free_pos_array: Array, nb_tile: int = 0):
	for _i in range(nb_tile):
		var rdm_tile_id = randi() % free_pos_array.size()
		place_single_tile(tile_type, free_pos_array[rdm_tile_id])
		free_pos_array.remove(rdm_tile_id)
	
	if nb_tile == 0:
		for free_pos in free_pos_array:
			place_single_tile(tile_type, free_pos)
		
		free_pos_array.resize(0)


func place_single_tile(tile_type: PackedScene, grid_position: Vector2):
	var tile_size = Globals.TILE_SIZE
	var new_tile = tile_type.instance()
	
	new_tile.set_position(grid_position * tile_size + (tile_size / 2))
	new_tile.set_grid_position(grid_position)
	add_child(new_tile)


func clear_grid():
	var tile_array = get_tile_array()
	for tile in tile_array:
		tile.queue_free()


func reroll_grid():
	clear_grid()
	generate_grid()


#### INPUTS ####

func _input(event):
	if event.is_action_pressed("RerollGrid"):
		reroll_grid()
