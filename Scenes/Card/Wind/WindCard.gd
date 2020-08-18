extends Card
class_name WindCard

func get_type() -> String:
	return "Wind"

#### LOGIC ####


# Override from tile
# Apply wind on concerned tiles
func normal_effect(tiles_array: Array, wind_dir := Vector2.ZERO):
	apply_wind(tiles_array, wind_dir)


# Override from tile
# Apply a strong wind on every tiles
func combined_effect():
	var grid_node = get_tree().get_current_scene().get_node("Grid")
	var tiles_affected = grid_node.get_tile_array()
	$Area.create_area(tiles_affected)
	
	var rdm_dir = random_wind_dir()
	apply_wind(tiles_affected, rdm_dir, 150)
	
	call_deferred("set_state", "CombinedEffect")
