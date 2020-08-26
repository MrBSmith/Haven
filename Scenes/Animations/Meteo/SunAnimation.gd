extends MeteoAnimation
class_name SunAnimation

onready var sunray_scene = preload("res://Scenes/Animations/Meteo/Sun/SunRay.tscn")

#### ACCESSORS ####



#### BUILT-IN ####

func _init(rect_area : Rect2, durat: float):
	spawn_area = rect_area
	duration = durat


func _ready():
	init_cooldown_timer()


#### LOGIC ####



#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####


func _on_cooldown_timeout():
	if spawning:
		var sunray = sunray_scene.instance()
		var _err = sunray.connect("tree_exited", self, "_on_effect_tree_exited")
		
		sunray.set_position(random_spawn_position())
		
		add_child(sunray)
		refresh_cooldown()
