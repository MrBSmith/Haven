extends ClassFinder

export var spawn_disabled : bool = false

var animals_node : Node = null
var grid_node : Node = null

#### ACCESSORS ####



#### BUILT-IN ####

func _ready():
	var _err = $Timer.connect("timeout", self, "_on_timer_timeout")

#### LOGIC ####

func spawn_animals():
	if !animals_node:
		animals_node = get_tree().get_current_scene().find_node("Animals")
	
	if !grid_node:
		grid_node = get_tree().get_current_scene().find_node("Grid")
	
	
	if animals_node == null or grid_node == null:
		return
	
	for animal in target_array:
		var singleton = animal[0]
		var scene = animal[1]
		
		if !singleton.can_appear():
			continue
		
		var appear_tile = singleton.find_appearing_tile(grid_node)
		if appear_tile != null:
			var instance = scene.instance()
			animals_node.call_deferred("add_child", instance)
			instance.set_global_position(appear_tile.get_global_position())


# Find the given animal in the list of animals and return its scene
func find_animal_scene(animal_name: String) -> PackedScene:
	for animal in target_array:
		var singleton = animal[0]
		var scene = animal[1]
		
		if singleton.name == animal_name:
			return scene
	return null


#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_timer_timeout():
	if !spawn_disabled:
		spawn_animals()
