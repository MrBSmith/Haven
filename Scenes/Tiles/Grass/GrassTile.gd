extends Tile
class_name Grass


#### SIGNALS REACTION ####

func _on_max_wetness_reached():
	change_tile_type(Globals.forest_tile)

func _on_over_wetness_threshold_reached():
	pass

func _on_min_wetness_reached():
	change_tile_type(Globals.soil_tile)
