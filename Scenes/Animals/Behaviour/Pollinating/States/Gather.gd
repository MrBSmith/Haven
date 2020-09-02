extends StateBase
class_name GatherState

onready var timer_node = $Timer

#### ACCESSORS ####



#### BUILT-IN ####

func _ready():
	var _err = timer_node.connect("timeout", self, "_on_timer_timeout")

#### LOGIC ####



#### VIRTUALS ####

func enter_state(_previous_state: StateBase):
	timer_node.start()

#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_timer_timeout():
	states_machine.set_state("Wander")
