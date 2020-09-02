extends StateBase
class_name AnimalState

var animal : Animal = null

#### ACCESSORS ####



#### BUILT-IN ####

func _ready():
	yield(owner, "ready")
	animal = owner.animal


#### LOGIC ####



#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
