extends Node

#### GLOBALS AUTOLOAD ####

var window_width = ProjectSettings.get_setting("display/window/size/width")
var window_height = ProjectSettings.get_setting("display/window/size/height")
var window_size = Vector2(window_width, window_height)

const TILE_SIZE = Vector2(16, 16)
const GRID_TILE_SIZE = Vector2(6, 6)
