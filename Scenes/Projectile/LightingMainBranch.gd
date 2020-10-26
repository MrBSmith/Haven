extends LightningProjectile
class_name LightningMainBranch

var main_branch : bool = true
var impact_point := Vector2.ZERO

var path : Array = []

#### ACCESSORS ####



#### BUILT-IN ####

func _setup():
	randomize()
	
	nb_strokes = int(rand_range(4, 5))
	compute_individal_values()
	
	$LightingTrail.width = width / 2
	
	motions[0].speed *= Globals.get_tile_upscale().x
	
	new_branch_cooldown = Timer.new()
	var _err = new_branch_cooldown.connect("timeout", self, "_on_new_branch_timeout")
	add_child(new_branch_cooldown)
	
	compute_path()
	position = path[0]
	
	start_new_branch_timer()


func move(delta: float) -> void:
	var speed = motions[0].speed
	var movement : Vector2 = speed * global_position.direction_to(path[0]) * delta
	var projected_pos = global_position + movement

	if global_position.distance_to(projected_pos) >= global_position.distance_to(path[0]):
		global_position = path.pop_front()
		_on_path_point_reached()
	else:
		global_position = projected_pos


#### LOGIC ####


# Take a direction, and invert it
func reverse_direction(dir: Vector2):
	var angle = dir.angle()
	var deg_angle = rad2deg(angle)
	deg_angle = wrapf(deg_angle + 180, 0.0, 360.0)
	angle = deg2rad(deg_angle)
	return Vector2(cos(angle), sin(angle))


# Compute in advance the path of the main branch, so it is determinist
func compute_path():
	var dist = 30 * Globals.get_tile_upscale().x
	var current_point = impact_point
	path.push_front(current_point)
	for i in nb_strokes - 1:
		var dir = compute_rdm_direction(direction, 0.2)
		dir = reverse_direction(dir)
		current_point += dir * dist
		path.push_front(current_point)



#### VIRTUALS ####


#### INPUTS ####


#### SIGNAL RESPONSES ####

func _on_path_point_reached():
	nb_strokes -= 1
	
	if path.empty():
		direction = Vector2.ZERO
		new_branch_cooldown.queue_free()
		set_physics_process(false)
		emit_signal("collided", get_position())
		start_lifetime_timer()

