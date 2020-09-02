extends Plant
class_name FlowerBase

#### ACCESSORS ####

func is_type(type): return type == "Flower" or .is_type(type)
func get_type(): return "Flower"

#### BUILT-IN ####



#### LOGIC ####



#### INPUTS ####


#### VIRTUALS ####

func get_category() -> String:
	return "Flower"

#### SIGNAL RESPONSES ####
