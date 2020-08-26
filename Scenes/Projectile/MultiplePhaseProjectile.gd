extends Projectile
class_name MultiplePhaseProjectile

# Basic class from projectile that have multiples movement phases

# movement_phases should contains arrays that contains the motions, each array representing a phase
# phases_durations contain the duration of each phase

# When a phase is over, the code removes it and triggers the next on
# When the last phase is over, triggers the lifetime timer

export var movement_phases : Array = []
export var phases_durations : PoolRealArray = []

var phase_timer : Timer = null

signal every_movement_finished

#### ACCESSORS ####


#### BUILT-IN ####

func _setup():
	if movement_phases.empty():
		return
	
	phase_timer = Timer.new()
	phase_timer.set_one_shot(true)
	add_child(phase_timer)
	
	var _err = phase_timer.connect("timeout", self, "_on_motion_phase_finished")
	_err = connect("every_movement_finished", self, "_on_every_movement_finished")
	start_movement_phase()


#### LOGIC ####

func start_movement_phase():
	if movement_phases.empty() or movement_phases[0] == null \
	or phases_durations.empty() or phases_durations[0] == 0.0 :
		return
	
	phase_timer.start(phases_durations[0])

#### VIRTUALS ####

func _update_movement(delta: float) -> Vector2:
	var movement_vector := Vector2.ZERO
	
	if movement_phases.empty() or movement_phases[0] == null:
		return movement_vector
	
	for motion in movement_phases[0]:
		movement_vector += motion.update_movement(direction, delta)
	
	return movement_vector


#### INPUTS ####


#### SIGNAL RESPONSES ####

func _on_motion_phase_finished():
	movement_phases.remove(0)
	phases_durations.remove(0)
	
	if movement_phases.empty() or movement_phases[0] == null\
	or phases_durations.empty() or phases_durations[0] == null:
		emit_signal("every_movement_finished")
	else:
		start_movement_phase()


func _on_every_movement_finished():
	start_lifetime_timer()
