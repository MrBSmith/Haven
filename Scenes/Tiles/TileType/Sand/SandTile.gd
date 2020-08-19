extends TileType
class_name SandTile

#### ACCESSORS ####

func get_type() -> String:
	return "Sand"


#### BUILT-IN ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

# Called when wind is applied to this tile
func on_wind_applied(wind_dir: Vector2, _wind_force: int):
	var adjacent_tile = tile.get_tile_by_translation(wind_dir)
	
	if adjacent_tile != null && adjacent_tile.get_type() == "Soil":
		adjacent_tile.change_tile_type("Sand")
