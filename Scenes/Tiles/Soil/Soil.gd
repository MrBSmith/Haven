extends Tile
class_name Soil

enum TILE_STATES{
	SOIL,
	PLAIN,
	FOREST
}

#### LOGIC ####

func update_tile_state():
	pass

#### SIGNALS REACTION ####

func _on_max_wetness_reached():
	pass

func _on_over_wetness_threshold_reached():
	change_tile_type(Globals.swamp_tile)

func _on_min_wetness_reached():
	pass
