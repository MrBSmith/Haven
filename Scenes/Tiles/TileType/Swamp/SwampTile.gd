extends TileType
class_name SwampTile

func get_type() -> String:
	return "Swamp"

#### SIGNALS REACTION ####

func _on_over_wetness_threshold_reached():
	tile.change_tile_type(Globals.water_tile)

func _on_min_wetness_reached():
	tile.change_tile_type(Globals.soil_tile)

# Called when the tile has finished beeing created
func _on_tile_created():
	for plant in tile.get_all_plants():
		plant.queue_free()
