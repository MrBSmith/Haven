extends Line2D
class_name WindTrail

export var trail_max_lenght: int = 20

#### ACCESSORS ####

func _ready():
	set_as_toplevel(true)


#### BUILT-IN ####

func _physics_process(_delta):
	var point = get_parent().get_global_position()
	add_point(point)
	
	if points.size() > trail_max_lenght:
		remove_point(0)

#### LOGIC ####

#### INPUTS ####

#### SIGNAL RESPONSES ####
