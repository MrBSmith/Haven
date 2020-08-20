extends Area2D

var mouse_inside_screen : bool = true setget set_mouse_inside_screen, is_mouse_inside_screen

#### ACCESSORS ####

func set_mouse_inside_screen(value: bool):
	mouse_inside_screen = value

func is_mouse_inside_screen() -> bool:
	return mouse_inside_screen


#### BUILT-IN ####

func _ready():
	adapt_to_screen_size()
	var _err = connect("mouse_entered", self, "_on_mouse_entered")
	_err = connect("mouse_exited", self, "_on_mouse_exited")
	
	set_mouse_inside_screen(true)


func adapt_to_screen_size():
	var half_window_size = Globals.window_size / 2
	var shape = $CollisionShape2D.get_shape()
	set_position(half_window_size)
	shape.set_extents(half_window_size)


#### LOGIC ####


#### INPUTS ####


#### SIGNAL RESPONSES ####

func _on_mouse_entered():
	set_mouse_inside_screen(true)

func _on_mouse_exited():
	set_mouse_inside_screen(false)
