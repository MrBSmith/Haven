extends TileType
class_name SoilTile

func get_type() -> String:
	return "Soil"

#### LOGIC ####


#### SIGNALS REACTION ####

func on_plant_added(plant: Plant):
	if plant is Grass:
		var nb_grass = tile.grass_group_node.get_child_count()
		
		if nb_grass >= max_grass_nb:
			tile.change_tile_type(Globals.grass_tile)
