extends Tile
class_name SoilTile


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

func on_plant_added(plant: Plant):
	if plant is Grass:
		var nb_grass = grass_group_node.get_child_count()
		
		if nb_grass >= 4:
			change_tile_type(Globals.grass_tile)
