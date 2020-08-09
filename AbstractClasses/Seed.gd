extends Plant
class_name Seed

var growth_timer_node : Timer = null
var growth : int = 3 setget set_growth, get_growth

export var drain_amount : int = 5
export var growth_frequency_time : float = 1.2


#### ACCESSORS ####

func set_growth(value: int):
	growth = int(clamp(float(value), 0.0, 10.0))
	if growth == 10:
		on_growth_finished()
	elif growth == 0:
		on_growth_failed()

func get_growth() -> int:
	return growth

func add_to_growth(value: int):
	set_growth(get_growth() + value)


#### BUILT-IN ####

func _ready():
	growth_timer_node = Timer.new()
	var _err = growth_timer_node.connect("timeout", self, "on_growth_timer_timeout")
	growth_timer_node.set_wait_time(growth_frequency_time)
	add_child(growth_timer_node)
	
	growth_timer_node.start()


#### LOGIC ####

# Drain water from the tile, il the amount of water drain is sufficent, grow
func drain_tile_water():
	var tile = current_tile_weakref.get_ref()
	if tile == null:
		print_debug("The tile reference doesn't exists")
		return
	
	var water_drained = tile.drain_wetness(drain_amount)
	
	if water_drained == drain_amount:
		add_to_growth(1)


# Add a tree of the good type to the tile, and destroy this seed
func transform_in_tree():
	var tile = current_tile_weakref.get_ref()
	if tile == null:
		print_debug("The tile reference doesn't exists")
		return
	
	var tree = Globals.tree_types[0].instance()
	tree.set_position(get_position())
	tile.call_deferred("add_child", tree)
	
	queue_free()


#### SIGNAL RESPONSES ####

func on_growth_timer_timeout():
	drain_tile_water()

func on_growth_finished():
	print("growth finished")
	transform_in_tree()

func on_growth_failed():
	queue_free()
