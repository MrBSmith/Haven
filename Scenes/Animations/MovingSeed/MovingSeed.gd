extends Node2D

const damping : float = 0.1

var velocity := Vector2.ZERO setget set_velocity, get_velocity
var tree_type : Plant = null setget set_tree_type, get_tree_type

var grid_node : Node2D = null

signal seed_planted(seed_pos, tree_type) 

#### ACCESSORS ####

func set_tree_type(value: Plant):
	tree_type = value

func get_tree_type() -> Plant:
	return tree_type

func set_velocity(value: Vector2):
	velocity = value

func get_velocity() -> Vector2:
	return velocity

#### BUILT-IN ####

func _physics_process(delta):
	velocity -= velocity * damping
	set_global_position(global_position + velocity * delta)
	
	if grid_node.is_pos_outside_grid(get_global_position()):
		queue_free()
	
	if velocity.distance_to(Vector2.ZERO) <= 1:
		emit_signal("seed_planted", global_position, tree_type)
		queue_free()

#### LOGIC ####

#### INPUTS ####

#### SIGNAL RESPONSES ####
