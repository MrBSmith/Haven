extends Node2D
class_name Hand

onready var garden_node = get_parent()

const wind_card_scene = preload("res://Scenes/Card/Wind/WindCard.tscn")
const sun_card_scene = preload("res://Scenes/Card/Sun/SunCard.tscn")
const rain_card_scene = preload("res://Scenes/Card/Rain/RainCard.tscn")

const card_types_array : Array = [wind_card_scene, sun_card_scene, rain_card_scene]

const CARD_SIZE = Vector2(16, 16)
const MAX_CARDS = 2

signal turn_finished

#### BUILT-IN ####

func _ready():
	var _err = connect("turn_finished", garden_node, "_on_turn_finished")
	var _nothing = roll()

#### LOGIC ####

# Clear every card in the hand, and generate a new hand
# Make sure the hand rerolled is different form the last one
func reroll():
	var current_hand = get_current_cards_types()
	var previous_hand : PoolStringArray = current_hand
	clear()
	
	while(current_hand == previous_hand or previous_hand == current_hand.invert()):
		var rdm_hand = roll()
		current_hand.empty()
		for card in rdm_hand:
			current_hand.append(card.get_type())


# Clear every card in the hand
func clear():
	for child in get_children():
		child.queue_free()


# Generate the hand, without duplicate
func roll() -> Array:
	randomize()
	var card_types = card_types_array.duplicate()
	var new_hand : Array = []
	
	for index in range(MAX_CARDS):
		var rng = randi() % card_types.size()
		var new_card : Card = card_types[rng].instance()
		card_types.remove(rng)
		new_hand.append(new_card)
		add_card(new_card, index)
	
	return new_hand


# Draw a new card
func draw_card(card_index: int):
	var new_card = generate_card()
	add_card(new_card, card_index)
	
	var other_card_id = 0
	if card_index == 0:
		other_card_id = 1
	
	var new_card_type = new_card.get_type()
	var other_card = get_child(other_card_id)
	var other_card_type = other_card.get_type()
	
	if new_card_type == other_card_type:
		yield(new_card, "ready")
		new_card.combined_effect()


# Return an array of the types names of the current cards in hand (as Strings)
func get_current_cards_types() -> PoolStringArray:
	var type_array : PoolStringArray = []
	for child in get_children():
		type_array.append(child.get_type())
	
	return type_array


func generate_card() -> Card:
	randomize()
	var rng = randi() % 3
	var new_card : Card = card_types_array[rng].instance()
	return new_card


func add_card(new_card: Card, card_index: int):
	var pos := Vector2.ZERO
	
	if card_index == 0:
		pos = Vector2(- CARD_SIZE.x, 0)
	else:
		pos = Vector2(CARD_SIZE.x, 0)
	
	new_card.set_position(pos)
	new_card.set_default_position(pos)
	call_deferred("add_child", new_card)
	
	if new_card.get_index() != card_index:
		call_deferred("move_child", new_card, card_index)


func set_cards_pickable(value: bool):
	for card in get_children():
		card.set_pickable(value)

#### INPUTS ####

func _unhandled_input(_event):
	if Input.is_action_just_pressed("RerollHand"):
		reroll()


#### SIGNAL RESPONSES ####

func _on_card_normal_effect_finished(card_index: int):
	draw_card(card_index)
	emit_signal("turn_finished")


func _on_card_combined_effect_finished():
	reroll()
	emit_signal("turn_finished")


func on_nature_turn_finished():
	set_cards_pickable(true)


func _on_card_active_effect():
	set_cards_pickable(false)
