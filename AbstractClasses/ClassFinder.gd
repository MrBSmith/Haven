extends Node
class_name ClassFinder

export var debug : bool = false

export var dir_path : String = ""
export var targeted_class : String = ""
export var exceptions_array : Array = []
var target_array : Array = []

#### ACCESSORS ####



#### BUILT-IN ####

func _ready():
	if debug:
		print_debug("    ----- FINDING " + targeted_class + " -----    ")
	find_all_scene_of_class(dir_path) # Generate the chapter dynamicly


#### LOGIC ####

# Loop through every folders and files in the current dir
# If it finds a target, store it, else continue digging
func find_all_scene_of_class(path : String = ""):
	if path == "":
		if debug:
			print("ERROR: the find_all_script_of_class method has no specified path")
		return
	
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin(true)
		var current_file_name : String = dir.get_next()
		
		while current_file_name != "":
			# Continue digging if the current file is a dir
			if dir.current_is_dir():
				if debug:
					print("Found directory: " + current_file_name)
				var current_dir_path = get_current_file_path(dir, current_file_name)
				find_all_scene_of_class(current_dir_path)
			
			# If the file is a targeted scene, store it in the target_array
			else:
				var current_scene_path = get_current_file_path(dir, current_file_name)
				if current_scene_path.ends_with(".tscn"):
					var scene = load(current_scene_path)
					var instance = scene.instance()
					
					if instance.has_method("is_class") && instance.is_class(targeted_class) \
						&& !is_exception(current_file_name):
						target_array.append([instance, scene])
						if debug:
							print("       Found target file: " + current_file_name)
					else:
						instance.queue_free()
			
			# Access the next file/folder
			current_file_name = dir.get_next()
	
	else:
		if debug:
			print("ERROR : the directory '" + path + "' can't be found")


# Retruns the path of the current file pointed by the dir object
func get_current_file_path(dir : Directory, current_file_name : String) -> String:
	return dir.get_current_dir() + "/" + current_file_name


# Returns true if the given file is in the list of exceptions
func is_exception(file_name: String) -> bool:
	for exept in exceptions_array:
		if exept.is_subsequence_of(file_name):
			return true
	return false


#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
