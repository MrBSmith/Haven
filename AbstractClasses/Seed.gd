extends Plant
class_name Seed

#### ACCESSORS ####


#### BUILT-IN ####

func _ready():
	growth_timer_node = Timer.new()
	var _err = growth_timer_node.connect("timeout", self, "on_growth_timer_timeout")
	growth_timer_node.set_wait_time(growth_frequency_time)
	add_child(growth_timer_node)
	
	growth_timer_node.start()


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

