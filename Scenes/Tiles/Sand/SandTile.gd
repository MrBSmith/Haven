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
