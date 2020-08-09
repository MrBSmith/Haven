extends Tile
class_name SandTile

#### ACCESSORS ####



#### BUILT-IN ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

# Called when the tile has finished beeing created
func _on_tile_created():
	for plant in get_all_plants():
		plant.queue_free()

# Called when the tile is at its max wetness
func _on_max_wetness_reached():
	change_tile_type(Globals.soil_tile)

# Called when the tile is wetness passed 100% and is over his threshold
func _on_over_wetness_threshold_reached():
	pass

# Called when the tile is at its min wetness
func _on_min_wetness_reached():
	pass


# Called when wind is applied to this tile
func on_wind_applied(wind_dir: Vector2, wind_force: int):
	.on_wind_applied(wind_dir, wind_force)
	
	var adjacent_tile = get_tile_by_translation(wind_dir)
	if adjacent_tile != null && adjacent_tile is SoilTile:
		adjacent_tile.change_tile_type(Globals.sand_tile)
