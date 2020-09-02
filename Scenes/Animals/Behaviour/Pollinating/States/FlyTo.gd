extends StateBase
class_name MoveToState

#### ACCESSORS ####



#### BUILT-IN ####



#### LOGIC ####



#### VIRTUALS ####


func update(delta: float):
	var animal = owner.animal
	
	animal.move(delta)
	if animal.move_path.size() == 0:
		if animal.get_target() is Plant:
			return "Gather"
		else:
			return "Kill"


func enter_state(_previous_state):
	pass


func exit_state(_next_state):
	pass

#### INPUTS ####



#### SIGNAL RESPONSES ####
