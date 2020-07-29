extends StateBase

#### AOE STATE #### 

onready var area_node = $Area
var current_tile : Tile = null
var AOE_relatives : Array = []
var area_of_effect


func _ready():
	pass


func update(_delta: float):
	var mouse_pos = owner.get_global_mouse_position()
	var grid_node = get_tree().get_current_scene().get_node("Grid")
	
	var grid_tile_array = grid_node.get_tiles()
	current_tile = find_closest_tile(mouse_pos, grid_tile_array)
	
	owner.set_global_position(mouse_pos)
	
	# If the AOE shape is a column
	if area_of_effect.type == AOE.TYPES.COLUMN:
		var AOE_col_width = int(area_of_effect.v_size.y / 2)
		var current_tile_col = current_tile.get_grid_position().y
		var column_max = Globals.GRID_TILE_SIZE.y - AOE_col_width - 2
		var column = int(clamp(current_tile_col, 0.0, column_max))
		
		current_tile = find_tile_at_pos(Vector2(0, column), grid_tile_array)
	
	var current_tile_pos = current_tile.get_global_position()
	
	# If the tile changed
	if current_tile_pos != area_node.get_global_position():
		area_node.set_global_position(current_tile_pos)
		$Area.clear()
		var AOE_pos_array = find_AOE_tile_pos(grid_tile_array)
		$Area.create_area(AOE_pos_array)


func enter_state():
	area_of_effect = owner.area_of_effect
	
	# Get the relative grid pos of the tiles affected by the area
	if area_of_effect.type == AOE.TYPES.CIRCLE:
		AOE_relatives = get_circle_AOE([Vector2.ZERO], area_of_effect.i_size)
	elif area_of_effect.type == AOE.TYPES.RECT:
		AOE_relatives = get_rect_AOE(area_of_effect.v_size)
	elif area_of_effect.type == AOE.TYPES.COLUMN:
		AOE_relatives = get_rect_AOE(area_of_effect.v_size, false)
	
	owner.sprite_node.set_visible(false)
	area_node.set_visible(true)


func exit_state():
	owner.sprite_node.set_visible(true)
	area_node.set_visible(false)


# Return the closest tile from the given position in the given array of tiles
func find_closest_tile(pos: Vector2, tile_array: Array) -> Tile:
	var closest_tile : Tile = null
	var smallest_dist : float = INF
	
	for tile in tile_array:
		var tile_pos = tile.get_global_position()
		var dist_to_tile = pos.distance_to(tile_pos)
		if dist_to_tile < smallest_dist:
			smallest_dist = dist_to_tile
			closest_tile = tile
	
	return closest_tile


# Return the adjacent positions 
func find_adjacent_positions(pos: Vector2) -> Array:
	return [ Vector2(pos.x + 1, pos.y),
		Vector2(pos.x, pos.y -1),
		Vector2(pos.x - 1, pos.y),
		Vector2(pos.x, pos.y + 1)]


# Get every tile in a given radius
func get_circle_AOE(pos_array: Array, radius: int) -> Array:
	var new_pos_array : Array = pos_array.duplicate()
	
	for pos in pos_array:
		var adjacents : Array = find_adjacent_positions(pos)
		for adj in adjacents:
			if not adj in new_pos_array:
				new_pos_array.append(adj)
	
	if radius -1 > 0:
		new_pos_array = get_circle_AOE(new_pos_array, radius - 1)
	
	return new_pos_array


# Return an array of relative grid position from the given origin
func get_rect_AOE(rect_size: Vector2, origin_centered: bool = true) -> Array:
	var AOE_pos_array : Array = []
	var center = Vector2(int(rect_size.x / 2), int(rect_size.y /2))
	
	# If the rect has a center tile
	for i in range(rect_size.x):
		for j in range(rect_size.y):
			var pos = Vector2(i, j)
			if origin_centered:
				pos -= center
			AOE_pos_array.append(pos)
	
	return AOE_pos_array


# Return a tile at the given grid position, or null if nothing were found
func find_tile_at_pos(pos: Vector2, tiles_array: Array) -> Tile:
	for tile in tiles_array:
		if tile.get_grid_position() == pos:
			return tile
	return null


# Return the reference of the tile at the given relative position of the current, 
# or null if nothing was found
func find_tile_at_relative_grid_pos(current_pos: Vector2, rel_pos: Vector2, grid_array: Array) -> Tile:
	for tile in grid_array:
		var pos = tile.get_grid_position()
		if pos == current_pos + rel_pos:
			return tile
	return null


# Return an array of valid positions
func find_AOE_tile_pos(grid_array : Array) -> Array:
	var current_pos = current_tile.get_grid_position()
	var tile_pos_in_AOE : Array = []
	for rel_pos in AOE_relatives:
		var tile = find_tile_at_relative_grid_pos(current_pos, rel_pos, grid_array)
		if tile:
			var pos = tile.get_global_position()
			tile_pos_in_AOE.append(pos)
	
	return tile_pos_in_AOE
