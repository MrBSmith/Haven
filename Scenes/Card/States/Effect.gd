extends StateBase

var area_node : Node2D

func _ready():
	var _err = $Timer.connect("timeout", self, "_on_timer_timeout")
	
	yield(owner, "ready")
	area_node = owner.get_node("Area")


func enter_state(_previous_state: StateBase):
	area_node.set_area_active()
	$Timer.start()


func _on_timer_timeout():
	states_machine.set_state("Destroy")
