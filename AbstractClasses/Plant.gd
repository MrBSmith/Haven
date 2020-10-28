extends StaticBody2D
class_name Plant

var grid_node : Node2D
export var debug : bool = false

export var min_sibling_dist : float = 2.0 setget set_min_sibling_dist, get_min_sibling_dist

var eater : WeakRef = null setget set_eater, get_eater

var growth_progression : int = 3 setget set_growth_progression, get_growth_progression

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


func try_to_grow():
	var current_tile = current_tile_weakref.get_ref()
	var tile_type = current_tile.get_tile_type_name()
	
	if tile_type in favorable_tile_types:
		grow()

func grow():
	add_to_growth_progression(10)


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
	if state_index < 0 or state_index > plant_growth_state.size():
		print("The wanted state at index " + String(state_index) + " Wasn't found")
		return ""

	var next_id = state_index + 1
	if next_id >= plant_growth_state.size():
		return ""
	else:
		return plant_growth_state[next_id]



#### INPUTS ####

func _input(_event):
	if Input.is_action_just_pressed("click") && mouse_inside && debug:
		add_to_growth_progression(10)


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


func on_new_turn_started():
	hit_by_thunder = false


func on_plant_phase_start():
	try_to_grow()


func on_growth_finished():
	var next_state_path = get_next_growth_state(current_growth_state)
	if next_state_path != "":
		emit_signal("plant_grown", self, load(next_state_path))
		
		if debug:
			print("growth finished")

func on_growth_failed():
	queue_free()
