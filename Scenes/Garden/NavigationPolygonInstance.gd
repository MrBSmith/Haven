extends NavigationPolygonInstance

#### ACCESSORS ####



#### BUILT-IN ####



#### LOGIC ####


func get_map_border_polygon() -> PoolVector2Array:
	var grid_pxl_size = Globals.TILE_SIZE * Globals.GRID_TILE_SIZE
	
	return PoolVector2Array([Vector2(0, 0), Vector2(grid_pxl_size.x, 0),
							grid_pxl_size, Vector2(0, grid_pxl_size.y)])


func update_polygon():
	var tiles_array = get_tree().get_nodes_in_group("Tile")
	
	if navpoly != null:
		navpoly.free()
	
	var map_outline = get_map_border_polygon()
	var total_verticies = Array(map_outline)
	var polygon = NavigationPolygon.new()
	polygon.add_outline(map_outline)
	
	var unpassable_tiles_array = get_unpassable_tiles(tiles_array)
	var grouped_adjacents = sort_tiles_by_adjacent_groups(unpassable_tiles_array)
	
	for group in grouped_adjacents:
		var vertices = extract_tiles_polygon_vertex(group)
		var outline_count = polygon.get_outline_count()
		var outline_array = []

		for i in range(outline_count):
			outline_array.append(polygon.get_outline(i))

		for outline in outline_array:
			for point in outline:
				var i = find_point_in_pool(vertices, point)
				if i != -1:
					vertices.remove(i)
		
		total_verticies = total_verticies + Array(vertices)
		polygon.add_outline(vertices)
	
	var _duplicate = find_duplicate(total_verticies)
	polygon.make_polygons_from_outlines()
	navpoly = polygon


func find_duplicate(array: Array) -> bool:
	var nb_elem = array.size()
	for i in range(nb_elem):
		for j in range(nb_elem):
			if array[i] == array[j] && i != j:
				return true
	return false

	
func find_point_in_pool(pool: PoolVector2Array, point: Vector2) -> int:
	for i in range(pool.size()):
		if point == pool[i]:
			return i
	return -1


func get_unpassable_tiles(tiles_array: Array) -> Array:
	var unpassable_tiles_array : Array = []
	for tile in tiles_array:
		if tile.type is WaterTile or tile.type is SwampTile:
			unpassable_tiles_array.append(tile)
	
	return unpassable_tiles_array


# Take a group of tiles and returns an array of array of tiles, 
# grouped if they are adjacents
func sort_tiles_by_adjacent_groups(array: Array) -> Array:
	var tiles_array = array.duplicate()
	var array_of_group : Array = [[tiles_array.pop_front()]]
	
	for group in array_of_group:
		for grouped_tile in group:
			for tile in tiles_array:
				if are_tile_adjacent(tile, grouped_tile):
					group.append(tile)
					tiles_array.erase(tile)
		
		if !tiles_array.empty():
			array_of_group.append([tiles_array.pop_front()])
	
	return array_of_group


# Take a group of tiles, and retruns an array containing 
# its polygon vertices without any duplicate
func extract_tiles_polygon_vertex(tile_array: Array) -> PoolVector2Array:
	var verctices = PoolVector2Array()
	var half_tile_size = Globals.TILE_SIZE / 2
	
	for tile in tile_array:
		var trans = tile.get_global_transform()
		var tile_verticies = [
			trans.xform(Vector2(-half_tile_size.x, -half_tile_size.y)),
			trans.xform(Vector2(-half_tile_size.x, half_tile_size.y)),
			trans.xform(Vector2(half_tile_size.x, -half_tile_size.y)),
			trans.xform(Vector2(half_tile_size.x, half_tile_size.y))
		]
		
		for vector in tile_verticies:
			if not vector in verctices:
				verctices.append(vector)
	
	return verctices




# Return true if the two given tiles are adjacent, false if not
func are_tile_adjacent(t1: Tile, t2: Tile) -> bool:
	var t1_pos = t1.get_grid_position()
	var t2_pos = t2.get_grid_position()
	
	return (t1_pos.x <= t2_pos.x + 1 && t1_pos.x >= t2_pos.x - 1 && t1_pos.y == t2_pos.y) or\
		(t1_pos.y <= t2_pos.y + 1 && t1_pos.y >= t2_pos.y - 1 && t1_pos.x == t2_pos.x)



#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
