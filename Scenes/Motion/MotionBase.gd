extends Resource
class_name Motion

#### ACCESSORS ####

func _ready():
	set_local_to_scene(true)

#### BUILT-IN ####



#### LOGIC ####


#### VIRTUALS ####

func update_movement(_direction: Vector2, _delta: float) -> Vector2:
	return Vector2.ZERO

#### INPUTS ####



#### SIGNAL RESPONSES ####
