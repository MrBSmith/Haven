extends YSort

var lightning_scene = preload("res://Scenes/Projectile/Lightning.tscn")

onready var clouds_node = $Clouds 

#### ACCESSORS ####


#### BUILT-IN ####

func _ready():
	randomize()
	
	var _err = Events.connect("wind_animation_required", self, "wind_animation")
	_err = Events.connect("rain_animation_required", self, "rain_animation")
	_err = Events.connect("sun_animation_required", self, "sun_animation")
	_err = Events.connect("thunder_animation_required", self, "thunder_animation")


#### LOGIC ####

func rain_animation(tiles_affected: Array, duration: float):
	$Clouds.meteo_effect(0.2, 0.87, 1.07, Color.gray)
	yield($Clouds, "meteo_effect_ready")
	var anim = RainAnimation.new(tiles_affected, duration)
	add_child(anim)


func wind_animation(tiles_affected: Array, wind_dir: Vector2, wind_force: int, duration: float):
	$Clouds.meteo_effect($Clouds.opacity_default, $Clouds.first_threshold_default, \
		$Clouds.sec_threshold_default, $Clouds.first_color_default, \
		$Clouds.sec_color_default, wind_dir)
	yield($Clouds, "meteo_effect_ready")
	
	var spawn_rect = get_wind_spawn_rect(tiles_affected, wind_dir)
	var anim = WindAnimation.new(spawn_rect, wind_dir, wind_force, duration)
	add_child(anim)


func sun_animation(tiles_affected: Array, duration: float):
	$Clouds.meteo_effect(0.05, 1.15, 1.5)
	yield($Clouds, "meteo_effect_ready")
	var rect = tile_array_to_rect(tiles_affected)
	var anim = SunAnimation.new(rect, duration)
	add_child(anim)


func thunder_animation():
	var trees_array = get_tree().get_nodes_in_group("Tree")
	
	if trees_array.empty():
		return
	
	var rdm_index = randi() % trees_array.size()
	var target_tree = trees_array[rdm_index]
	
	var thunder = lightning_scene.instance()
	thunder.impact_point = target_tree.get_global_position()
	add_child(thunder)
	
	yield(thunder, "tree_exited")
	
	if target_tree:
		target_tree.set_fire(true)


func tile_array_to_rect(tile_array: Array) -> Rect2:
	var area := Rect2(0, 0, 0, 0)
	var tile_size = Globals.TILE_SIZE
	
	for tile in tile_array:
		var tile_top_left_corner = tile.get_grid_position() * tile_size
		var tile_rect = Rect2(tile_top_left_corner, tile_size)
		if area.size == Vector2.ZERO:
			area = tile_rect
		else:
			area = area.merge(tile_rect)
	
	return area


# Return the area, decribed in pixels by a Rect2 from which the wind trails should spawn
func get_wind_spawn_rect(tiles_affected: Array, wind_dir: Vector2) -> Rect2:
	var spawn_tiles : Array = get_wind_spawn_tiles(tiles_affected, wind_dir)
	return tile_array_to_rect(spawn_tiles)


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
