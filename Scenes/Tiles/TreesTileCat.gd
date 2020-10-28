extends YSort

const TYPE : String = ""


#### ACCESSORS ####

func is_type(value : String) -> bool: return value == TYPE or .is_type(value)
func get_type() -> String : return TYPE




#### BUILT-IN ####



#### LOGIC ####



#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func on_plant_grown(plant_calling, next_plant_scene):
	var next_plant = next_plant_scene.instance()
	add_child(next_plant)
	
	next_plant.set_position(plant_calling.get_position())
	plant_calling.queue_free()
