extends StateBase

const TYPE : String = ""


#### ACCESSORS ####

func is_class(value : String) -> bool: return value == TYPE or .is_class(value)
func get_class() -> String : return TYPE


#### BUILT-IN ####

func _ready():
	var _err = $Timer.connect("timeout", self, "on_timer_timeout")

#### LOGIC ####



#### VIRTUALS ####

func enter_state(_previous_state):
	owner.propagate_call("on_plant_phase_start")
	$Timer.start()

func exit_state(_next_state):
	pass


#### INPUTS ####



#### SIGNAL RESPONSES ####

func on_timer_timeout():
	owner.set_phase("AnimalBehaviour")
