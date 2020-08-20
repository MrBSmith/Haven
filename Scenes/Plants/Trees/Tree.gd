extends Plant
class_name TreeBase

export (int, 0, 100) var seed_spawn_chances = 20

signal generate_seed(pos, velocity, tree_type)

#### ACCESSORS ####


#### BUILT-IN ####

func _ready():
	randomize()

#### LOGIC ####

func apply_wind(wind_dir: Vector2, force: int):
	var seed_rng = randi() % 100
	$StatesMachine/Wind.start_wind_animation(wind_dir, force)
	
	if seed_rng < seed_spawn_chances:
		emit_signal("generate_seed", global_position, wind_dir * force, Globals.base_tree)



#### VIRTUALS ####

func get_category() -> String:
	return "Tree"


#### INPUTS ####


#### SIGNAL RESPONSES ####
