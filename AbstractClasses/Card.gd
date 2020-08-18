extends Area2D
class_name Card

onready var sprite_node = $Sprite

export var area_of_effect : Resource = null
export var effect_on_tile : Resource = null

var mouse_over : bool = false
var default_position := Vector2.ZERO setget set_default_position, get_default_position

var pickable : bool = true setget set_pickable, get_pickable
var hand_index : int = -1 setget set_hand_index, get_hand_index

signal active_effect
signal normal_effect_finished
signal combined_effect_finished

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

func set_pickable(value: bool):
	pickable = value

func get_pickable() -> bool:
	return pickable

func set_hand_index(value: int):
	hand_index = value

func get_hand_index() -> int:
	return hand_index


#### BUILT-IN ####

func _ready():
	var sprite_size = $Sprite.get_texture().get_size()
	var shape = $CollisionShape2D.get_shape()
	
	shape.set_extents(sprite_size / 2)
	var _err = connect("mouse_entered", self, "_on_mouse_entered")
	_err = connect("mouse_exited", self, "_on_mouse_exited")
	_err = connect("active_effect", get_parent(), "_on_card_active_effect")
	_err = connect("normal_effect_finished", get_parent(), "_on_card_normal_effect_finished")
	_err = connect("combined_effect_finished", get_parent(), "_on_card_combined_effect_finished")
	_err = $StateMachine.connect("state_changed", self, "_on_state_changed")

#### LOGIC ####

func destroy():
	set_state("Destroy")


#### INPUTS ####

func _unhandled_input(_event):
	if get_state_name() == "Effect" or pickable == false:
		return
	
	# Trigger the drag state
	if Input.is_action_just_pressed("click") && mouse_over:
		set_state("Drag")
	
	if Input.is_action_just_released("click"):
		# Triggers the effect of the card
		if get_state_name() == "Target" && $Area.get_child_count() > 0:
			set_state("Effect")
		
		# The card was droped on an invalid position
		else:
			set_state("Idle")


# Apply the effect of the card on the targeted tiles
# Called by the target state, when going to the effect state
# wind_dir can be used optionaly in the children classes 
func normal_effect(tiles_array: Array, _wind_dir := Vector2.ZERO):
	affect_tiles_wetness(tiles_array)


# Apply the effect, when the players got the same card twice in hand
func combined_effect():
	var grid_node = get_tree().get_current_scene().get_node("Grid")
	var tiles_affected = grid_node.get_tile_array()
	$Area.create_area(tiles_affected)
	
	affect_tiles_wetness(tiles_affected, 1.5)
	
	call_deferred("set_state", "CombinedEffect")


# Affect the given tiles wetness by the value contained 
# in effect_on_tile.wetness with the given modifier
func affect_tiles_wetness(tiles_array: Array, modifier : float = 1.0):
	randomize()
	
	var wetness = effect_on_tile.wetness
	if wetness == 0:
		return
	
	var effect_variance = effect_on_tile.wetness_variance
	
	for tile in tiles_array:
		var variance_rate := rand_range(-effect_variance, effect_variance)
		var variance : float = wetness * (variance_rate / 100)
		var wetness_change = (wetness + variance) * modifier
		
		tile.add_to_wetness(wetness_change)


#### SIGNAL RESPONSES ####

func _on_mouse_entered():
	mouse_over = true

func _on_mouse_exited():
	mouse_over = false


func _on_state_changed(state_name: String):
	if state_name == "Effect":
		emit_signal("active_effect")
		
	elif state_name == "Destroy":
		var previous_state = $StateMachine.previous_state.name
		if previous_state == "Effect":
			emit_signal("normal_effect_finished", get_index())
		elif previous_state == "CombinedEffect":
			emit_signal("combined_effect_finished")


func on_grid_entered():
	if get_state_name() == "Drag":
		set_state("Target")


func on_grid_exited():
	if get_state_name() == "Target":
		set_state("Drag")
