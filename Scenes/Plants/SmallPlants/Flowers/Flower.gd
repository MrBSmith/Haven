extends Plant
class_name FlowerBase

var pollinazer : WeakRef = null setget set_pollinazer, get_pollinazer

#### ACCESSORS ####

func is_class(type): return type == "Flower" or .is_class(type)
func get_class(): return "Flower"

func set_pollinazer(value: WeakRef): pollinazer = value
func get_pollinazer() -> WeakRef: return pollinazer

#### BUILT-IN ####

func _ready():
	var _err = connect("is_being_ate", self, "_on_is_being_ate")

#### LOGIC ####


#### INPUTS ####


#### VIRTUALS ####

func get_category() -> String:
	return "Flower"

#### SIGNAL RESPONSES ####

func _on_is_being_ate():
	if pollinazer == null:
		return
	
	var pol = pollinazer.get_ref()
	if pol != null:
		pol.go_away()
