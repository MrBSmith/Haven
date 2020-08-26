extends MeteoAnimation
class_name RainAnimation

const rain_particule_scene = preload("res://Scenes/Animations/Meteo/Rain/RainParticule.tscn")
var tiles_affected : Array

#### ACCESSORS ####



#### BUILT-IN ####

func _init(tiles_array: Array, durat : float = 3.0):
	duration = durat
	tiles_affected = tiles_array


func _ready():
	for tile in tiles_affected:
		var pos = tile.get_global_position()
		var particule = rain_particule_scene.instance()
		particule.set_position(pos - Vector2(0, 50))
		particule.connect("tree_exited", self, "_on_effect_tree_exited")
		add_child(particule)

#### LOGIC ####



#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
