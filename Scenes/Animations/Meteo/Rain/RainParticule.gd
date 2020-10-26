extends CPUParticles2D
class_name RainParticule

export var total_lifetime : float = 3.0

var lifetime_timer : Timer
var destroy_cooldown : Timer

#### ACCESSORS ####



#### BUILT-IN ####

func _ready():
	lifetime_timer = Timer.new()
	var _err = lifetime_timer.connect("timeout", self, "_on_lifetime_over")
	
	add_child(lifetime_timer)
	lifetime_timer.start(total_lifetime)
	
	set_emission_sphere_radius(Globals.TILE_SIZE.x / 2)


#### LOGIC ####



#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_lifetime_over():
	destroy_cooldown = Timer.new()
	add_child(destroy_cooldown)
	destroy_cooldown.start(lifetime)
	set_emitting(false)
	
	yield(destroy_cooldown, "timeout")
	queue_free()
