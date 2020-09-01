extends Node2D

const TRANSITION_TIME : float = 1.5

onready var tween_node = $Tween
onready var cloud_shader = $CloudShader.get_material()
onready var shadow_shader = $ShadowsShader.get_material()

onready var first_threshold_default = cloud_shader.get_shader_param("first_threshold")
onready var sec_threshold_default = cloud_shader.get_shader_param("second_threshold")
onready var opacity_default = cloud_shader.get_shader_param("opacity")
onready var first_color_default = cloud_shader.get_shader_param("first_color")
onready var sec_color_default = cloud_shader.get_shader_param("second_color")

signal meteo_effect_ready


#### ACCESSORS ####



#### BUILT-IN ####

func _ready():
	var _err = $Timer.connect("timeout", self, "_on_timer_timeout")


#### LOGIC ####

func meteo_effect(opacity: float, first_thres: float, sec_thres: float,\
 first_color: Color = first_color_default , sec_color: Color = sec_color_default):
	
	tween_node.interpolate_property(cloud_shader, "shader_param/opacity",
		opacity_default, opacity, TRANSITION_TIME,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween_node.interpolate_property(shadow_shader, "shader_param/first_threshold",
		first_threshold_default, first_thres, TRANSITION_TIME,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween_node.interpolate_property(cloud_shader, "shader_param/first_threshold",
		first_threshold_default, first_thres, TRANSITION_TIME,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween_node.interpolate_property(cloud_shader, "shader_param/second_threshold",
		sec_threshold_default, sec_thres, TRANSITION_TIME,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween_node.interpolate_property(cloud_shader, "shader_param/first_color",
		first_color_default, first_color, TRANSITION_TIME,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween_node.interpolate_property(cloud_shader, "shader_param/second_color",
		sec_color_default, sec_color, TRANSITION_TIME,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween_node.start()
	
	yield(tween_node, "tween_all_completed")
	emit_signal("meteo_effect_ready")
	$Timer.start()



func reset_to_default():
	tween_node.interpolate_property(shadow_shader, "shader_param/first_threshold",
		shadow_shader.get_shader_param("first_threshold"), first_threshold_default, TRANSITION_TIME,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween_node.interpolate_property(cloud_shader, "shader_param/opacity",
		cloud_shader.get_shader_param("opacity"), opacity_default, TRANSITION_TIME,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween_node.interpolate_property(cloud_shader, "shader_param/second_threshold",
		cloud_shader.get_shader_param("second_threshold"), sec_threshold_default, TRANSITION_TIME,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween_node.interpolate_property(cloud_shader, "shader_param/first_threshold",
		cloud_shader.get_shader_param("first_threshold"), first_threshold_default, TRANSITION_TIME,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween_node.interpolate_property(cloud_shader, "shader_param/second_color",
		cloud_shader.get_shader_param("second_color"), sec_color_default, TRANSITION_TIME,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween_node.start()


#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_timer_timeout():
	reset_to_default()
