extends Tile
class_name WaterTile

#### SIGNAL RESPONSES ####

# Called when the tile has finished beeing created
func _on_tile_created():
	for plant in get_all_plants():
		plant.queue_free()
