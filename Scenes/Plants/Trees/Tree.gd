extends Plant
class_name TreeBase

export (int, 0, 100) var seed_spawn_chances = 20

signal generate_seed(pos, velocity, tree_type)

onready var tween_node = $Tween
onready var wind_anim_timer_node = $WindAnimTimer

var anim_running : bool = false

var wind_direction := Vector2.ZERO
var wind_force : int = 0

#### ACCESSORS ####


#### BUILT-IN ####

func _ready():
	randomize()
	
	var _err = tween_node.connect("tween_all_completed", self, "_on_bourasque_anim_finished")
	_err = wind_anim_timer_node.connect("timeout", self, "_on_wind_anim_timer_timeout")

#### LOGIC ####

func apply_wind(wind_dir: Vector2, force: int):
	var seed_rng = randi() % 100
	start_wind_animation(wind_dir, force)
	
	if seed_rng < seed_spawn_chances:
		emit_signal("generate_seed", global_position, wind_dir * force, Globals.base_tree)


func start_wind_animation(wind_dir: Vector2, force: int, variance: float = 30):
	var anim_duration : float = int(int(force / 100) * rand_range(-variance, variance) / 100)
	wind_anim_timer_node.start(anim_duration)
	wind_direction = wind_dir
	wind_force = force
	anim_running = true
	bourasque_animation(wind_dir, force)


func bourasque_animation(wind_dir: Vector2, force: int, variance: float = 30):
	force += int(force * (rand_range(-variance, variance) / 100))
	var anim_duration : float = 0.5
	if force != 0:
		anim_duration = 10 / clamp(float(force), 1.0, INF)
	var rotation_sign = sign(wind_dir.x)
	var rotation_amount = ((float(force) / 3) * rotation_sign) - 90
	var foliage = $Skeleton2D/Foliage
	
	tween_node.interpolate_property(foliage, "rotation_degrees",
		foliage.get_rotation_degrees(), rotation_amount, 
		anim_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween_node.start()




#### VIRTUALS ####

func get_category() -> String:
	return "Tree"


#### INPUTS ####


#### SIGNAL RESPONSES ####

func _on_bourasque_anim_finished():
	if anim_running:
		bourasque_animation(wind_direction, wind_force)

func _on_wind_anim_timer_timeout():
	anim_running = false
	bourasque_animation(Vector2.ZERO, 0)
	wind_direction = Vector2.ZERO
	wind_force = 0
