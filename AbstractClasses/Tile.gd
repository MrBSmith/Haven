extends YSort
class_name Tile

onready var grid_node = get_parent()

onready var grass_group_node = $Grass
onready var trees_group_node = $Trees
onready var flowers_group_node = $Flowers

onready var plant_group_array = [grass_group_node, trees_group_node, flowers_group_node]

var grid_position : Vector2 setget set_grid_position, get_grid_position
var wetness : int = 500 setget set_wetness, get_wetness

var tile_type : TileType = null

signal tile_created
signal type_changed
signal plant_added

func _ready():
	add_to_group("Tile")
	
	var _err = connect("plant_added", self, "_on_plant_added")
	_err = connect("type_changed", self, "_on_type_changed")

#### ACCESSORS ####

func get_tile_type() -> TileType: return tile_type
func get_tile_type_name() -> String : return tile_type.get_type_name()

func set_grid_position(value: Vector2):
	grid_position = value

func get_grid_position() -> Vector2:
	return grid_position

func set_wetness(value: int):
	wetness = int(clamp(value, 0.0, 1000.0))
	if wetness >= tile_type.wet_threshold:
		_on_max_wetness_reached()
	elif wetness < tile_type.dry_threshold:
		_on_min_wetness_reached()

func get_wetness() -> int:
	return wetness

func add_to_wetness(value: int):
	set_wetness(get_wetness() + value)


#### LOGIC ####

# Generate the flora of the tile, based on its type
# Called by the grid when the tile is generated
func generate_flora(astar_sample_freq: float):
	generate_plant(Resource_Loader.grass, tile_type.min_grass_nb, tile_type.max_grass_nb, 70, true, astar_sample_freq)
	generate_plant(Resource_Loader.flower_types, tile_type.min_flower_nb, tile_type.max_flower_nb, 70, true, astar_sample_freq)
	
	var tree_scene = Resource_Loader.oak.get_random_growth_state()
	generate_plant(tree_scene, tile_type.min_tree_nb, tile_type.max_tree_nb, 40, true, astar_sample_freq)
	
	emit_signal("tile_created")


# Set the wetness of the tile, based on its type at the middle of its wet range
# Called by the grid when the tile is generated
func generate_wetness():
	var default_wetness = tile_type.dry_threshold + (float(tile_type.wet_threshold - tile_type.dry_threshold) / 2)
	set_wetness(default_wetness)


# Generate the given plant n times, n beeing between min_nb and max_nb, 
# With a spawn porbability determined by spwan_chance (must be a value between 0 and 100)
# The plant argument can also be an array, if this is the case, 
# A random member will be picked each time
# Called when the garden is generated
func generate_plant(plant, min_nb: int, max_nb: int, spawn_chances: int,
			garden_generation : bool = false, astar_sample_freq: float = 1.0):
	if max_nb == 0:
		return
	
	randomize()
	
	var plant_array : Array = []
	var nb_plant_rng = randi() % max_nb + min_nb
	var grid_snap = Globals.TILE_SIZE / astar_sample_freq
	
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
			var pos = Vector2.INF
			while(!is_plant_correct_position(new_plant, pos, min_dist)):
				pos = random_plant_position().snapped(grid_snap)
			
			add_plant(new_plant, pos, true)
			plant_array.append(new_plant)
	
	if !garden_generation:
		update_tile_type()


# Return true if the tile is wet enough to grow plant
func is_growable() -> bool:
	return get_wetness() > tile_type.growable_min_wetness


# Return all the plants on the tile in an array
func get_all_plants() -> Array:
	return grass_group_node.get_children() + trees_group_node.get_children()\
	 + flowers_group_node.get_children()


# Try to remove the given amount of wetness, return the amount really removed
func drain_wetness(value: int) -> int:
	var pre_drain_wetness = get_wetness()
	set_wetness(pre_drain_wetness - value)
	var post_drain_wetness = get_wetness()
	
	return pre_drain_wetness - post_drain_wetness


# Change the type of the tile for the given one
func change_tile_type(type_name: String, generation: bool = false):
	var tile_type_scene = Resource_Loader.tiles_type[type_name]
	var new_tile_type = tile_type_scene.instance()
	
	# If the type to be changed in is the same as the current type, abort
	if tile_type != null && tile_type.get_type_name() == new_tile_type.get_type_name():
		new_tile_type.queue_free()
		return
	
	if !generation:
		Events.emit_signal("tile_type_changed", self, tile_type, new_tile_type)
	
	if tile_type:
		tile_type.queue_free()
		yield(tile_type, "tree_exited")
	
	call_deferred("add_child", new_tile_type)
	tile_type = new_tile_type
	tile_type.tile = self
	
	yield(new_tile_type, "ready")
	emit_signal("type_changed", tile_type)


# Check of the tile type need to be changed, and change it if necesary
func update_tile_type():
	if grass_group_node.get_child_count() >= 3:
		change_tile_type("Grass")
	elif grass_group_node.get_child_count() < 3:
		change_tile_type("Soil")


# Add the given plant to the tile, at the given local_pos, in the right group
func add_plant(plant_node: Plant, pos: Vector2, garden_generation : bool = false):
	plant_node.current_tile_weakref = weakref(self)
	plant_node.set_position(pos)
	
	var plant_category = plant_node.get_category()
	var plant_group = get_plant_correct_group(plant_category)
	
	var plant_max_nb = tile_type.get_plant_cat_max(plant_category)
	
	if plant_group == null:
		return
	
	# Check if the plant doesn't reach the max capacity of the tile
	if plant_group.get_child_count() < plant_max_nb:
		plant_node.grid_node = grid_node
		plant_group.call_deferred("add_child", plant_node)
		var _err = plant_node.connect("tree_exited", self, "_on_plant_died")
	
	# Connect the seed generation signal emited by the plant to the grid 
	# which is in charge of generating the moving_seed
	if plant_node.has_signal("generate_seed"):
		var _err = plant_node.connect("generate_seed", grid_node, "generate_moving_seed")
	
	if plant_node.has_signal("plant_grown"):
		var _err = plant_node.connect("plant_grown", self, "on_plant_grown")
	
	# Send a signal to signify the plant has been added
	# Not desired if the garden is currently beeing generated
	if !garden_generation:
		emit_signal("plant_added", plant_node)


# Return true if the given position is far enough (the minimum distance is defined by min_dist)
# from every seed in the seed array
func is_plant_correct_position(plant_node: Plant, pos: Vector2, min_dist: float = 4.0) -> bool:
	if pos == Vector2.INF:
		return false
	
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

func on_rain_applied():
	for plant in get_all_plants():
		plant.rain_applied()


# Called when the minimun wetness of this type of tile is reached
# Change the tile type
func _on_min_wetness_reached():
	var tile_type_name = tile_type.more_dry_tile_type
	
	if tile_type_name != "":
		change_tile_type(tile_type_name)


# Called when the maximum wetness of this type of tile is reached
# Change the tile type
func _on_max_wetness_reached():
	var tile_type_name = tile_type.more_wet_tile_type
	
	if tile_type_name != "":
		change_tile_type(tile_type_name)


# Called when the tile has finished beeing created
# Kill every plant that can't grow on the new type
func _on_type_changed(type: TileType):
	var type_name = type.get_type_name()
	for plant in get_all_plants():
		var fav_type = plant.favorable_tile_types
		if not type_name in fav_type:
			plant.die()


# Called when a plant is added
func _on_plant_added(_plant: Plant):
	pass


# Called when a plant die
func _on_plant_died():
	pass
#	update_tile_type()


# Called when wind is applied to this tile
func on_wind_applied(wind_dir: Vector2, wind_force: int, duration: float):
	for tree in trees_group_node.get_children():
		tree.apply_wind(wind_dir, wind_force, duration)
	
	tile_type.on_wind_applied(wind_dir, wind_force, duration)


# Make a plant grow by replacing its scene by the correct one
func on_plant_grown(plant_calling, next_plant_scene):
	var next_plant = next_plant_scene.instance()
	if next_plant:
		add_plant(next_plant, plant_calling.get_position())
	
	plant_calling.queue_free()
