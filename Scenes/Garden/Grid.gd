extends Node2D

var moving_seed_scene = preload("res://Scenes/Animations/MovingSeed/MovingSeed.tscn")

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
	
	# Determine the number of grass tile to place btw 15-20, then places it
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

# Return the tile at the given grid coordinates
func get_tile_at_grid_pos(pos : Vector2) -> Tile:
	var tile_array = get_tile_array()
	for tile in tile_array:
		if tile.get_grid_position() == pos:
			return tile
	
	return null


# Return the tile at the given grid coordinates
func get_tile_at_world_pos(world_pos : Vector2) -> Tile:
	if is_pos_outside_grid(world_pos):
		return null

	return find_closest_tile(world_pos)


# Return true if the given pos is outside the grid, false if not
func is_pos_outside_grid(pos: Vector2):
	var max_grid_pos = Globals.GRID_TILE_SIZE * Globals.TILE_SIZE
	
	return pos.x < 0.0 or pos.y < 0.0 or \
	pos.x > max_grid_pos.x or pos.y > max_grid_pos.y


# Generate a moving seed at the given position, with the given velocity and tree_type
func generate_moving_seed(init_pos: Vector2, init_velocity: Vector2, tree_type: PackedScene):
	var new_plant = moving_seed_scene.instance()
	new_plant.set_position(init_pos)
	new_plant.set_velocity(init_velocity)
	new_plant.set_tree_type(tree_type)
	
	new_plant.connect("seed_planted", self, "on_seed_planted")
	$SeedsContainer.add_child(new_plant)


# Return the closest tile from the given world position
func find_closest_tile(pos: Vector2) -> Tile:
	var tile_array = get_tile_array()
	var closest_tile : Tile = null
	var smallest_dist : float = INF
	
	for tile in tile_array:
		var tile_pos = tile.get_global_position()
		var dist_to_tile = pos.distance_to(tile_pos)
		if dist_to_tile < smallest_dist:
			smallest_dist = dist_to_tile
			closest_tile = tile
	
	return closest_tile


#### INPUTS ####

func _input(event):
	if event.is_action_pressed("RerollGrid"):
		reroll_grid()


#### SIGNALS REPSONSES ####

func on_seed_planted(pos: Vector2, tree_type: PackedScene):
	var tile = get_tile_at_world_pos(pos)
	var new_plant : Plant = tree_type.instance()
	
	if tile == null or (not tile is SoilTile and not tile is GrassTile):
		return
	
	if !tile.is_growable():
		return
	
	tile.add_child(new_plant)
	new_plant.current_tile_weakref = weakref(tile)
	new_plant.grid_node = self
	new_plant.set_global_position(pos)
	
	if Globals.debug_state == true:
		print("seed_planted a pos: " + String(tile.get_grid_position()))
