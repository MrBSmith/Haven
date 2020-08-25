extends KinematicBody2D
class_name Projectile

export var motions : Array setget , get_motions
export var direction := Vector2.ZERO
export var lifetime : float = 1.0

signal collided(collider, pos)
signal lifetime_finished()

var lifetime_timer : Timer = null

#### ACCESSORS ####

func get_motions() -> Array:
	return motions


#### BUILT-IN ####


func _ready():
	_setup()


func _physics_process(delta: float) -> void:
	var movement := _update_movement(delta)
	
	var collision := move_and_collide(movement)
	
	if collision:
		emit_signal("collided", collision.collider, collision.position)
		_impact()


#### LOGIC ####

# Calculates and returns the projectile's movement this frame
# Can mutate the projectile's state
func _update_movement(delta: float) -> Vector2:
	var movement_vector := Vector2.ZERO
	
	if motions.empty():
		return movement_vector

	for motion in motions:
		movement_vector += motion.update_movement(direction, delta)

	return movement_vector


func start_lifetime_timer():
	lifetime_timer = Timer.new()
	var _err = lifetime_timer.connect("timeout", self, "_on_lifetime_timer_finished")
	add_child(lifetime_timer)
	lifetime_timer.start(lifetime)


#### VIRTUALS ####

func _setup():
	start_lifetime_timer()

func _impact():
	pass


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_lifetime_timer_finished():
	emit_signal("lifetime_finished")
	queue_free()
