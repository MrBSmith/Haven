extends YSort
class_name Tile

onready var grid_node = get_parent()

onready var grass_group_node = $Grass
onready var trees_group_node = $Trees
onready var flowers_group_node = $Flowers

onready var plant_group_array = [grass_group_node, trees_group_node, flowers_group_node]

export var growable_plants_array : PoolStringArray

export var growable_min_wetness : int = 33

export var min_grass_nb : int = 0
export var max_grass_nb : int = 6
export var min_flower_nb : int = 0
export var max_flower_nb : int = 0
export var min_tree_nb : int = 0
export var max_tree_nb : int = 5

var grid_position : Vector2 setget set_grid_position, get_grid_position
var wetness : int = 50 setget set_wetness, get_wetness

export var overwet_treshold = 25

signal tile_created
signal plant_added

func _ready():
	var _err = connect("plant_added", self, "_on_plant_added")
	_err = connect("tile_created", self, "_on_tile_created")

#### ACCESSORS ####

func get_type():
	return "Tile"

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

func generate_flora():
	generate_plant(Globals.grass, min_grass_nb, max_grass_nb, 70, true)
	generate_plant(Globals.flower_types, min_flower_nb, max_flower_nb, 70, true)
	generate_plant(Globals.base_tree, min_tree_nb, max_tree_nb, 40, true)
	
	emit_signal("tile_created")


# Return true if the tile is wet enough to grow plant
func is_growable() -> bool:
	return get_wetness() > growable_min_wetness

# Generate the given plant n times, n beeing between min_nb and max_nb, 
# With a spawn porbability determined by spwan_chance (must be a value between 0 and 100)
# The plant argument can also be an array, if this is the case, 
# A random member will be picked each time
# Called when the garden is generated
func generate_plant(plant, min_nb: int, max_nb: int, spawn_chances: int, garden_generation : bool = false):
	if max_nb == 0:
		return
	
	randomize()
	
	var plant_array : Array = []
	var nb_plant_rng = randi() % max_nb + min_nb
	
	for _i in range(nb_plant_rng):
		var rng_plant = randi() % 100
		if rng_plant < spawn_chances:
			var new_plant : Plant
			
			if plant is PackedScene:
				new_plant = plant.instance()
			elif plant is Array:
				var rdm_id = randi() % plant.size()
				new_plant = plant[rdm_id].instance()
				
			var min_dist = new_plant.get_min_sibling_dist()
			
			# Generate new positions until one is correct
			var pos = random_plant_position()
			while(!is_plant_correct_position(new_plant, pos, min_dist)):
				pos = random_plant_position()
			
			add_plant(new_plant, pos, true)
			plant_array.append(new_plant)
	
	if !garden_generation:
		update_tile_type()


# Return all the plants on the tile in an array
func get_all_plants() -> Array:
	return grass_group_node.get_children() + trees_group_node.get_children()\
	 + flowers_group_node.get_children()


func get_plant_cat_max(plant_category : String):
	if plant_category == "Tree":
		return max_tree_nb
	elif plant_category == "Grass":
		return max_grass_nb
	elif plant_category == "Flower":
		return max_flower_nb


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
#### IN SOME CASES, THE UNDERNEATH TILE SEAMS NOT TO BE DESTROYED ####
#### TO BE INVESTIGATED AND FIXED ####
func change_tile_type(tile_type_scene: PackedScene):
	var new_tile = tile_type_scene.instance()
	
	if self.get_type() == new_tile.get_type():
		new_tile.queue_free()
		return
	
	grid_node.call_deferred("add_child", new_tile)
	new_tile.call_deferred("set_position", position)
	new_tile.set_grid_position(get_grid_position())
	
	# Duplicate every plant the tile possess
	for group in plant_group_array:
		for plant in group.get_children():
			new_tile.add_plant(plant.duplicate(), plant.get_position())
	
	new_tile.emit_signal("tile_created")
	destroy()


func destroy():
	queue_free()


func update_tile_type():
	if grass_group_node.get_child_count() >= 3:
		change_tile_type(Globals.grass_tile)
	elif grass_group_node.get_child_count() < 3:
		change_tile_type(Globals.soil_tile)


# Add the given plant to the tile, at the given local_pos, in the right group
func add_plant(plant_node: Plant, pos: Vector2, garden_generation : bool = false):
	plant_node.current_tile_weakref = weakref(self)
	plant_node.set_position(pos)
	
	var plant_category = plant_node.get_category()
	var plant_group = get_plant_correct_group(plant_category)
	
	var plant_max_nb = get_plant_cat_max(plant_category)
	
	if plant_group == null:
		return
	
	# Check if the plant doesn't reach the max capacity of the tile
	if plant_group.get_child_count() < plant_max_nb:
		plant_node.grid_node = grid_node
		plant_group.add_child(plant_node)
		var _err = plant_node.connect("tree_exited", self, "_on_plant_died")
	
	# Connect the seed generation signal emited by the plant to the grid 
	# which is in charge of generating the moving_seed
	if plant_node.has_signal("generate_seed"):
		var _err = plant_node.connect("generate_seed", grid_node, "generate_moving_seed")
	
	# Send a signal to signify the plant has been added
	# Not desired if the garden is currently beeing generated
	if !garden_generation:
		emit_signal("plant_added", plant_node)


# Return true if the given position is far enough (the minimum distance is defined by min_dist)
# from every seed in the seed array
func is_plant_correct_position(plant_node: Plant, pos: Vector2, min_dist: float = 4.0) -> bool:
	var plant_category = plant_node.get_category()
	var plant_array := get_plant_correct_group(plant_category).get_children()
	
	for plant in plant_array:
		if plant.get_position().distance_to(pos) < min_dist:
			return false
	return true


# Take a plant category, return the group it should be in
func get_plant_correct_group(plant_category: String) -> Node:
	var plant_group : Node = null
	
	if plant_category == "Tree":
		plant_group = trees_group_node
	elif plant_category == "Grass":
		plant_group = grass_group_node
	elif plant_category == "Flower":
		plant_group = flowers_group_node
	
	return plant_group

# Genenerate a random position in the tile
func random_plant_position() -> Vector2:
	var margin = Globals.TILE_SIZE / 16
	var min_pos = -Globals.TILE_SIZE / 2 + margin
	var max_pos = Globals.TILE_SIZE / 2 - margin
	
	return Vector2(rand_range(min_pos.x, max_pos.x), rand_range(min_pos.y, max_pos.y))


# Return the tile, trans away from this tile or null if nothing was found
func get_tile_by_translation(trans: Vector2) -> Tile:
	return grid_node.get_tile_at_grid_pos(get_grid_position() + trans)


#### SIGNALS REACTION ####

# Called when the tile has finished beeing created
func _on_tile_created():
	pass

# Called when the tile is at its max wetness
func _on_max_wetness_reached():
	pass

# Called when the tile is wetness passed 100% and is over his threshold
func _on_over_wetness_threshold_reached():
	pass

# Called when the tile is at its min wetness
func _on_min_wetness_reached():
	pass

# Called when a plant is added
func _on_plant_added(_plant: Plant):
	pass

func _on_plant_died():
	update_tile_type()

# Called when wind is applied to this tile
func on_wind_applied(wind_dir: Vector2, wind_force: int):
	for tree in trees_group_node.get_children():
		tree.apply_wind(wind_dir, wind_force)
