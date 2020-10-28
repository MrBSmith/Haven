extends StateBase

#### ACCESSORS ####



#### BUILT-IN ####

func _ready():
	var _err = $Timer.connect("timeout", self, "_on_timer_timeout")

#### LOGIC ####



#### VIRTUALS ####

func enter_state(_previous_state):
	$Timer.start()
	owner.propagate_call("set_standby", [false])
	owner.propagate_call("on_animal_phase_start", [], true)


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_timer_timeout():
	owner.set_phase("AnimalLeaving")
