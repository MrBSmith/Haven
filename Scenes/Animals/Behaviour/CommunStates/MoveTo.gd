extends AnimalState
class_name MoveToState

#### ACCESSORS ####



#### BUILT-IN ####



#### LOGIC ####



#### VIRTUALS ####


func update(delta: float):
	animal.move(delta)
	
	# Check if the target flower is already beeing pollinating
	var target = animal.get_target()
	
	if target != null:
		if target is FlowerBase && states_machine is Pollinating:
			var current_pollinazer = target.get_pollinazer()
			
			if current_pollinazer != null && current_pollinazer.get_ref() != null:
				return "Queueing"
	
	# Check if the path is empty (ie if the animal is arrived to destination)
	if animal.path.empty():
		if target is Plant:
			animal.eat()
		else:
			#return "Kill"
			pass


func enter_state(_previous_state):
	pass


func exit_state(_next_state):
	pass

#### INPUTS ####



#### SIGNAL RESPONSES ####
