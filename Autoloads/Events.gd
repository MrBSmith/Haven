extends Node

# warnings-disable

signal turn_finished

signal new_tree_grown(tree)
signal tree_died(tree)

signal tile_type_changed(tile, prev_type, next_type)

signal meteo_animation_started
signal meteo_animation_finished
signal single_plant_animation_finished
signal flora_animation_finished
signal animal_phase_finished

signal wind_animation_required(tiles_affected, wind_dir, wind_force, duration)
signal rain_animation_required(tiles_affected, duration)
signal sun_animation_required(tiles_affected, duration)
signal thunder_animation_required()
