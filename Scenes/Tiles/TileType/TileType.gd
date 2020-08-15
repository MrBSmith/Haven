extends YSort
class_name TileType

export var growable_plants_array : PoolStringArray

export var growable_min_wetness : int = 33

export var min_grass_nb : int = 0
export var max_grass_nb : int = 6
export var min_flower_nb : int = 0
export var max_flower_nb : int = 0
export var min_tree_nb : int = 0
export var max_tree_nb : int = 5

export var overwet_treshold = 25

var tile = null

#### ACCESSORS ####



#### BUILT-IN ####

func _ready():
	pass

#### LOGIC ####

func get_plant_cat_max(plant_category : String):
	if plant_category == "Tree":
		return max_tree_nb
	elif plant_category == "Grass":
		return max_grass_nb
	elif plant_category == "Flower":
		return max_flower_nb

#### INPUTS ####



#### SIGNAL RESPONSES ####
