extends Node2D

var tile_area_scene = preload("res://Scenes/TileArea/TileArea.tscn")

func _ready():
	pass


func create_area(pos_array: Array):
	for pos in pos_array:
		var area = tile_area_scene.instance()
		area.set_global_position(pos - get_global_position() - Vector2(8, 8))
		add_child(area)


func clear():
	for child in get_children():
		child.queue_free()
