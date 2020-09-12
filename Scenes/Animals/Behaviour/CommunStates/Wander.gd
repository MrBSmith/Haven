extends AnimalState
class_name WanderState

onready var timer_node = Timer.new()

export var wait_time : float = 0.2 
var wander_area_center := Vector2.ZERO

#### ACCESSORS ####



#### BUILT-IN ####

func _ready():
	randomize()
	
	add_child(timer_node)
	timer_node.set_wait_time(wait_time)
	var _err = timer_node.connect("timeout", self, "_on_timer_timeout")


#### LOGIC ####

# Return a destination within the radius defined by the animal wander distance
func find_new_destination(fix_radius: bool = false) -> Vector2:
	var dest = Vector2(-1.0, -1.0)
	var grid_node = get_tree().get_current_scene().find_node("Grid")
	
	if grid_node == null:
		return Vector2.ZERO
	
	while(grid_node.is_pos_outside_grid(dest)):
		var rdm_deg_angle = rand_range(0.0, 360.0)
		var rad_angle = deg2rad(rdm_deg_angle)
		
		var dir = Vector2(cos(rad_angle), sin(rad_angle))
		var rdm_dist = rand_range(animal.wander_distance / 3, animal.wander_distance)
		
		var area_center = wander_area_center if fix_radius else animal.global_position
		
		dest = area_center + dir * rdm_dist
	
	return dest


func on_animal_arrived():
	var tar = animal.find_target_in_view()
	
	if tar == null:
		animal.set_move_path([find_new_destination(animal.standby)])
	else:
		animal.reach_for_target(tar)


#### VIRTUALS ####

func enter_state(_previous_state: StateBase):
	timer_node.start()


func exit_state(_next_state: StateBase):
	timer_node.stop()


func update(delta: float):
	var path = animal.path
	
	if path.empty():
		animal.set_move_path([find_new_destination(animal.standby)])
	
	animal.move(delta, 0.5)
	if path.size() == 0:
		on_animal_arrived()


#### INPUTS ####



#### SIGNAL RESPONSES ####


func _on_timer_timeout():
	if states_machine.get_state() != self:
		return
	
	var target = animal.find_target_in_view()
	if target:
		animal.reach_for_target(target)
