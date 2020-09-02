extends StaticBody2D
class_name Plant

var grid_node : Node2D

export var min_sibling_dist : float = 2.0 setget set_min_sibling_dist, get_min_sibling_dist
export var drain_amount : int = 5
export var growth_frequency_time : float = 1.2

var adult : bool = false setget set_adult, is_adult
var growth_timer_node : Timer = null
var growth : int = 3 setget set_growth, get_growth
var dehydration : int = 0 setget set_dehydration, get_dehydration

var hit_by_thunder : bool = false
var current_tile_weakref : WeakRef = null

var on_fire : bool = false setget , is_on_fire

export var favorable_tile_types : PoolStringArray = ["Soil", "Grass", "Forest"]

signal plant_died


#### ACCESSORS ####

func is_type(type): return type == "Plant"
func get_type(): return "Plant"

func is_on_fire() -> bool:
	return on_fire

func set_min_sibling_dist(value: float):
	min_sibling_dist = value

func get_min_sibling_dist() -> float:
	return min_sibling_dist

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

func set_adult(value: bool):
	adult = value

func is_adult() -> bool:
	return adult

# Set the level of dehydration, from 0 to 2
# When the dehydration reach 2, the plant die
func set_dehydration(value: int):
	if value >= 0 && value < 3:
		dehydration = value
	
	if dehydration == 2:
		die()

func get_dehydration() -> int:
	return dehydration

func add_to_dehydration(value: int):
	set_dehydration(get_dehydration() + value)

func get_state() -> StateBase:
	var state_machine = get_node_or_null("StatesMachine")
	if state_machine == null:
		return null
	else:
		return state_machine.get_state()


#### BUILT-IN ####

func _ready():
	add_to_group("Plant")


#### LOGIC ####

func new_turn():
	hit_by_thunder = false
	try_to_grow()


func try_to_grow():
	if is_adult():
		return
	
	var drained_water = drain_tile_water()
	if drained_water >= drain_amount:
		grow()
	elif drained_water < float(drain_amount) / 2:
		add_to_dehydration(1)

func grow():
	add_to_growth(1)
	add_to_dehydration(-1)


# Drain water from the tile, il the amount of water drain is sufficent, grow
func drain_tile_water() -> int:
	var tile = current_tile_weakref.get_ref()
	if tile == null:
		print_debug("The tile reference doesn't exists")
		return 0
	
	return tile.drain_wetness(drain_amount)


func die():
	queue_free()
	emit_signal("plant_died", get_category())


func rain_applied():
	if is_on_fire() && !hit_by_thunder:
		stop_fire()


#### INPUTS ####


#### VIRTUALS ####

func get_category() -> String:
	return ""


func set_fire(thunder: bool = false):
	hit_by_thunder = thunder


func stop_fire():
	on_fire = false

#### SIGNAL RESPONSES ####

func on_growth_finished():
	set_adult(true)
	if Globals.debug_state == true:
		print("growth finished")

func on_growth_failed():
	queue_free()
