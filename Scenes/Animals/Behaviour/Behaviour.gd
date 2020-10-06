extends StatesMachine
class_name Behaviour 

onready var animal = get_parent()

#### ACCESSORS ####



#### BUILT-IN ####

func _ready():
	var _err = connect("state_changed", self, "_on_state_changed")

#### LOGIC ####



#### VIRTUALS ####

func update(_delta: float):
	pass

#### INPUTS ####



#### SIGNAL RESPONSES ####


func _on_state_changed(state_name: String):
	$Label.set_text(state_name)
