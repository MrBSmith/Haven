extends Motion
class_name CircleMotion

export var speed : float = 5
export var radius : float = 5
export var orbit_damping : float = 0.0
export var offset := Vector2(0.2, 0.5) 
export var clockwise : bool = true
var _centre
var angle = 0

#### ACCESSORS ####



#### BUILT-IN ####



#### LOGIC ####



#### VIRTUALS ####

func update_movement(_direction: Vector2, delta: float) -> Vector2:
	angle += speed * delta
	radius -= orbit_damping
	var rotation_dir = int(clockwise) * 2 - 1
	return Vector2(sin(angle + offset.x), cos(angle + offset.y)) * radius * rotation_dir


#### INPUTS ####



#### SIGNAL RESPONSES ####
