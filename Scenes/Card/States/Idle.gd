extends StateBase

#### IDLE STATE ####

func _ready():
	pass


func enter_state():
	owner.set_position(owner.get_default_position())
