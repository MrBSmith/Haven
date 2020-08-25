extends StateBase

#### ~~ TREE WIND STATE ~~ ####

onready var tween_node = $Tween
onready var wind_anim_timer_node = $WindAnimTimer

var wind_direction := Vector2.ZERO
var wind_force : float = 0

#### ACCESSORS ####

#### BUILT-IN ####

func _ready():
	var _err = tween_node.connect("tween_all_completed", self, "_on_bourasque_anim_finished")
	_err = wind_anim_timer_node.connect("timeout", self, "_on_wind_anim_timer_timeout")


#### LOGIC ####

# Start the wind animation process
func start_wind_animation(wind_dir: Vector2, force: float, _variance: float = 70, duration: float = 3.0):
	states_machine.set_state(self)
	wind_direction = wind_dir
	wind_force = force

	wind_anim_timer_node.start(duration)
	
	bourasque_animation(wind_dir, force)


# Animate one bourasque, based on the wind direction and its force
func bourasque_animation(wind_dir := Vector2.ZERO, force: float = 0.0, variance: float = 40):
	force = apply_variance(force, variance)
	
	var anim_duration : float = 0.4
	if force != 0.0:
		anim_duration = 10 / clamp(force, 1.0, INF)
	
	anim_duration = apply_variance(anim_duration, variance)
	
	var rotation_sign = sign(wind_dir.x)
	var rotation_amount = ((force / 3) * rotation_sign) - 90
	var foliage = owner.get_node("Skeleton2D/Foliage")
	
	tween_node.interpolate_property(foliage, "rotation_degrees",
		foliage.get_rotation_degrees(), rotation_amount, 
		anim_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween_node.start()


# Take a given value and a given variance percentage, 
# return the value with between 0 and variance percent (or -variance) beeing added
func apply_variance(value: float, variance: float) -> float:
	return value + int(value * (rand_range(-variance, variance) / 100))

#### VIRTUALS ####

func exit_state(_next_state: StateBase):
	wind_direction = Vector2.ZERO
	wind_force = 0.0


#### INPUTS ####

#### SIGNAL RESPONSES ####

# When a bourasque finish, if the wind isn't over, launch another one
func _on_bourasque_anim_finished():
	if states_machine.get_state() == self:
		bourasque_animation(wind_direction, wind_force)

# Triggers the end of the wind
func _on_wind_anim_timer_timeout():
	states_machine.set_state("Idle")
	bourasque_animation(Vector2.ZERO)
