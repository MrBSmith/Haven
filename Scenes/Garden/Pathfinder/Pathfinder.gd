extends Node2D
class_name Pathfinder

var ready : bool = false 

export var swimming_animal : bool = false

var sampling_frequency : int = -1.0
var grid_point_size 

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
	if sampling_frequency == -1.0:
		return PoolVector2Array()
	
	if !ready or grid_node.is_pos_outside_grid(dest):
		return PoolVector2Array()
	
	var id_path = astar.get_id_path(get_id_at_world_pos(origin), get_id_at_world_pos(dest))
	var path := PoolVector2Array()
	
	for id in id_path:
		var point = get_world_pos_from_id(id)
		path.append(point)
	
	return path


# Sample every point of the map, based on the sie of a tile / samplingfrequency
# and feed the Astar with it
# Set the water & swamp tile as non walkable
# Then connect every points
func sample_map(frequency: int = 50):
	
	sampling_frequency = frequency
	grid_point_size = Globals.TILE_SIZE * Globals.GRID_TILE_SIZE / sampling_frequency
	
	var id = 0
	for i in range(grid_point_size.y):
		for j in range(grid_point_size.x):
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
		
		if astar.has_point(id):
			astar.set_point_disabled(id, not_passable)


# Called when a tile change type; update the passability of the point underneath it
func modify_tile_type(tile: Tile, prev_type: TileType, next_type: TileType):
	var add : bool = !is_tile_passable(next_type)
	var first_type : bool = prev_type == null
	
	# If its the first addition of a passable type
	# Or if the passability haven't changed, abort
	if (!add && first_type) or \
	(!first_type && (is_tile_passable(next_type) == is_tile_passable(prev_type))):
		return
	
	for point_id in get_points_in_tile(tile):
		if add:
			astar.set_point_disabled(point_id , true)
		else:
			if !is_point_in_obstacle(get_pos_from_id(point_id)):
				astar.set_point_disabled(point_id, false)


# Return a PoolVector2Array of points contained in the given tile
func get_points_in_tile(tile: Tile) -> PoolIntArray:
	var upper_left = world_pos_to_point(tile.get_global_position() - Globals.TILE_SIZE / 2)
	var points_array := PoolIntArray()
	
	var tile_point_size = Globals.TILE_SIZE / sampling_frequency
	
	for i in range(tile_point_size.y + 1):
		for j in range(tile_point_size.x + 1):
			var pos = Vector2(j, i) + upper_left
			points_array.append(get_id_at_pos(pos))
	
	return points_array


# Return a PoolVector2Array of points inside the given obstacle
# !!! Works only with RectangleShape2D and CircleShape2D !!!
func get_points_in_obstacle(obstacle: Node2D) -> PoolVector2Array:
	var points_array = PoolVector2Array()
	var shape = obstacle.get_node("CollisionShape2D").get_shape()
	var obst_pos = obstacle.get_global_position()
	var obst_scale = obstacle.get_scale()
	
	if shape is RectangleShape2D:
		points_array = get_points_in_rect(get_collision_rect(obst_pos, shape, obst_scale))
	
	elif shape is CircleShape2D:
		var circle_radius = shape.get_radius()
		points_array = get_points_in_circle(circle_radius, obst_pos, obst_scale)
	
	return points_array


# Returns an array of points inside a given rect
func get_points_in_rect(rect: Rect2) -> PoolVector2Array:
	var points_array := PoolVector2Array()
	
	# Rect position, expressed in point position
	var rect_pos = rect.position
	var rect_size_pxl = rect.size
	
	for i in range(rect_size_pxl.y):
		for j in range(rect_size_pxl.x):
			var point = world_pos_to_point(Vector2(j, i) + rect_pos)
			if !point in points_array:
				points_array.append(point)
	
	return points_array

# Returns an array of points inside a given circle
# !!! Doesn't support non-perfect circles !!! #
func get_points_in_circle(radius: float, circle_pos: Vector2, obst_scale: Vector2):
	var astar_points = astar.get_points()
	var points_array := PoolVector2Array()
	
	for point_id in astar_points:
		if is_point_in_circle(point_id, circle_pos, radius, obst_scale):
			points_array.append(get_pos_from_id(point_id))
	return points_array


func is_point_in_circle(point_id: int, circle_pos: Vector2, 
					radius: float, circle_scale:= Vector2.ONE):
	var point_world_pos = get_world_pos_from_id(point_id)
	return point_world_pos.distance_to(circle_pos) <= radius * circle_scale.x


# Return every unpassable tiles
func get_unpassable_tiles(tiles_array: Array) -> Array:
	var unpassable_tiles_array : Array = []
	for tile in tiles_array:
		if tile.type is WetTile:
			unpassable_tiles_array.append(tile)
	
	return unpassable_tiles_array


# Return true if the given point is in an unpassable tile
func is_point_in_unpassable_tile(point: Vector2) -> bool:
	var tile = grid_node.get_tile_at_world_pos(point_to_world_pos(point))
	if tile == null:
		return true
	
	var tile_type = tile.get_tile_type()
	return !is_tile_passable(tile_type)


# Return true is the given point is inside an obstacle, false if not
func is_point_in_obstacle(point : Vector2, exeption: Node2D = null) -> bool:
	var obstacles_array = get_tree().get_nodes_in_group("Obstacle")
	var point_world_pos = point_to_world_pos(point)
	
	for obstacle in obstacles_array:
		if obstacle == exeption:
			continue
		
		var obst_pos = obstacle.get_global_position()
		var obst_scale = obstacle.get_scale()
		var shape = obstacle.find_node("CollisionShape2D").get_shape()
		
		if shape is RectangleShape2D:
			var collision_rect = get_collision_rect(obst_pos, shape, obst_scale)
			if collision_rect.has_point(point_world_pos):
				return true
		elif shape is CircleShape2D:
			var radius = shape.get_radius()
			var point_id = get_id_at_pos(point)
			if is_point_in_circle(point_id, obst_pos, radius, obst_scale):
				return true
	return false


# Return the given collision shape (Must be a RectangleShape) as a Rect2
func get_collision_rect(pos: Vector2, rect_shape: RectangleShape2D, obst_scale := Vector2.ONE) -> Rect2:
	var shape_ext = rect_shape.get_extents() * obst_scale
	return Rect2(pos - shape_ext, shape_ext * 2)


# Connect every point in the grid
func connect_all_points():
	for i in range(grid_point_size.x):
		for j in range(grid_point_size.y):
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
		if rel.x >= grid_point_size.x or rel.y >= grid_point_size.y or rel.x < 0 or rel.y < 0:
			continue
		
		var rel_id = get_id_at_pos(rel)
		astar.connect_points(point_id, rel_id)


# Take a position expressed in sampled point position, and returns its point id
func get_id_at_pos(pos: Vector2) -> int:
	return int(pos.y) * (grid_point_size.x) + int(pos.x)


# Take a world position, and return the id of the corresponding point
func get_id_at_world_pos(world_pos: Vector2) -> int:
	return get_id_at_pos(world_pos / sampling_frequency)


# Take a world position and return its corresponding point position in the A* 
func world_pos_to_point(world_pos: Vector2) -> Vector2:
	return (world_pos / sampling_frequency).round()

# Take a point position of the A* and return the corresponding world position
func point_to_world_pos(point: Vector2) -> Vector2:
	return point * sampling_frequency


# Take an id, and return its position expressed in sampled point position 
func get_pos_from_id(id : int) -> Vector2:
	return Vector2(id % int(grid_point_size.x), int(id / grid_point_size.x))


# Take an point id, and return the corresponding world position of this point
func get_world_pos_from_id(id: int) -> Vector2:
	return get_pos_from_id(id) * sampling_frequency


# Return true if the given tile is passable, false if not
func is_tile_passable(tile_type: TileType) -> bool:
	if swimming_animal:
		return tile_type is WetTile
	else:
		return tile_type is DryTile


#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func on_add_obstacle(obstacle: Node2D):
	modify_obstacle(obstacle, false)
