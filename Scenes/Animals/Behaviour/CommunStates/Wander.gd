extends AnimalState
class_name WanderState

onready var timer_node = Timer.new()
export var wait_time : float = 0.2 

var is_waiting : bool = true

#### ACCESSORS ####



#### BUILT-IN ####

func _ready():
	randomize()
	
	add_child(timer_node)
	timer_node.set_wait_time(wait_time)
	timer_node.set_one_shot(true)
	var _err = timer_node.connect("timeout", self, "_on_timer_timeout")
	
	yield(owner, "ready")
	_err = animal.connect("standby_changed", self, "on_standby_changed")


#### LOGIC ####

# Return a destination within the radius defined by the animal wander distance
func find_new_destination(fix_radius: bool = false) -> Vector2:
	var dest = Vector2(-1.0, -1.0)
	var grid_node = get_tree().get_current_scene().find_node("Grid")
	var wander_dist_pixels = animal.get_wander_distance() * Globals.TILE_SIZE.x
	
	if grid_node == null:
		return Vector2.ZERO
	
	while(grid_node.is_pos_outside_grid(dest)):
		var rdm_deg_angle = rand_range(0.0, 360.0)
		var rad_angle = deg2rad(rdm_deg_angle)
		
		var dir = Vector2(cos(rad_angle), sin(rad_angle))
		var rdm_dist = rand_range(wander_dist_pixels / 3, wander_dist_pixels)
		
		var area_center = animal.get_wander_area_center() if fix_radius else animal.global_position
		
		dest = area_center + dir * rdm_dist
	return dest


# Find a new target or wander destination
func search_new_destination():
	var tar = null
	if animal.get_standby():
		animal.set_move_path([find_new_destination(true)])
	else:
		tar = animal.find_target_in_view()
		if tar != null:
			animal.reach_for_target(tar)


#### VIRTUALS ####

func enter_state(_previous_state: StateBase):
	timer_node.start()


func exit_state(_next_state: StateBase):
	timer_node.stop()


func update(delta: float):
	var path = animal.path
	
	if path.empty() && !is_waiting:
		on_animal_arrived()
	
	animal.move(delta, 0.5)



#### INPUTS ####



#### SIGNAL RESPONSES ####


func _on_timer_timeout():
	if states_machine.get_state() != self:
		return
	
	is_waiting = false
	search_new_destination()

# Called when an animal is arrived to destination
# Either find a target, or a new destination
func on_animal_arrived():
	timer_node.start()
	is_waiting = true


# When the standby of the animal change, update the wait timer
func on_standby_changed(standby : bool):
	if standby:
		timer_node.set_wait_time(wait_time * 5)
	else:
		timer_node.set_wait_time(wait_time)
