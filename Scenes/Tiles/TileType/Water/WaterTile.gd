extends TileType
class_name WaterTile

func get_type_name() -> String:
	return "Water"

#### SIGNAL RESPONSES ####

# Called when the tile has finished beeing created
func _on_tile_created():
	for plant in tile.get_all_plants():
		plant.queue_free()


# Called when the tile is wetness passed 100% and is over his threshold
func _on_over_wetness_threshold_reached():
	pass


