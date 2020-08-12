extends Tile
class_name SwampTile

func get_type():
	return "SwampTile"

#### SIGNALS REACTION ####

func _on_over_wetness_threshold_reached():
	change_tile_type(Globals.water_tile)

func _on_min_wetness_reached():
	change_tile_type(Globals.soil_tile)

# Called when the tile has finished beeing created
func _on_tile_created():
	for plant in get_all_plants():
		plant.queue_free()
