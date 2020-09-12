extends TileType
class_name SwampTile

func get_type_name() -> String:
	return "Swamp"

#### SIGNALS REACTION ####

# Called when the tile has finished beeing created
func _on_tile_created():
	for plant in tile.get_all_plants():
		plant.queue_free()
