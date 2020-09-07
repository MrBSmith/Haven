extends AnimalState
class_name GatherState

onready var timer_node = Timer.new()

#### ACCESSORS ####



#### BUILT-IN ####

func _ready():
	add_child(timer_node)
	
	var _err = timer_node.connect("timeout", self, "_on_timer_timeout")

#### LOGIC ####



#### VIRTUALS ####

func enter_state(_previous_state: StateBase):
	timer_node.start(animal.eating_time)
	
	var target = animal.get_target()
	
	if target is FlowerBase && states_machine is Pollinating:
		target.set_pollinazer(weakref(animal))
	else:
		target.set_eater(weakref(animal))


# Try to find a new target right away
func exit_state(_next_state: StateBase):
	var target = animal.get_target()
	
	if target is FlowerBase && states_machine is Pollinating:
		target.set_pollinazer(null)
	else:
		target.ate()


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_timer_timeout():
	var target = animal.find_target_in_view()
	if target:
		animal.reach_target(target)
	else:
		states_machine.set_state("Wander")
