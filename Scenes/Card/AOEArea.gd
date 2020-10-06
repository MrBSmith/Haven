extends Node2D
class_name AOE_area

var tile_area_scene = preload("res://Scenes/TileArea/TileArea.tscn")

func _ready():
	pass


func create_area(tile_array: Array):
	for tile in tile_array:
		var area = tile_area_scene.instance()
		var area_container_pos = get_global_position()
		area.set_global_position(tile.get_global_position() - area_container_pos - Globals.TILE_SIZE / 2)
		add_child(area)


func clear():
	for child in get_children():
		child.queue_free()


func set_area_active():
	for child in get_children():
		var transparent_red = Color.red
		transparent_red.a = 0.5
		child.set_frame_color(transparent_red)
