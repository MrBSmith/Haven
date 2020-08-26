extends Node

# warnings-disable

signal turn_finished
signal meteo_animation_finished
signal single_plant_animation_finished
signal flora_animation_finished

signal wind_animation_required(tiles_affected, wind_dir, wind_force, duration)
signal rain_animation_required(tiles_affected, duration)
signal sun_animation_required(tiles_affected, duration)
