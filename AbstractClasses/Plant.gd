extends StaticBody2D
class_name Plant

var grid_node : Node2D
export var debug : bool = false

export var min_sibling_dist : float = 2.0 setget set_min_sibling_dist, get_min_sibling_dist
export var drain_amount : int = 5
export var growth_frequency_time : float = 1.2

var eater : WeakRef = null setget set_eater, get_eater

var growth_progression : int = 3 setget set_growth_progression, get_growth_progression
var dehydration : int = 0 setget set_dehydration, get_dehydration

var hit_by_thunder : bool = false
var current_tile_weakref : WeakRef = null

var on_fire : bool = false setget , is_on_fire

var mouse_inside : bool = false

export var current_growth_state : int = 0
export var plant_growth_state : Array = []

export var favorable_tile_types : PoolStringArray = ["Soil", "Grass", "Forest"]

signal plant_died
signal is_being_ate
signal plant_grown(plant, next_state_scene)

#### ACCESSORS ####

func is_type(type): return type == "Plant"
func get_type(): return "Plant"

func set_eater(value: WeakRef): 
	eater = value
	if eater != null:
		emit_signal("is_being_ate")

func get_eater(): return eater

func is_on_fire() -> bool:
	return on_fire

func set_min_sibling_dist(value: float):
	min_sibling_dist = value

func get_min_sibling_dist() -> float:
	return min_sibling_dist

func set_growth_progression(value: int):
	growth_progression = int(clamp(float(value), 0.0, 10.0))
	if growth_progression == 10:
		on_growth_finished()
	elif growth_progression == 0:
		on_growth_failed()

func get_growth_progression() -> int:
	return growth_progression

func add_to_growth_progression(value: int):
	set_growth_progression(get_growth_progression() + value)


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
	
	var _err = connect("mouse_entered", self, "on_mouse_entered")
	_err = connect("mouse_exited", self, "on_mouse_exited")
	
	var parent = get_parent()
	if parent.has_method("on_plant_grown"):
		_err = connect("plant_grown", parent, "on_plant_grown")


#### LOGIC ####

func new_turn():
	hit_by_thunder = false
	try_to_grow()


func try_to_grow():
#	if is_adult():
#		return
	
	var drained_water = drain_tile_water()
	if drained_water >= drain_amount:
		grow()
	elif drained_water < float(drain_amount) / 2:
		add_to_dehydration(1)

func grow():
	add_to_growth_progression(1)
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

func ate():
	queue_free()
	emit_signal("plant_died", get_category())


func rain_applied():
	if is_on_fire() && !hit_by_thunder:
		stop_fire()

# Get a random growth state of the tree
# Return the path of the scene corresponding to this state
func get_random_growth_state() -> String:
	var nb_types = plant_growth_state.size()
	if nb_types <= 0:
		return "" 
	
	var rdm_type_id = randi() % nb_types
	return plant_growth_state[rdm_type_id]


# Get the next growth state in the dictionary, based on the given state name
# Return the path of the scene corresponding to this state
# Return "" if nothing were found
func get_next_growth_state(state_index: int) -> String:
	if state_index < 0 or state_index >= plant_growth_state.size():
		print("The wanted state at index " + String(state_index) + " Wasn't found")
		return ""
	
	var current_state = plant_growth_state[state_index]
	var next_id = state_index + 1
	
	if next_id >= plant_growth_state.size():
		return ""
	else:
		return plant_growth_state[next_id]

#### INPUTS ####

func _input(_event):
	if Input.is_action_just_pressed("click") && mouse_inside:
		on_growth_finished()


#### VIRTUALS ####

func get_category() -> String:
	return ""

func set_fire(thunder: bool = false):
	hit_by_thunder = thunder

func stop_fire():
	on_fire = false

#### SIGNAL RESPONSES ####

func on_mouse_entered():
	mouse_inside = true
	if debug:
		print("the mouse entered " + name)

func on_mouse_exited():
	mouse_inside = false


func on_growth_finished():
	var next_state_path = get_next_growth_state(current_growth_state)
	if next_state_path != "":
		emit_signal("plant_grown", self, load(next_state_path))
		
		if Globals.debug_state == true:
			print("growth finished")

func on_growth_failed():
	queue_free()
