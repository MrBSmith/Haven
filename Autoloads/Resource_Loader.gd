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

var oak = preload("res://Scenes/Plants/Trees/Oak/OakBase.tscn").instance()
const grass = preload("res://Scenes/Plants/SmallPlants/Grass.tscn")
const blue_flower = preload("res://Scenes/Plants/SmallPlants/Flowers/BlueFlower/BlueFlower.tscn")
const red_flower = preload("res://Scenes/Plants/SmallPlants/Flowers/RedFlower/RedFlower.tscn")

var tree_types = [oak]
var flower_types = [blue_flower, red_flower]

const lightning_scene = preload("res://Scenes/Projectile/Lightning.tscn")
const lighting_main_branch = preload("res://Scenes/Projectile/LightingMainBranch.tscn")
const lighting_branch = preload("res://Scenes/Projectile/LightingProjectile.tscn")

const fire_fx = preload("res://Scenes/VFX/Fire.tscn")

#### ACCESSORS ####

func is_type(value : String) -> bool: return value == TYPE or .is_type(value)
func get_type() -> String : return TYPE


#### BUILT-IN ####



#### LOGIC ####



#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
