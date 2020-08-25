extends YSort

#### ACCESSORS ####



#### BUILT-IN ####

func _ready():
	var _err = Events.connect("wind_animation_required", self, "_on_wind_animation_required")


#### LOGIC ####


func wind_animation(tiles_affected: Array, wind_dir: Vector2, wind_force: int, duration: float):
	var spawn_rect = get_wind_spawn_rect(tiles_affected, wind_dir)
	var anim = WindAnimation.new(spawn_rect, wind_dir, wind_force, duration)
	add_child(anim)


# Return the area, decribed in pixels by a Rect2 from which the wind trails should spawn
func get_wind_spawn_rect(tiles_affected: Array, wind_dir: Vector2) -> Rect2:
	var spawn_tiles : Array = get_wind_spawn_tiles(tiles_affected, wind_dir)
	var area := Rect2(0, 0, 0, 0)
	var tile_size = Globals.TILE_SIZE
	
	for tile in spawn_tiles:
		var tile_top_left_corner = tile.get_grid_position() * tile_size
		var tile_rect = Rect2(tile_top_left_corner, tile_size)
		if area.size == Vector2.ZERO:
			area = tile_rect
		else:
			area = area.merge(tile_rect)
	
	return area


# Return the tiles from which the wind trails will spawn
func get_wind_spawn_tiles(tiles_affected: Array, wind_dir: Vector2) -> Array:
	var spawn_tiles : Array = []
	
	for tile in tiles_affected:
		if wind_dir == Vector2.UP:
			if tile.get_grid_position().y == Globals.GRID_TILE_SIZE.y - 1:
				spawn_tiles.append(tile)
		elif wind_dir == Vector2.DOWN:
			if tile.get_grid_position().y == 0:
				spawn_tiles.append(tile)
		elif wind_dir == Vector2.LEFT:
			if tile.get_grid_position().x == Globals.GRID_TILE_SIZE.x - 1:
				spawn_tiles.append(tile)
		else:
			if tile.get_grid_position().x == 0:
				spawn_tiles.append(tile)
	
	return spawn_tiles

#### VIRTUALS ####


#### INPUTS ####


#### SIGNAL RESPONSES ####

func _on_wind_animation_required(tiles_affected: Array, wind_dir: Vector2, wind_force: int, duration: float):
	wind_animation(tiles_affected, wind_dir, wind_force, duration)
