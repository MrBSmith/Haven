extends Projectile
class_name LightningProjectile

var width : float = 2.5 * Globals.get_tile_upscale().x

var stroke_average_duration : float
var new_branch_cooldown_duration : float
var new_branch_probability : float

var nb_strokes_remaining : int = 0
var total_nb_strokes : int = 0

var stroke_timer : Timer
var new_branch_cooldown : Timer

var game_upscale : float = 1.0

#### ACCESSORS ####


#### BUILT-IN ####

func _setup():
	randomize()
	
	compute_individal_values()
	game_upscale = Globals.get_tile_upscale().x
	
	var divider = int(width / game_upscale) + 2
	if divider != 0:
		nb_strokes_remaining = randi() % divider
	else:
		nb_strokes_remaining = 3
	
	total_nb_strokes = nb_strokes_remaining
	
	$LightingTrail.width = width / 2
	
	stroke_timer = Timer.new()
	new_branch_cooldown = Timer.new()
	
	var _err = stroke_timer.connect("timeout", self, "_on_stroke_timer_timeout")
	_err = new_branch_cooldown.connect("timeout", self, "_on_new_branch_timeout")
	
	add_child(new_branch_cooldown)
	add_child(stroke_timer)
	
	set_physics_process(false)

	start_new_branch_timer()
	start_stroke()
	
	yield($SecondaryBranchWait, "timeout")
	set_physics_process(true)


#### LOGIC ####

func start_stroke():
	nb_strokes_remaining -= 1
	stroke_timer.start(compute_rdm_duration(stroke_average_duration, 0.2))
	direction = compute_rdm_direction(direction, 0.2, 0.3)


func start_new_branch_timer():
	new_branch_cooldown.start(compute_rdm_duration(new_branch_cooldown_duration, 0.3))


func compute_individal_values():
	stroke_average_duration = width * game_upscale / (motions[0].speed * 3)
	new_branch_cooldown_duration = width * game_upscale / (motions[0].speed * 3)
	new_branch_probability = width / game_upscale * 20


func compute_rdm_duration(duration: float, variance: float) -> float:
	return duration + duration * rand_range(-variance, variance)


# Compute a random decending angle
func compute_rdm_direction(dir: Vector2, min_rdm_angle := 0.2, max_rdm_angle := 0.8) -> Vector2:
	var angle = dir.angle()
	var rdm_sign = sign(rand_range(-1.0, 1.0))
	angle += rand_range(min_rdm_angle, max_rdm_angle) * rdm_sign
	return Vector2(cos(angle), sin(angle)).normalized()


# Generate a new branch
func generate_new_branch():
	var new_width = width - game_upscale
	
	if new_width < 1.0:
		return
	
	var new_branch = Resource_Loader.lighting_branch.instance()
	new_branch.width = new_width
	
	new_branch.direction = compute_rdm_direction(direction)
	
	add_child(new_branch)

#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_stroke_timer_timeout():
	if nb_strokes_remaining > 0:
		start_stroke()
	else:
		direction = Vector2.ZERO
		stroke_timer.stop()
		new_branch_cooldown.stop()


func _on_new_branch_timeout():
	if nb_strokes_remaining <= 1:
		new_branch_cooldown.stop()
		return
	elif nb_strokes_remaining >= total_nb_strokes - 1:
		return
	
	var rng = rand_range(0.0, 100.0)
	if rng < new_branch_probability:
		generate_new_branch()
	
	start_new_branch_timer()
