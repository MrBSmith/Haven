extends Plant
class_name Seed

#### ACCESSORS ####


#### BUILT-IN ####

func _ready():
	pass


#### LOGIC ####


# Add a tree of the good type to the tile, and destroy this seed
func transform_in_tree():
	var tile = current_tile_weakref.get_ref()
	if tile == null:
		print_debug("The tile reference doesn't exists")
		return
	
	var tree = Resource_Loader.tree_types[0].instance()
	tree.set_position(get_position())
	tile.call_deferred("add_child", tree)
	
	queue_free()


#### SIGNAL RESPONSES ####

func on_growth_finished():
	print("growth finished")
	transform_in_tree()

