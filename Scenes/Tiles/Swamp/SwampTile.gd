extends Tile
class_name SwampTile

#### SIGNALS REACTION ####

func _on_over_wetness_threshold_reached():
	change_tile_type(Globals.water_tile)

func _on_min_wetness_reached():
	change_tile_type(Globals.soil_tile)
