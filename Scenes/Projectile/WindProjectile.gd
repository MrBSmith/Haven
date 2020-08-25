extends MultiplePhaseProjectile
class_name WindProjectile

var wind_force : float = 100.0

var circle_motion = preload("res://Scenes/Motion/CircleMotion.tres")
var line_motion = preload("res://Scenes/Motion/LineMotion.tres")
var sine_motion = preload("res://Scenes/Motion/SineMotion.tres")


#### ACCESSORS ####

func _setup():
	randomize()
	randomize_wind_trail()
	
	._setup()


#### BUILT-IN ####


#### LOGIC ####

func randomize_wind_trail():
	$Line2D.width = rand_range(0.4, 0.8)
	$Line2D.trail_max_lenght = int(rand_range(18.0, 30.0))
	
	var line = line_motion.duplicate()
	var sine = sine_motion.duplicate()
	
	# Random speed, frequency and amplitude
	var speed = rand_range(90.0, 130.0)
	line.speed = speed
	sine.frequency = rand_range(3.5, 7.0)
	sine.amplitude = rand_range(3.5, 7.0)
	
	movement_phases = [[line, sine], []]
	
	# Random sine duration
	phases_durations.append(rand_range(0.6, 0.7))
	
	# Randomly decide if there should be an orbit movement at the end
	# If so, randomly set its size and duration
	if randi() % 4 == 0:
		var circle = circle_motion.duplicate()
		circle.radius = rand_range(0.7, 1.2)
		circle.speed = speed / 7
		if direction == Vector2.LEFT:
			circle.clockwise = false
		
		movement_phases[1].append(circle)
		phases_durations.push_back(rand_range(0.2, 0.7))
	
	pass


func get_current_trail_angle() -> float:
	var trail = $Line2D
	var trails_points = trail.get_points()
	
	var last_point = trails_points[-1]
	var previous_point = trails_points[-2]
	
	return previous_point.angle_to(last_point)

#### VIRTUALS ####


#### INPUTS ####


#### SIGNAL RESPONSES ####

func _on_motion_phase_finished():
	movement_phases.remove(0)
	phases_durations.remove(0)
	
	if movement_phases.empty() or movement_phases[0] == null:
		emit_signal("every_movement_finished")
	elif !movement_phases[0].empty():
		var current_angle = get_current_trail_angle()
		movement_phases[0][0].angle = current_angle
		start_movement_phase()
