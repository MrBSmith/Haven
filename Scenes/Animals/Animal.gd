extends KinematicBody2D
class_name Animal

var is_ready : bool = false

export var speed : float = 1.0 setget set_speed, get_speed
export var wander_distance : float = 32.0 setget set_wander_distance, get_wander_distance

export var eatable_types : PoolStringArray = []
export var view_radius : float = 12.0

export var eating_time : float = 3.0

export var avarage_presence_time : float = 40.0

export var appearing_conditions : Array = []
export var appearing_cond_radius : int = 2
export (float, 0.0, 100.0, 0.0) var appearing_probability : float = 0.0

export var standby : bool = false setget set_standby, get_standby
var target : PhysicsBody2D = null setget set_target, get_target
var path : PoolVector2Array

var visited_targets : Array = []
var wander_area_center := Vector2.ZERO setget set_wander_area_center, get_wander_area_center

onready var path_curve = Curve2D.new()
onready var behaviour : StatesMachine = find_behaviour()

#### ACCESSORS ####

func is_type(type): return type == "Animal"
func get_type(): return "Animal"

func set_speed(value: float): speed = value
func get_speed() -> float: return speed

func set_wander_distance(value: float): wander_distance = value
func get_wander_distance() -> float: return wander_distance

func set_state(value: String): behaviour.set_state(value)
func get_state_name() -> String: return behaviour.get_state_name()

func set_standby(value: bool): 
	standby = value
	if standby:
		if !is_ready:
			yield(self, "ready")
		
		set_wander_area_center(get_global_position())

func get_standby() -> bool: return standby

func set_wander_area_center(value: Vector2): wander_area_center = value
func get_wander_area_center() -> Vector2: return wander_area_center

func set_target(value: PhysicsBody2D):
	if target is FlowerBase:
		if target.get_pollinazer() != null && target.get_pollinazer().get_ref() == self:
			target.set_pollinazer(null)
	target = value

func get_target() -> PhysicsBody2D:
	return target

#### BUILT-IN ####

func _ready():
	randomize()
	
	path_curve.set_bake_interval(0.7)
	
	var shape = $Area2D/CollisionShape2D.get_shape()
	shape.set_radius(view_radius)
	
	var _err = $PresenceTimer.connect("timeout", self, "on_presence_timer_timeout")
	trigger_presence_timer()
	
	is_ready = true

#### LOGIC ####

# Set the move path (Straight line to the target)
func set_move_path(path_point_array: Array):
	path_curve.clear_points()
	path_curve.add_point(global_position)
	
	for point in path_point_array:
		var last_point = path_curve.get_baked_points()[0]
		
		if point == last_point:
			continue
			
		path_curve.add_point(point)
	
	path = path_curve.get_baked_points()


# Give this animal the order to move toward the given position
func move_to(pos: Vector2):
	set_move_path([pos])
	set_state("MoveTo")


# Give this animal the order to rech for the given target
func reach_for_target(tar: PhysicsBody2D):
	set_target(tar)
	if tar == null:
		return
	
	move_to(tar.get_global_position())


# Give this animal the order to eat
func eat():
	if behaviour is Pollinating:
		visited_targets.append(target)
		if visited_targets.size() > 5:
			visited_targets.remove(0)
	
	if behaviour is Pollinating:
		set_state("Gather")
	elif behaviour is Herbivore:
		set_state("Eating")


# Give this animal the order to go away from the board
func go_away():
	set_state("Wander")


# Move along the path
func move(delta: float, speed_modifier: float = 1.0):
	if path.empty():
		return
	
	var dir = global_position.direction_to(path[0])
	var future_dest = global_position + dir * speed * speed_modifier * delta
	
	if future_dest.distance_to(path[0]) < speed:
		global_position = path[0]
		path.remove(0)
	else:
		var _col = move_and_collide(dir * speed)


# Find the behaviour amoung the children nodes
func find_behaviour() -> Behaviour:
	for child in get_children():
		if child is Behaviour:
			return child
	return null


# Search a target in the view field, and returns it
func find_target_in_view() -> PhysicsBody2D:
	var view_area = get_node("Area2D")
	var bodies_in_view = view_area.get_overlapping_bodies()
	
	for body in bodies_in_view:
		for type in eatable_types:
			if body.is_type(type) && not body in visited_targets:
				return body
	return null


# Throw a random number to now if this animal can appear or not (If the conditions are met)
func can_appear() -> bool:
	var rng = rand_range(0.0, 100.0)
	return rng <= appearing_probability


# Find an appearing tile, and returns it. Return null if nothing was found
func find_appearing_tile(grid_node: Node) -> Tile:
	var tile_array = grid_node.get_tile_array()
	tile_array.shuffle()
	
	for tile in tile_array:
		if !is_tile_passable(tile):
			continue
		
		var grid_pos = tile.get_grid_position()
		var tile_area = grid_node.get_tiles_in_radius(grid_pos, appearing_cond_radius)
		if is_area_favorable(tile_area):
			return tile
	return null


# Return true if the given tile is passable for this animal, false if not
func is_tile_passable(tile: Tile) -> bool:
	var tile_type = tile.get_tile_type()
	if self.is_type("TerrestrialAnimal"):
		return tile_type is DryTile
		
	elif self.is_type("SwimingAnimal"):
		return tile_type is WetTile
		
	return true


# Check if an area is favorable for this animal to appear
func is_area_favorable(tile_array: Array) -> bool:
	for cond in appearing_conditions:
		if !is_appear_condition_verified(tile_array, cond):
			return false
	return true


# Check if a condition for appearing is verified
func is_appear_condition_verified(tile_array: Array, condition: AppearCondition) -> bool:
	var entity_type = condition.entity_type
	var entity_number = condition.entity_number
	var nb : int = 0
	for tile in tile_array:
		for plant in tile.get_all_plants():
			if plant.is_type(entity_type):
				nb += 1
				if nb >= entity_number:
					return true
	return false


# Trigger the timer which determine when the animal wants to leave the board
func trigger_presence_timer():
	if avarage_presence_time <= 0:
		return
	
	var rdm_sign = randi() % 2 * 2 -1
	var variance = (avarage_presence_time * rand_range(0.1, 20.0) / 100) * rdm_sign
	var presence_time = avarage_presence_time + variance
	$PresenceTimer.start(presence_time)


#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func on_presence_timer_timeout():
	queue_free()
