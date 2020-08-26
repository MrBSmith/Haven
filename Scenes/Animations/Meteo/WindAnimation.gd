extends MeteoAnimation
class_name WindAnimation

var wind_trail_scene = preload("res://Scenes/Projectile/WindTrail.tscn")

var wind_direction := Vector2.ZERO
var wind_force : float = 0.0

#### ACCESSORS ####



#### BUILT-IN ####

func _init(spawn_rect: Rect2, dir: Vector2, force: float, durat := 3.0):
	wind_direction = dir
	wind_force = force
	duration = durat
	spawn_area = spawn_rect


func _ready():
	init_cooldown_timer()


#### LOGIC ####


#### VIRTUALS ####


#### INPUTS ####


#### SIGNAL RESPONSES ####


func _on_cooldown_timeout():
	if spawning:
		var wind_trail = wind_trail_scene.instance()
		var _err = wind_trail.connect("tree_exited", self, "_on_effect_tree_exited")
		
		wind_trail.direction = wind_direction
		wind_trail.wind_force = wind_force
		wind_trail.set_position(random_spawn_position())
		
		add_child(wind_trail)
		refresh_cooldown()

