extends Area2D
class_name Card

onready var sprite_node = $Sprite

export var area_of_effect : Resource = null
export var effect_on_tile : Resource = null

var mouse_over : bool = false
var default_position := Vector2.ZERO setget set_default_position, get_default_position

signal destroyed

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

func destroy():
	emit_signal("destroyed", get_position_in_parent())
	queue_free()


#### INPUTS ####

func _unhandled_input(_event):
	if get_state_name() == "Effect":
		return
	
	# Trigger the drag state
	if Input.is_action_just_pressed("click") && mouse_over:
		set_state("Drag")
	
	if Input.is_action_just_released("click"):
		# Triggers the effect of the card
		if get_state_name() == "Target" && $Area.get_child_count() > 0:
			set_state("Effect")
			affect_tiles($StateMachine/Target.affected_tiles_array)
		
		# The card was droped on an invalid position
		else:
			set_state("Idle")


func affect_tiles(tiles_array: Array):
	randomize()
	
	var wetness = effect_on_tile.wetness
	if wetness == 0:
		return
	
	for tile in tiles_array:
		var var_sign = sign((randi() % 50) - 25)
		var variance_rate := float((randi() % effect_on_tile.wetness_variance) * var_sign)
		var variance : float = wetness * (variance_rate / 100)
		var wetness_change = wetness + variance
		
		tile.add_to_wetness(wetness_change)


#### SIGNAL RESPONSES ####

func _on_mouse_entered():
	mouse_over = true

func _on_mouse_exited():
	mouse_over = false

func on_grid_entered():
	if get_state_name() == "Drag":
		set_state("Target")

func on_grid_exited():
	if get_state_name() == "Target":
		set_state("Drag")
