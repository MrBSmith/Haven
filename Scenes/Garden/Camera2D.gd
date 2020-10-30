extends Camera2D

const TYPE : String = "Camera2D"


#### ACCESSORS ####

func is_class(value : String) -> bool: return value == TYPE or .is_class(value)
func get_class() -> String : return TYPE


#### BUILT-IN ####

func _ready():
	set_zoom(Vector2.ONE * (Globals.get_grid_pixel_size().x / Globals.window_size.x))

#### LOGIC ####



#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
