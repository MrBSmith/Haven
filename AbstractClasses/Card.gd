extends Area2D
class_name Card

onready var sprite_node = $Sprite

var mouse_over : bool = false
var default_position := Vector2.ZERO setget set_default_position, get_default_position

var AOE = null

#### ACCESSORS ####

func set_default_position(value: Vector2):
	default_position = value

func get_default_position() -> Vector2:
	return default_position

func set_state(state_name: String):
	$StateMachine.set_state(state_name)

func get_state() -> StateBase:
	return $StateMachine.get_state()

func get_state_name() -> String:
	return $StateMachine.get_state_name() 


#### BUILT-IN ####

func _ready():
	var sprite_size = $Sprite.get_texture().get_size()
	var shape = $CollisionShape2D.get_shape()
	
	shape.set_extents(sprite_size / 2)
	var _err = connect("mouse_entered", self, "_on_mouse_entered")
	_err = connect("mouse_exited", self, "_on_mouse_exited")


#### LOGIC ####



#### INPUTS ####

func _unhandled_input(_event):
	if Input.is_action_just_pressed("click") && mouse_over:
		set_state("Drag")
	if Input.is_action_just_released("click"):
		set_state("Idle")


#### SIGNAL RESPONSES ####

func _on_mouse_entered():
	mouse_over = true

func _on_mouse_exited():
	mouse_over = false

func on_grid_entered():
	if get_state_name() == "Drag":
		set_state("AOE")

func on_grid_exited():
	if get_state_name() == "AOE":
		set_state("Drag")
