extends Plant
class_name Grass

#### ACCESSORS ####



#### BUILT-IN ####



#### LOGIC ####


func grow():
	add_to_growth(1)
	add_to_dehydration(-1)
	prolifarate()

# Proliferate to a random position nearby
func prolifarate():
	var rdm_pos = rdm_pos_at_dist(get_global_position(), min_sibling_dist)
	var tile_under_pos = grid_node.get_tile_at_world_pos(rdm_pos)
	
	if tile_under_pos == null or tile_under_pos.is_growable():
		return
	
	var local_pos = rdm_pos - tile_under_pos.get_global_position()
	var new_grass = Globals.grass.instance()
	
	if tile_under_pos.is_plant_correct_position(new_grass, rdm_pos, min_sibling_dist):
		tile_under_pos.add_plant(new_grass, local_pos)


# Return a random position at the given distance of the given origin_pos
func rdm_pos_at_dist(origin_pos: Vector2, dist: float) -> Vector2:
	randomize()
	var rdm_angle = rand_range(0.0, 360.0)
	var rad_angle = deg2rad(rdm_angle)
	var direction = Vector2(cos(rad_angle), sin(rad_angle))
	
	return origin_pos + direction * dist

#### INPUTS ####


#### VIRTUALS ####

func get_category() -> String:
	return "Grass"

#### SIGNAL RESPONSES ####

