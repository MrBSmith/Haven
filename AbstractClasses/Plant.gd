extends Node2D
class_name Plant

onready var tile_node = get_parent()

export var min_sibling_dist : float = 2.0 setget set_min_sibling_dist, get_min_sibling_dist

var current_tile_weakref : WeakRef = null

#### ACCESSORS ####

func set_min_sibling_dist(value: float):
	min_sibling_dist = value

func get_min_sibling_dist() -> float:
	return min_sibling_dist

#### BUILT-IN ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
