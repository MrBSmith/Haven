extends StateBase
class_name TargetCardState

#### AOE STATE #### 

signal wind_direction_changed

var area_node : Node2D
var current_tile : Tile = null
var AOE_relatives : Array = []
var area_of_effect
var affected_tiles_array : Array = []
var wind_direction := Vector2.UP setget set_wind_direction, get_wind_direction

#### ACCESSORS ####

func set_wind_direction(value: Vector2):
	if !value.is_normalized():
		value = value.normalized()
	
	var changed = wind_direction != value
	wind_direction = value
	
	if changed:
		emit_signal("wind_direction_changed", wind_direction)

func get_wind_direction() -> Vector2:
	return wind_direction

#### BUILT-IN ####

func _ready():
	yield(owner, "ready")
	area_node = owner.get_node("Area")
	
	var _err = connect("wind_direction_changed", self, "on_wind_direction_changed")


#### VIRUTALS ####

func update(_delta: float):
	var mouse_pos = owner.get_global_mouse_position()
	var grid_node = get_tree().get_current_scene().get_node("Grid")
	var grid_tile_array = grid_node.get_tiles()
	current_tile = find_closest_tile(mouse_pos, grid_tile_array)
	
	owner.set_global_position(mouse_pos)
	
	# Get the wind direction if the card is a wind card
	if owner is WindCard:
		set_wind_direction(compute_wind_direction(mouse_pos))
	
	# If the AOE shape is a rect: clamp the position accordingly
	if area_of_effect.type == AOE.TYPES.RECT:
		current_tile = find_correct_tile_rectAOE(grid_tile_array, wind_direction)
	
	# Get the position of the current tile
	var current_tile_pos = current_tile.get_global_position()
	
	# If the tile changed
	if current_tile_pos != area_node.get_global_position():
		area_node.set_global_position(current_tile_pos)
		area_node.clear()
		affected_tiles_array = find_tiles_in_AOE(grid_tile_array)
		area_node.create_area(affected_tiles_array)


func enter_state(_previous_state: StateBase):
	area_of_effect = owner.area_of_effect
	
	# Get the relative grid pos of the tiles affected by the area
	if area_of_effect.type == AOE.TYPES.CIRCLE:
		AOE_relatives = get_circle_AOE([Vector2.ZERO], area_of_effect.i_size)
	elif area_of_effect.type == AOE.TYPES.RECT:
		AOE_relatives = get_rect_AOE(area_of_effect.v_size)
	
	owner.sprite_node.set_visible(false)


func exit_state(next_state: StateBase):
	if next_state.name != "Effect":
		owner.sprite_node.set_visible(true)
		area_node.clear()


#### LOGIC ####


# Find the correct tile to be the origin of the AOE, based on the rect and the direction of it
func find_correct_tile_rectAOE(grid_tile_array: Array, wind_dir: Vector2) -> Tile:
	var area_size = area_of_effect.v_size
	if wind_dir == Vector2.LEFT or wind_dir == Vector2.RIGHT:
		area_size = Vector2(area_size.y, area_size.x)
	var AOE_extents = Vector2(int(area_size.x / 2), int(area_size.y / 2))
	
	var current_tile_pos = current_tile.get_grid_position()
	var max_grid_pos = Globals.GRID_TILE_SIZE - AOE_extents
	
	max_grid_pos -= Vector2(abs(wind_dir.y), abs(wind_dir.x))
	
	var line = int(clamp(current_tile_pos.x, AOE_extents.x, max_grid_pos.x))
	var column = int(clamp(current_tile_pos.y, AOE_extents.y, max_grid_pos.y))
	
	return find_tile_at_pos(Vector2(line, column), grid_tile_array)


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
func get_rect_AOE(rect_size: Vector2, dir: Vector2 = Vector2.UP) -> Array:
	var AOE_pos_array : Array = []
	var center = Vector2(int(rect_size.x / 2), int(rect_size.y /2))
	if dir == Vector2.LEFT or dir == Vector2.RIGHT:
		center = Vector2(center.y, center.x)
	
	for i in range(rect_size.x):
		for j in range(rect_size.y):
			var pos
			
			if dir == Vector2.UP or dir == Vector2.DOWN:
				pos = Vector2(i, j)
			else:
				pos = Vector2(j, i)
			
			pos -= center
			
			AOE_pos_array.append(pos)
	
	return AOE_pos_array


# Return the direction of the wind based on the position of the mouse
func compute_wind_direction(mouse_pos: Vector2) -> Vector2:
	var dir := Vector2.ZERO
	var grid_px_size = Globals.get_grid_pixel_size()
	
	var upper_right : bool = mouse_pos.x > mouse_pos.y
	var upper_left : bool = mouse_pos.x + mouse_pos.y < grid_px_size.x
	
	if upper_right && upper_left:
		dir = Vector2.DOWN
	elif upper_right:
		dir = Vector2.LEFT
	elif upper_left:
		dir = Vector2.RIGHT
	else:
		dir = Vector2.UP
	
	return dir


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
func find_tiles_in_AOE(grid_array : Array) -> Array:
	var current_pos = current_tile.get_grid_position()
	var tile_in_AOE : Array = []
	for rel_pos in AOE_relatives:
		var tile = find_tile_at_relative_grid_pos(current_pos, rel_pos, grid_array)
		if tile:
			tile_in_AOE.append(tile)
	
	return tile_in_AOE

#### SIGNAL RESPONSES ####

func on_wind_direction_changed(new_wind_dir: Vector2):
	AOE_relatives = get_rect_AOE(area_of_effect.v_size, new_wind_dir)
	var angle = new_wind_dir.angle()
	$Arrow.set_rotation(angle + deg2rad(90))
