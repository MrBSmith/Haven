extends WanderState
class_name QueueingState

#### ACCESSORS ####



#### BUILT-IN ####



#### LOGIC ####


func on_animal_arrived():
	var flower = animal.get_target()
	
	if flower == null:
		states_machine.set_state("Wander")
		return
	
	if flower.get_pollinazer() == null or flower.get_pollinazer().get_ref() == null:
		animal.reach_for_target(flower)
	else:
		animal.set_move_path([find_new_destination(true)])

#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_timer_timeout():
	pass
