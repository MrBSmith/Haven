extends StateBase

#### ACCESSORS ####



#### BUILT-IN ####



#### LOGIC ####



#### VIRTUALS ####

func enter_state(_previous_state):
	owner.hand_node.draw()
	owner.propagate_call("on_new_turn_started")
	owner.propagate_call("set_standby", [true])


#### INPUTS ####



#### SIGNAL RESPONSES ####
