extends Plant
class_name FlowerBase

var pollinazer : WeakRef = null setget set_pollinazer, get_pollinazer

#### ACCESSORS ####

func is_type(type): return type == "Flower" or .is_type(type)
func get_type(): return "Flower"

func set_pollinazer(value: WeakRef): pollinazer = value
func get_pollinazer() -> WeakRef: return pollinazer

#### BUILT-IN ####



#### LOGIC ####



#### INPUTS ####


#### VIRTUALS ####

func get_category() -> String:
	return "Flower"

#### SIGNAL RESPONSES ####
