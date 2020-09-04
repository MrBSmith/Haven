extends AnimalState
class_name GatherState

onready var timer_node = $Timer

#### ACCESSORS ####



#### BUILT-IN ####

func _ready():
	var _err = timer_node.connect("timeout", self, "_on_timer_timeout")

#### LOGIC ####



#### VIRTUALS ####

func enter_state(_previous_state: StateBase):
	timer_node.start()
	
	var flower = animal.get_target()
	flower.set_pollinazer(weakref(animal))


# Try to find a new target right away
func exit_state(_next_state: StateBase):
	var flower = animal.get_target()
	flower.set_pollinazer(null)


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_timer_timeout():
	var target = animal.find_target_in_view()
	if target:
		animal.reach_target(target)
	else:
		states_machine.set_state("Wander")
