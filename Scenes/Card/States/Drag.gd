extends StateBase

#### DRAG STATE ####

func update(_delta: float):
	var mouse_pos = owner.get_global_mouse_position()
	owner.set_global_position(mouse_pos)
