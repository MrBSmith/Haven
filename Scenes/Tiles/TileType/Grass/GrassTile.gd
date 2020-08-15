extends TileType
class_name GrassTile

enum TILE_STATES{
	PLAIN,
	FOREST
}

var current_tile_state = TILE_STATES.PLAIN

func get_type() -> String:
	return "Grass"

#### ACCESSORS ####



#### BUILT-IN ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_tile_created():
	pass

func _on_max_wetness_reached():
	pass

func _on_over_wetness_threshold_reached():
	pass

func _on_min_wetness_reached():
	pass

func _on_plant_added(_plant: Plant):
	pass
