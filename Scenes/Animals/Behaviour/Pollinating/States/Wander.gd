extends AnimalState
class_name WanderState

onready var timer_node = $Timer

var wander_area_center := Vector2.ZERO

#### ACCESSORS ####



#### BUILT-IN ####

func _ready():
	randomize()
	
	var _err = timer_node.connect("timeout", self, "_on_timer_timeout")


#### LOGIC ####

# Return a destination within the radius defined by the animal wander distance
func find_new_destination(fix_radius: bool = false) -> Vector2:
	var dest = Vector2(-1.0, -1.0)
	var grid_node = get_tree().get_current_scene().find_node("Grid")
	
	while(grid_node.is_pos_outside_grid(dest)):
		var rdm_deg_angle = rand_range(0.0, 360.0)
		var rad_angle = deg2rad(rdm_deg_angle)
		
		var dir = Vector2(cos(rad_angle), sin(rad_angle))
		var rdm_dist = rand_range(animal.wander_distance / 3, animal.wander_distance)
		
		var area_center = wander_area_center if fix_radius else animal.global_position
		
		dest = area_center + dir * rdm_dist
	
	return dest


# Search a target in the view field, and returns it
func find_target_in_view() -> PhysicsBody2D:
	var view_area = animal.get_node("Area2D")
	var bodies_in_view = view_area.get_overlapping_bodies()
	
	for body in bodies_in_view:
		for type in animal.eatable_types:
			if body.is_type(type):
				return body
	
	return null


#### VIRTUALS ####

func enter_state(_previous_state: StateBase):
	timer_node.start()


func exit_state(_next_state: StateBase):
	timer_node.stop()


func update(delta: float):
	if animal.move_path.empty():
		animal.set_move_path([find_new_destination(animal.standby)])
	
	animal.move(delta, 0.5)
	if animal.move_path.size() == 0:
		var tar = find_target_in_view()
		
		if tar == null:
			animal.set_move_path([find_new_destination(animal.standby)])
		else:
			animal.reach_target(tar)


#### INPUTS ####



#### SIGNAL RESPONSES ####


func _on_timer_timeout():
	var target = find_target_in_view()
	if target:
		animal.reach_target(target)
