extends Node2D

#### ACCESSORS ####



#### BUILT-IN ####



#### LOGIC ####

func extinguish():
	var particule_node = $Particles2D
	
	particule_node.set_emitting(false)
	$Timer.start(particule_node.get_lifetime())
	
	yield($Timer, "timeout")
	queue_free()

#### VIRTUALS ####


#### INPUTS ####



#### SIGNAL RESPONSES ####
