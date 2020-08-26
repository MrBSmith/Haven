extends YSort
class_name MeteoAnimation

var duration : float = 3.0
var duration_timer : Timer
var cooldown_timer : Timer

var spawn_area : Rect2

var spawning : bool = true

#### ACCESSORS ####


#### BUILT-IN ####

func _ready():
	randomize()
	
	duration_timer = Timer.new()
	add_child(duration_timer)
	var _err = duration_timer.connect("timeout", self, "_on_duration_timeout")
	
	duration_timer.start(duration)


#### LOGIC ####

func refresh_cooldown():
	cooldown_timer.start(rand_range(0.1, 0.3))


func random_spawn_position() -> Vector2:
	var rdm_local_pos = Vector2(rand_range(0.0, spawn_area.size.x), rand_range(0.0, spawn_area.size.y))
	return spawn_area.position + rdm_local_pos


func init_cooldown_timer():
	cooldown_timer = Timer.new()
	add_child(cooldown_timer)
	var _err = cooldown_timer.connect("timeout", self, "_on_cooldown_timeout")
	
	refresh_cooldown()


#### VIRTUALS ####


#### INPUTS ####


#### SIGNAL RESPONSES ####

func _on_duration_timeout():
	spawning = false
	
	if duration_timer:
		duration_timer.queue_free()
	
	if cooldown_timer:
		cooldown_timer.queue_free()


func _on_effect_tree_exited():
	if get_child_count() == 0:
		Events.emit_signal("meteo_animation_finished")
		queue_free()
