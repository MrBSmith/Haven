extends Area2D

func _ready():
	var _err = connect("area_entered", self, "_on_area_entered")
	_err = connect("area_exited", self, "_on_area_exited")


#### LOGIC ####

func adapt_grid_area(nb_tiles: int, tile_size: Vector2):
	var grid_size : Vector2 = nb_tiles * tile_size
	$CollisionShape2D.get_shape().set_extents(grid_size / 2)
	set_position(grid_size / 2)


#### SINGALS RESPONSES ####

func _on_area_entered(area: Area2D):
	if area is Card:
		area.on_grid_entered()

func _on_area_exited(area: Area2D):
	if area is Card:
		area.on_grid_exited()
