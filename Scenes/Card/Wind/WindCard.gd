extends Card
class_name WindCard

func get_type() -> String:
	return "Wind"

#### LOGIC ####

# Override from tile
# Apply wind on concerned tiles
func normal_effect(tiles_array: Array, wind_dir := Vector2.ZERO):
	randomize()
	if wind_dir == Vector2.ZERO:
		return
	
	for tile in tiles_array:
		var rdm_force = randi() % 100 + 50 
		tile.on_wind_applied(wind_dir, rdm_force)
