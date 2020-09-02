extends Animal
class_name Bee

#### ACCESSORS ####

func is_type(type): return type == "Bee" or .is_type(type)
func get_type(): return "Bee"

#### BUILT-IN ####



#### LOGIC ####



#### VIRTUALS ####



#### INPUTS ####

func _input(event):
	if event.is_action_pressed("click"):
		var mouse_pos = get_global_mouse_position()
		move_to(mouse_pos)

#### SIGNAL RESPONSES ####
