extends MeteoAnimation
class_name WindAnimation

var wind_trail_scene = preload("res://Scenes/Projectile/WindTrail.tscn")

var wind_direction := Vector2.ZERO
var wind_force : float = 0.0
var duration : float = 3.0

var spawn_area : Rect2

var duration_timer : Timer
var cooldown_timer : Timer

var spawning : bool = true

#### ACCESSORS ####



#### BUILT-IN ####

func _init(spawn_rect: Rect2, dir: Vector2, force: float, durat := 3.0):
	wind_direction = dir
	wind_force = force
	duration = durat
	spawn_area = spawn_rect


func _ready():
	randomize()
	
	duration_timer = Timer.new()
	cooldown_timer = Timer.new()
	
	add_child(duration_timer)
	add_child(cooldown_timer)
	
	var _err = duration_timer.connect("timeout", self, "_on_duration_timeout")
	_err = cooldown_timer.connect("timeout", self, "_on_cooldown_timeout")
	
	duration_timer.start(duration)
	refresh_cooldown()

#### LOGIC ####


func refresh_cooldown():
	cooldown_timer.start(rand_range(0.1, 0.3))


func random_spawn_position() -> Vector2:
	var rdm_local_pos = Vector2(rand_range(0.0, spawn_area.size.x), rand_range(0.0, spawn_area.size.y))
	return spawn_area.position + rdm_local_pos


#### VIRTUALS ####


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_duration_timeout():
	spawning = false


func _on_cooldown_timeout():
	if spawning:
		var wind_trail = wind_trail_scene.instance()
		var _err = wind_trail.connect("tree_exited", self, "_on_trail_tree_exited")
		
		wind_trail.direction = wind_direction
		wind_trail.wind_force = wind_force
		wind_trail.set_position(random_spawn_position())
		
		add_child(wind_trail)
		refresh_cooldown()


func _on_trail_tree_exited():
	if get_child_count() == 0:
		Events.emit_signal("meteo_animation_finished")
		queue_free()
