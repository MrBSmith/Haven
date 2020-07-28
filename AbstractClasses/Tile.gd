extends Node
class_name Tile

var grid_position : Vector2 setget set_grid_position, get_grid_position


#### ACCESSORS ####

func set_grid_position(value: Vector2):
	grid_position = value

func get_grid_position() -> Vector2:
	return grid_position
