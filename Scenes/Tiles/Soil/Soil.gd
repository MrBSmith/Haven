extends Tile
class_name Soil

#### SIGNALS REACTION ####

func _on_max_wetness_reached():
	change_tile_type(Globals.grass_tile)

func _on_over_wetness_threshold_reached():
	change_tile_type(Globals.swamp_tile)

func _on_min_wetness_reached():
	pass
