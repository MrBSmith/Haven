extends StateBase

#### AOE STATE #### 

onready var area_node = $Area
var current_tile : Tile = null

func _ready():
	pass


func update(_delta: float):
	var mouse_pos = owner.get_global_mouse_position()
	var grid_node = get_tree().get_current_scene().get_node("Grid")
	
	var tile_array = grid_node.get_tiles()
	current_tile = find_closest_tile(mouse_pos, tile_array)
	
	owner.set_global_position(mouse_pos)
	area_node.set_global_position(current_tile.get_global_position())


func enter_state():
	owner.sprite_node.set_visible(false)
	area_node.set_visible(true)


func exit_state():
	owner.sprite_node.set_visible(true)
	area_node.set_visible(false)


# Return the closest tile from the given position in the given array of tiles
func find_closest_tile(pos: Vector2, tile_array: Array) -> Tile:
	var closest_tile : Tile = null
	var smallest_dist : float = INF
	
	for tile in tile_array:
		var tile_pos = tile.get_global_position()
		var dist_to_tile = pos.distance_to(tile_pos)
		if dist_to_tile < smallest_dist:
			smallest_dist = dist_to_tile
			closest_tile = tile
	
	return closest_tile
