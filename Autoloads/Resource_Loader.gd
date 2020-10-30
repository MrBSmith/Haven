extends Node

const TYPE : String = ""

const tile = preload("res://Scenes/Tiles/Tile.tscn")

var tiles_type = {
	"Swamp" : preload("res://Scenes/Tiles/TileType/WetTiles/Swamp/SwampTile.tscn"),
	"Soil" : preload("res://Scenes/Tiles/TileType/DryTiles/Soil/SoilTile.tscn"),
	"Water" : preload("res://Scenes/Tiles/TileType/WetTiles/Water/WaterTile.tscn"),
	"Grass" : preload("res://Scenes/Tiles/TileType/DryTiles/Grass/GrassTile.tscn"),
	"Sand" : preload("res://Scenes/Tiles/TileType/DryTiles/Sand/SandTile.tscn")
}

var oak = preload("res://Scenes/Plants/Trees/Oak/Oak.tscn").instance()
const grass = preload("res://Scenes/Plants/SmallPlants/Grass.tscn")
const blue_flower = preload("res://Scenes/Plants/SmallPlants/Flowers/BlueFlower/BlueFlower.tscn")
const red_flower = preload("res://Scenes/Plants/SmallPlants/Flowers/RedFlower/RedFlower.tscn")

var tree_types = [oak]
var flower_types = [blue_flower, red_flower]
var plant_types= [tree_types]

var loaded_plants : Dictionary = {}

const lightning_scene = preload("res://Scenes/Projectile/Lightning.tscn")
const lighting_main_branch = preload("res://Scenes/Projectile/LightingMainBranch.tscn")
const lighting_branch = preload("res://Scenes/Projectile/LightingProjectile.tscn")

const fire_fx = preload("res://Scenes/VFX/Fire.tscn")

signal plant_loaded

#### ACCESSORS ####

func is_class(value : String) -> bool: return value == TYPE or .is_class(value)
func get_class() -> String : return TYPE


#### BUILT-IN ####

func _ready():
	load_plants()
	emit_signal("plant_loaded")


func load_plants():
	for plant_type in plant_types:
		for plant in plant_type:
			var growth_states = plant.get_growth_states()
			var plant_name = plant.name
			var loaded_states : Array = []
			
			for state in growth_states:
				var plant_scene = load(state)
				loaded_states.append(plant_scene)
			
			loaded_plants[plant_name] = loaded_states


#### LOGIC ####



#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
