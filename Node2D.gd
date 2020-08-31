extends Node2D

var impact_point : Vector2

#### ACCESSORS ####



#### BUILT-IN ####


func _ready():
	generate_thunder(impact_point)


func generate_thunder(impact_pos: Vector2):
	var lightning_projectile = Globals.lighting_main_branch.instance()
	lightning_projectile.connect("collided", self, "_on_lightning_collided")
	lightning_projectile.connect("tree_exiting", self, "_on_lightning_over")
	
	lightning_projectile.impact_point = impact_pos
	
	add_child(lightning_projectile)


#### LOGIC ####


#### VIRTUALS ####


#### INPUTS ####


#### SIGNAL RESPONSES ####

func _on_lightning_collided(impact_pos : Vector2):
	$Particles2D.set_position(impact_pos)
	$Particles2D.set_emitting(true)
	
	var tween = $Tween
	var world_enviroment = get_tree().get_current_scene().find_node("WorldEnvironment")
	var environement = world_enviroment.get_environment()
	
	tween.interpolate_property(environement, "glow_strength",
		 1.0, 0.0, 0.05,
		 Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	tween.interpolate_property(environement, "glow_strength",
		 1.0, 1.25, 0.05,
		 Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	tween.interpolate_property(environement, "glow_strength",
		 1.25, 1.0, 0.2,
		 Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		
	tween.start()
	
	yield(tween, "tween_all_completed")


func _on_lightning_over():
	queue_free()
