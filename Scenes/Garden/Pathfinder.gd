extends Node2D
class_name Pathfinder

var ready : bool = false 

onready var grid_pxl_size = Globals.TILE_SIZE * Globals.GRID_TILE_SIZE
onready var astar = AStar2D.new()
onready var grid_node = get_parent()

#### ACCESSORS ####



#### BUILT-IN ####

func _ready():
	var _err = Events.connect("new_tree_grown", self, "on_add_obstacle")
	_err = Events.connect("tree_died", self, "modify_obstacle")
	_err = Events.connect("tile_type_changed", self, "modify_tile_type")

#### LOGIC ####

# Return the shortest path between the origin point and the destination point
func get_simple_path(origin: Vector2, dest: Vector2) -> PoolVector2Array:
	if !ready or grid_node.is_pos_outside_grid(dest):
		return PoolVector2Array()
	
	var id_path = astar.get_id_path(get_id_at_pos(origin), get_id_at_pos(dest))
	var path := PoolVector2Array()
	
	for id in id_path:
		var point = get_pos_from_id(id)
		path.append(point)
	
	return path


# Sample every pixel of the map, and feed the Astar with it
# Set the water & swamp tile as non walkable
# Then connect every points
func sample_map():
	var id = 0
	for i in range(grid_pxl_size.y):
		for j in range(grid_pxl_size.x):
			var point = Vector2(j, i)
			astar.add_point(id, point)
			
			if is_point_in_unpassable_tile(point) or is_point_in_obstacle(point):
				astar.set_point_disabled(id, true)
			
			id += 1
	
	connect_all_points()
	ready = true


# Called when an obstacle is added or removed, update the points underneath it
func modify_obstacle(obstacle: Node2D, remove: bool = true):
	for point in get_points_in_obstacle(obstacle):
		var id = get_id_at_pos(point)
		var not_passable = is_point_in_unpassable_tile(point) or \
			is_point_in_obstacle(point, obstacle if remove else null)
		
		astar.set_point_disabled(id, not_passable)


# Called when a tile change type; update the passability of the point underneath it
func modify_tile_type(tile: Tile, prev_type: TileType, next_type: TileType):
	var add : bool = !next_type.is_passable()
	var first_type : bool = prev_type == null
	
	# If its the first addition of a passable type
	# Or if the passability haven't changed, abort
	if (!add && first_type) or (!first_type && (next_type.is_passable() == prev_type.is_passable())):
		return
	
	for point in get_points_in_tile(tile):
		var id = get_id_at_pos(point)
		if add:
			astar.set_point_disabled(id, true)
		else:
			if !is_point_in_obstacle(point):
				astar.set_point_disabled(id, false)


# Return a PoolVector2Array of points contained in the given tile
func get_points_in_tile(tile: Tile) -> PoolVector2Array:
	var upper_left = tile.get_global_position() - (Globals.TILE_SIZE / 2)
	var points_array := PoolVector2Array()
	
	for i in range(Globals.TILE_SIZE.y):
		for j in range(Globals.TILE_SIZE.x):
			points_array.append(Vector2(int(j + upper_left.x), int(i + upper_left.y)))
	
	return points_array


# Return a PoolVector2Array of points inside the given obstacle
func get_points_in_obstacle(obstacle: Node2D) -> PoolVector2Array:
	var collision_shape = obstacle.get_node("CollisionShape2D")
	var collision_rect := get_collision_rect(collision_shape)
	var points_array := PoolVector2Array()
	
	var rect_pos = collision_rect.position
	rect_pos = Vector2(clamp(rect_pos.x, 0.0, grid_pxl_size.x), \
						clamp(rect_pos.y, 0.0, grid_pxl_size.y))
	var rect_size = collision_rect.size
	
	for i in range(rect_size.y):
		for j in range(rect_size.x):
			points_array.append(Vector2(int(j + rect_pos.x), int(i + rect_pos.y)))
	
	return points_array


# Return every unpassable tiles
func get_unpassable_tiles(tiles_array: Array) -> Array:
	var unpassable_tiles_array : Array = []
	for tile in tiles_array:
		if tile.type is WetTile:
			unpassable_tiles_array.append(tile)
	
	return unpassable_tiles_array


# Return true if the given point is in an unpassable tile
func is_point_in_unpassable_tile(point: Vector2) -> bool:
	var tile = grid_node.get_tile_at_world_pos(point)
	if tile == null:
		return true
	
	var tile_type = tile.get_tile_type_name()
	return tile_type == "Water" or tile_type == "Swamp"


# Return true is the given point is inside an obstacle, false if not
func is_point_in_obstacle(point : Vector2, exeption: Node2D = null) -> bool:
	var obstacles_array = get_tree().get_nodes_in_group("Obstacle")
	
	for obstacle in obstacles_array:
		if obstacle == exeption:
			continue
		
		var collision_shape = obstacle.find_node("CollisionShape2D")
		var collision_rect = get_collision_rect(collision_shape)
		if collision_rect.has_point(point):
			return true
	return false


# Return the given collision shape (Must be a RectangleShape) as a Rect2
func get_collision_rect(collision_shape: CollisionShape2D) -> Rect2:
	var shape_pos = collision_shape.get_global_position()
	var shape_ext = collision_shape.get_shape().get_extents()
	return Rect2(shape_pos - shape_ext, shape_ext * 2)


# Connect every point in the grid
func connect_all_points():
	for i in range(grid_pxl_size.x):
		for j in range(grid_pxl_size.y):
			connect_relatives(Vector2(i, j))


# Connect the point designated by the given id to its neighbours
func connect_relatives(point_pos: Vector2, diagonal: bool = true):
	var point_id = get_id_at_pos(point_pos) 
	var relatives_pos = [
		Vector2(point_pos.x + 1, point_pos.y),
		Vector2(point_pos.x - 1, point_pos.y),
		Vector2(point_pos.x, point_pos.y - 1),
		Vector2(point_pos.x, point_pos.y + 1)
	]
	
	if diagonal:
		relatives_pos += [
			Vector2(point_pos.x + 1, point_pos.y + 1),
			Vector2(point_pos.x - 1, point_pos.y - 1),
			Vector2(point_pos.x + 1, point_pos.y - 1),
			Vector2(point_pos.x - 1, point_pos.y + 1)
		]
	
	for rel in relatives_pos:
		if rel.x >= grid_pxl_size.x or rel.y >= grid_pxl_size.y or rel.x < 0 or rel.y < 0:
			continue
		
		var rel_id = get_id_at_pos(rel)
		astar.connect_points(point_id, rel_id)


# Take a position, and returns its point id
func get_id_at_pos(pos: Vector2) -> int:
	return int(pos.y) * grid_pxl_size.x + int(pos.x)


# Take an id, and return its position
func get_pos_from_id(id : int) -> Vector2:
	return Vector2(id % int(grid_pxl_size.x), int(id / grid_pxl_size.x))

#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func on_add_obstacle(obstacle: Node2D):
	modify_obstacle(obstacle, false)
