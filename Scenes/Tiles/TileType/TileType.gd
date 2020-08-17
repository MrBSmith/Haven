extends YSort
class_name TileType

export var growable_plants_array : PoolStringArray

export var min_grass_nb : int = 0
export var max_grass_nb : int = 6
export var min_flower_nb : int = 0
export var max_flower_nb : int = 0
export var min_tree_nb : int = 0
export var max_tree_nb : int = 5

export var dry_threshold : int =  0
export var wet_threshold : int =  100
export var growable_min_wetness : int = 33

export var more_dry_tile_type : String = ""
export var more_wet_tile_type : String = ""

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

# Called when the tile is at its min wetness of its type (ie should change type)
func on_min_wetness_reached():
	pass

# Called when the tile is at its max wetness of its type (ie should change type)
func on_max_wetness_reached():
	pass

func on_wind_applied(_wind_dir: Vector2, _wind_force: int):
	pass
