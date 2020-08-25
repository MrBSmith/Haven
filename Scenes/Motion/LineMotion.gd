extends Motion
class_name LineMotion

export var speed : float = 1.0

#### ACCESSORS ####



#### BUILT-IN ####



#### LOGIC ####

func update_movement(direction: Vector2, delta: float) -> Vector2:
	return direction * speed * delta


#### INPUTS ####



#### SIGNAL RESPONSES ####
