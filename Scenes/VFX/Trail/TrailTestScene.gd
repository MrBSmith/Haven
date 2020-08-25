extends Node2D

var wind_trail_scene = preload("res://Scenes/Projectile/WindTrail.tscn")

#### ACCESSORS ####



#### BUILT-IN ####



#### LOGIC ####


#### VIRTUALS ####


#### INPUTS ####

func _input(_event):
	randomize()
	
	if Input.is_action_just_pressed("ui_accept"):
		var wind_trail = wind_trail_scene.instance()
		wind_trail.set_position(Vector2(80, rand_range(60, 80)))
		wind_trail.direction = Vector2.LEFT
		add_child(wind_trail)

#### SIGNAL RESPONSES ####
