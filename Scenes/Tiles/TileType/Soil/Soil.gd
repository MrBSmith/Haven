extends TileType
class_name SoilTile

func get_type() -> String:
	return "Soil"

#### LOGIC ####


#### SIGNALS REACTION ####

func _on_tile_created():
	pass

func _on_max_wetness_reached():
	pass

func _on_over_wetness_threshold_reached():
	tile.change_tile_type(Globals.swamp_tile)

func _on_min_wetness_reached():
	tile.change_tile_type(Globals.sand_tile)

func _on_plant_added(plant: Plant):
	if plant is Grass:
		var nb_grass = tile.grass_group_node.get_child_count()
		
		if nb_grass >= max_grass_nb:
			tile.change_tile_type(Globals.grass_tile)
