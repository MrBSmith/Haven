extends TileType
class_name SandTile

#### ACCESSORS ####

func get_type_name() -> String:
	return "Sand"


#### BUILT-IN ####

func _ready():
	var _err = $Timer.connect("timeout", self, "_on_timer_timeout")
	
	var part_material = $Particles2D.get_process_material()
	var emitting_size = Vector3(Globals.TILE_SIZE.x / 2, Globals.TILE_SIZE.y / 2, 1.0)
	part_material.set_emission_box_extents(emitting_size)

#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

# Called when wind is applied to this tile
func on_wind_applied(wind_dir: Vector2, _wind_force: int, _duration: float):
	$Particles2D.set_emitting(true)
	var part_material = $Particles2D.get_process_material()
	part_material.set_direction(Vector3(wind_dir.x, wind_dir.y, 0.0))
	$Timer.start(2.0)
	
	var adjacent_tile = tile.get_tile_by_translation(wind_dir)
	if adjacent_tile != null && adjacent_tile.get_tile_type_name() == "Soil":
		adjacent_tile.change_tile_type("Sand")

func _on_timer_timeout():
	$Timer.stop()
	$Particles2D.set_emitting(false)
