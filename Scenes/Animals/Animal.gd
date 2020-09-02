extends KinematicBody2D
class_name Animal

export var speed : float = 1.0 setget set_speed, get_speed
export var wander_distance : float = 32.0 setget set_wander_distance, get_wander_distance

export var eatable_types : PoolStringArray = []
export var view_radius : float = 20.0
var move_path : PoolVector2Array = [] setget set_move_path, get_move_path

onready var behaviour : StatesMachine = find_behaviour()

var standby : bool = false setget set_standby, get_standby
var target : PhysicsBody2D = null setget set_target, get_target

#### ACCESSORS ####

func is_type(type): return type == "Animal" or .is_type(type)
func get_type(): return "Animal"

func set_speed(value: float):
	speed = value

func get_speed() -> float:
	return speed

func set_move_path(value: PoolVector2Array):
	move_path = value

func get_move_path() -> PoolVector2Array:
	return move_path

func set_wander_distance(value: float):
	wander_distance = value

func get_wander_distance() -> float:
	return wander_distance

func set_state(value: String):
	behaviour.set_state(value)

func get_state_name() -> String:
	return behaviour.get_state_name()

func set_standby(value: bool):
	standby = value

func get_standby() -> bool:
	return standby

func set_target(value: PhysicsBody2D):
	target = value

func get_target() -> PhysicsBody2D:
	return target

#### BUILT-IN ####

func _ready():
	var shape = $Area2D/CollisionShape2D.get_shape()
	shape.set_radius(view_radius)



#### LOGIC ####

# Give this animal the order to move toward the given position
func move_to(pos: Vector2):
	set_move_path([pos])
	set_state("MoveTo")


func reach_target(tar: PhysicsBody2D):
	if tar == null:
		return
	
	set_target(tar)
	move_to(tar.get_global_position())


func gather(_plant: Plant):
	set_state("Gather")


# Move along the path
func move(delta: float, speed_modifier: float = 1.0):
	var dir = global_position.direction_to(move_path[0])
	var future_dest = global_position + dir * speed * speed_modifier * delta
	
	if future_dest.distance_to(move_path[0]) < 1.0:
		global_position = move_path[0]
		move_path.remove(0)
	else:
		var _col = move_and_collide(dir * speed)


# Find the behaviour amoung the children nodes
func find_behaviour() -> Behaviour:
	for child in get_children():
		if child is Behaviour:
			return child
	
	return null


#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
