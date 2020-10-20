extends StateBase

#### ACCESSORS ####



#### BUILT-IN ####



#### LOGIC ####



#### VIRTUALS ####

func enter_state(_previous_state):
	owner.propagate_call("meteo_animation_started")


func exit_state(_next_state):
	owner.propagate_call("set_standby", [false])
	owner.propagate_call("on_animal_phase_start", [], true)


#### INPUTS ####



#### SIGNAL RESPONSES ####
