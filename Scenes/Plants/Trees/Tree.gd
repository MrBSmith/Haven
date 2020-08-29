extends Plant
class_name TreeBase

export (int, 0, 100) var seed_spawn_chances = 20

signal generate_seed(pos, velocity, tree_type)

#### ACCESSORS ####

#### BUILT-IN ####

func _ready():
	randomize()
	
	var _err = $StatesMachine.connect("state_changed", self, "_on_state_changed")

#### LOGIC ####

func apply_wind(wind_dir: Vector2, force: int, duration: float):
	var seed_rng = randi() % 100
	$StatesMachine/Wind.start_wind_animation(wind_dir, force, duration)
	
	if seed_rng < seed_spawn_chances:
		emit_signal("generate_seed", global_position, wind_dir * force, Globals.base_tree)


func set_fire():
	var fire = Globals.fire_fx.instance()
	$FirePosition.add_child(fire)


#### VIRTUALS ####

func get_category() -> String:
	return "Tree"


#### INPUTS ####


#### SIGNAL RESPONSES ####

func _on_state_changed(current_state_name: String):
	if current_state_name == "Idle":
		Events.emit_signal("single_plant_animation_finished")
