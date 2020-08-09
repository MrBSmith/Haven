extends Card
class_name WindCard

#### LOGIC ####

# Override from tile
# Apply wind on concerned tiles
func affect_tiles(tiles_array: Array, wind_dir := Vector2.ZERO):
	randomize()
	if wind_dir == Vector2.ZERO:
		return
	
	for tile in tiles_array:
		var rdm_force = randi() % 6 
		tile.on_wind_applied(wind_dir, rdm_force)
