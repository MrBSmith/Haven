extends StateBase

var area_node : Node2D
var combined : bool = false

func _ready():
	area_node = owner.get_node("Area")
	var _err = Events.connect("meteo_animation_finished", self, "_on_meteo_animation_finished")


func enter_state(_previous_state: StateBase):
	area_node.clear()


func exit_state(_next_state: StateBase):
	pass


func _on_meteo_animation_finished():
	var current_state_name = states_machine.get_state().name
	var self_name = name
	if current_state_name == self_name:
		states_machine.set_state("Destroy")
