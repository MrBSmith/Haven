extends YSort
class_name Tile

onready var grass_group_node = $Grass
onready var trees_group_node = $Trees
onready var flowers_group_node = $Flowers

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


# Generate the given plant (from one to three per tile) on the given grass tile
func generate_plant(plant: PackedScene, max_nb: int, spawn_chances: int):
	randomize()
	
	var tree_array : Array = []
	var nb_plant_rng = randi() % max_nb + 1
	for _i in range(nb_plant_rng):
		var rng_plant = randi() % 100
		if rng_plant < spawn_chances:
			
			var new_plant = plant.instance()
			var min_dist = new_plant.get_min_sibling_dist()
			
			# Generate new positions until one is correct
			var pos = random_tile_position()
			while(!is_plant_correct_position(tree_array, pos, min_dist)):
				pos = random_tile_position()
			
			add_plant(new_plant, pos)
			tree_array.append(new_plant)


# Add the given plant to the tile, in the right group
func add_plant(plant_node: Plant, pos: Vector2):
	plant_node.current_tile_weakref = weakref(self)
	plant_node.set_position(pos)
	
	if plant_node is Grass:
		grass_group_node.call_deferred("add_child", plant_node)
	elif plant_node is TreeBase:
		trees_group_node.call_deferred("add_child", plant_node)
	elif plant_node is Flower:
		flowers_group_node.call_deferred("add_child", plant_node)


# Return true if the given position is far enough (the minimum distance is defined by min_dist)
# from every seed in the seed array
func is_plant_correct_position(seed_array: Array, pos: Vector2, min_dist: float = 2.0) -> bool:
	for current_seed in seed_array:
		if current_seed.get_position().distance_to(pos) < min_dist:
			return false
	return true



# Genenerate a random position in the tile
func random_tile_position() -> Vector2:
	var margin = Globals.TILE_SIZE / 20
	var min_pos = -Globals.TILE_SIZE / 2 + margin
	var max_pos = Globals.TILE_SIZE / 2 - margin
	
	return Vector2(rand_range(min_pos.x, max_pos.x), rand_range(min_pos.y, max_pos.y))


#### SIGNALS REACTION ####

func _on_max_wetness_reached():
	pass

func _on_over_wetness_threshold_reached():
	pass

func _on_min_wetness_reached():
	pass
