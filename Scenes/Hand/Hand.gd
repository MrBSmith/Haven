extends Node2D
class_name Hand

onready var garden_node = get_parent()

const wind_card_scene = preload("res://Scenes/Card/Wind/WindCard.tscn")
const sun_card_scene = preload("res://Scenes/Card/Sun/SunCard.tscn")
const rain_card_scene = preload("res://Scenes/Card/Rain/RainCard.tscn")

const card_types_array : Array = [wind_card_scene, sun_card_scene, rain_card_scene]

const CARD_SIZE = Vector2(16, 16)
const MAX_CARDS = 2

signal card_drawn

var last_card_played_index : int = 0

#### BUILT-IN ####

func _ready():
	var _err = connect("card_drawn", self, "_on_card_drawn")
	

#### LOGIC ####

func draw():
	var nb_children = get_child_count()
	match nb_children:
		0: roll()
		1: draw_card(last_card_played_index)
		2: return


# Clear every card in the hand, and generate a new hand
# Make sure the hand rerolled is different form the last one
func reroll():
	clear()
	roll()


# Clear every card in the hand
func clear():
	for child in get_children():
		child.queue_free()


# Generate the hand, without duplicate
func roll():
	randomize()
	var card_types = card_types_array.duplicate()
	var new_hand : Array = []
	
	for index in range(MAX_CARDS):
		var rng = randi() % card_types.size()
		var new_card : Card = card_types[rng].instance()
		card_types.remove(rng)
		new_hand.append(new_card)
		add_card(new_card, index)


# Draw a new card
func draw_card(card_index: int):
	var new_card = generate_card()
	add_card(new_card, card_index)


# Return an array of the types names of the current cards in hand (as Strings)
func get_current_cards_types() -> PoolStringArray:
	var type_array : PoolStringArray = []
	for child in get_children():
		type_array.append(child.get_type())
	
	return type_array


# Generate a random card from th pool of types
func generate_card() -> Card:
	randomize()
	var rng = randi() % 3
	var new_card : Card = card_types_array[rng].instance()
	return new_card


# Add the given card to the hand
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
	
	yield(new_card, "ready")
	emit_signal("card_drawn")


# Set every cards pickable or not
func set_cards_pickable(value: bool):
	for card in get_children():
		card.set_pickable(value)

#### INPUTS ####

func _unhandled_input(_event):
	if Input.is_action_just_pressed("RerollHand"):
		reroll()


#### SIGNAL RESPONSES ####

func _on_card_effect_finished(card_index: int, _combined: bool):
	yield(get_child(card_index), "tree_exited")
	
	last_card_played_index = card_index


# Called by the garden node, authorize the player to pick a card
func on_new_turn_started():
	set_cards_pickable(true)


# Called by the garden node, block the player from picking a card
func meteo_animation_started():
	set_cards_pickable(false)


func _on_card_drawn():
	if get_child_count() == 2:
		_on_hand_refilled()


func _on_hand_refilled():
	var first_card = get_child(0)
	var second_card = get_child(1)
	
	if first_card.get_type() == second_card.get_type():
		first_card.destroy()
		second_card.combined_effect()
