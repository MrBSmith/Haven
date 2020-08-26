extends Light2D
class_name SunRay


#### ACCESSORS ####


#### BUILT-IN ####

func _ready():
	var tween = Tween.new()
	add_child(tween)
	
	texture_scale = rand_range(0.8, 1.5) 
	
	tween.interpolate_property(self, "energy",
	  0.0, rand_range(0.8, 1.0), 1,
	  Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	tween.interpolate_property(self, "energy",
	  energy, 0.0, 1,
	  Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(tween, "tween_all_completed")
	queue_free()


#### LOGIC ####


#### VIRTUALS ####


#### INPUTS ####


#### SIGNAL RESPONSES ####
