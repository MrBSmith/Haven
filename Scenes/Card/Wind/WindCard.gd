extends Card
class_name WindCard

func get_class() -> String:
	return "Wind"

#### LOGIC ####


# Override from tile
# Apply wind on concerned tiles
func card_effect(tiles_array: Array, wind_dir := Vector2.ZERO, modifier: float = 1.0):
	apply_wind(tiles_array, wind_dir, 100 * modifier)
	.card_effect(tiles_array, wind_dir, modifier)



# Override from tile
# Apply a strong wind on every tiles
func combined_effect():
	var grid_node = get_tree().get_current_scene().get_node("Grid")
	var tiles_affected = grid_node.get_tile_array()
	$Area.create_area(tiles_affected)
	$StateMachine/Effect.combined = true
	
	var rdm_dir = random_wind_dir()
	card_effect(tiles_affected, rdm_dir, 1.5)
