extends Plant
class_name TreeBase

export (int, 0, 100) var seed_spawn_chances = 20

signal generate_seed(pos, velocity, tree_type)

var fire_propagation_dist : float = Globals.TILE_SIZE.x * 0.75

#### ACCESSORS ####

func is_type(type): return type == "Tree" or .is_type(type)
func get_type(): return "Tree"

#### BUILT-IN ####

func _ready():
	randomize()
	
	add_to_group("Tree")
	add_to_group("Obstacle")
	
	var _err = $StatesMachine.connect("state_changed", self, "_on_state_changed")
	
	Events.emit_signal("new_tree_grown", self)


#### LOGIC ####

func new_turn():
	.new_turn()
	
	if is_on_fire():
		propagate_fire()


func apply_wind(wind_dir: Vector2, force: int, duration: float):
	var seed_rng = randi() % 100
	$StatesMachine/Wind.start_wind_animation(wind_dir, force, duration)
	
	if seed_rng < seed_spawn_chances:
		var game_upscale = Globals.get_tile_upscale().x
		emit_signal("generate_seed", global_position, wind_dir * force * game_upscale, Resource_Loader.oak)
		
	if is_on_fire():
		propagate_fire(wind_dir)


func propagate_fire(wind_dir := Vector2.ZERO):
	var trees_array : Array = get_tree().get_nodes_in_group("Tree")
	var propag_dist = fire_propagation_dist
	
	if wind_dir != Vector2.ZERO:
		propag_dist = Globals.TILE_SIZE.x * 2
	
	var wind_angle = rad2deg(wind_dir.angle())
	
	for tree in trees_array:
		if tree == self:
			continue
		
		var tree_pos = tree.get_global_position()
		var angle_to_tree = rad2deg(global_position.direction_to(tree_pos).angle())
		
		if global_position.distance_to(tree_pos) <= propag_dist:
			if wind_dir == Vector2.ZERO or is_angle_in_range(angle_to_tree, wind_angle, 45.0):
				tree.set_fire()


# Check if the given angle a1 is a the range of 45deg around the angle a2
func is_angle_in_range(a1: float, a2: float, a_range: float) -> bool:
	return a1 >= a2 - a_range && a1 <= a2 + a_range


#### VIRTUALS ####

func get_category() -> String:
	return "Tree"


func die():
	if is_in_group("Plant"):
	 remove_from_group("Plant")
	
	if is_in_group("Tree"):
		remove_from_group("Tree")
		
	if is_in_group("Obstacle"):
		remove_from_group("Obstacle")
	
	Events.emit_signal("tree_died", self)
	queue_free()


func set_fire(thunder: bool = false):
	.set_fire(thunder)
	var fire = Resource_Loader.fire_fx.instance()
	$FirePosition.add_child(fire)
	on_fire = true


func stop_fire():
	on_fire = false
	var fire_array = $FirePosition.get_children()
	
	for fire in fire_array:
		fire.extinguish()

#### INPUTS ####

func _input(event):
	if event.is_action_pressed("click") && Globals.debug_state == true:
		var mouse_pos = get_global_mouse_position()
		var area_extents = $Area2D/CollisionShape2D.get_shape().get_extents()
		
		if mouse_pos.x >= global_position.x - area_extents.x && mouse_pos.x <= global_position.x + area_extents.x\
		&& mouse_pos.y >= global_position.y - area_extents.y && mouse_pos.y <= global_position.y + area_extents.y:
			set_fire()

#### SIGNAL RESPONSES ####

func _on_state_changed(current_state_name: String):
	if current_state_name == "Idle":
		Events.emit_signal("single_plant_animation_finished")
