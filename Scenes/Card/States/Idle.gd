extends StateBase

#### IDLE STATE ####

func _ready():
	pass


func enter_state(_previous_state: StateBase):
	owner.set_position(owner.get_default_position())

func exit_state(_next_state: StateBase):
	pass
