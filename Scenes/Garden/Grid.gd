extends Node2D

#### LOGIC ####

# Generate each tile of the grid
func generate_grid():
	randomize()
	
	var nb_tiles = Globals.GRID_TILE_SIZE
	var tile_size = Globals.TILE_SIZE
	var soil_tile_scene = Globals.soil_tile
	
	for i in range(nb_tiles.x):
		for j in range(nb_tiles.y):
			var tile = soil_tile_scene.instance()
			var tile_pos = Vector2(i * tile_size.x, j * tile_size.y) + tile_size / 2
			tile.set_global_position(tile_pos)
			tile.set_grid_position(Vector2(i, j))
			
			call_deferred("add_child", tile)
			tile.call_deferred("generate_itself")
	
	$GridArea.adapt_grid_area(nb_tiles.x, tile_size)


func clear_grid():
	var tiles_array = get_tiles()
	for tile in tiles_array:
		tile.destroy()


func reroll_grid():
	clear_grid()
	generate_grid()


# Returns every tiles on the grid
func get_tiles() -> Array:
	var tile_array : Array = []
	for child in get_children():
		if child is Tile:
			 tile_array.append(child)
	
	return tile_array


#### INPUTS ####

func _input(event):
	if event.is_action_pressed("RerollGrid"):
		reroll_grid()
