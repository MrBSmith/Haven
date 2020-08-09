extends Tile
class_name WaterTile

#### SIGNAL RESPONSES ####

# Called when the tile has finished beeing created
func _on_tile_created():
	for plant in get_all_plants():
		plant.queue_free()

# Called when the tile is at its max wetness
func _on_max_wetness_reached():
	pass

# Called when the tile is wetness passed 100% and is over his threshold
func _on_over_wetness_threshold_reached():
	pass

# Called when the tile is at its min wetness
func _on_min_wetness_reached():
	change_tile_type(Globals.swamp_tile)


