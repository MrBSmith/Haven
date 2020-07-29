extends Node2D
class_name Hand

const wind_card_scene = preload("res://Scenes/Card/Wind/WindCard.tscn")
const sun_card_scene = preload("res://Scenes/Card/Sun/SunCard.tscn")
const rain_card_scene = preload("res://Scenes/Card/Rain/RainCard.tscn")

const card_types_array : Array = [wind_card_scene, sun_card_scene, rain_card_scene]

const CARD_SIZE = Vector2(16, 16)
const MAX_CARDS = 2

func _ready():
	roll()

func reroll():
	clear()
	roll()


func clear():
	for child in get_children():
		child.queue_free()


func roll():
	randomize()
	for i in range(MAX_CARDS):
		var rng = randi() % 3
		var new_card : Card = card_types_array[rng].instance()
		var pos := Vector2.ZERO
		
		if i == 0:
			pos = Vector2(- CARD_SIZE.x, 0)
		else:
			pos = Vector2(CARD_SIZE.x, 0)
		
		new_card.set_position(pos)
		new_card.set_default_position(pos)
		add_child(new_card)


func _unhandled_input(_event):
	if Input.is_action_just_pressed("RerollHand"):
		reroll()
