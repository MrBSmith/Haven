extends TargetCardState

#### ACCESSORS ####


#### BUILT-IN ####


#### VIRTUALS ####

func enter_state(previous_state: StateBase):
	.enter_state(previous_state) # Call the parent enter_state
	$Arrow.set_visible(true)
	

func exit_state(next_state: StateBase):
	.exit_state(next_state) # Call the parent exit_state
	$Arrow.set_visible(false)

#### LOGIC ####


#### INPUTS ####


#### SIGNAL RESPONSES ####
