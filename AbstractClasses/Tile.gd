extends Node2D
class_name Tile

var grid_position : Vector2 setget set_grid_position, get_grid_position
var wetness : int = 50 setget set_wetness, get_wetness
export var overwet_treshold = 25


func _ready():
	pass

#### ACCESSORS ####

func set_grid_position(value: Vector2):
	grid_position = value

func get_grid_position() -> Vector2:
	return grid_position

func set_wetness(value: int):
	wetness = int(clamp(value, 0.0, 100.0))
	if wetness == 100:
		if value > wetness + overwet_treshold:
			_on_over_wetness_threshold_reached()
		else:
			_on_max_wetness_reached()
	elif wetness == 0:
		_on_min_wetness_reached()

func get_wetness() -> int:
	return wetness

func add_to_wetness(value: int):
	set_wetness(get_wetness() + value)

#### LOGIC ####

# Try to remove the given amount of wetness, return the amount really removed
func drain_wetness(value: int) -> int:
	var pre_drain_wetness = get_wetness()
	set_wetness(pre_drain_wetness - value)
	var post_drain_wetness = get_wetness()
	
	return pre_drain_wetness - post_drain_wetness


# Return the number of seeds this
func get_seed_nb() -> int:
	var nb_seed : int = 0
	for child in get_children():
		if child is Seed:
			nb_seed += 1
	return nb_seed


# Change the type of the tile for the given one
func change_tile_type(tile_type_scene: PackedScene):
	var new_tile = tile_type_scene.instance()
	new_tile.set_global_position(global_position)
	new_tile.set_grid_position(get_grid_position())
	var grid_node = get_parent()
	grid_node.add_child(new_tile)
	destroy()


func destroy():
	queue_free()


func add_plant(plant_node: Plant, pos: Vector2):
	plant_node.current_tile_weakref = weakref(self)
	plant_node.set_position(pos)
	call_deferred("add_child", plant_node)
#	print("Seed added to " + name + " at " + String(pos))



#### SIGNALS REACTION ####

func _on_max_wetness_reached():
	pass

func _on_over_wetness_threshold_reached():
	pass

func _on_min_wetness_reached():
	pass
