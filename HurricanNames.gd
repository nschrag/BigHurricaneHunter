extends Node

class_name HurricaneNames

static var names: Array[String]
static var name_index = 0

static func get_next_name() -> String:
	var i = name_index
	name_index = (name_index + 1) % names.size()
	return names[i]

static func load_name_data() -> void:
	if !FileAccess.file_exists("user://Top250Billionaires.json"):
		#file = FileAccess.open("res://Top250Billionaires.json", FileAccess.READ)
		var user_file = FileAccess.open("user://Top250Billionaires.json", FileAccess.WRITE)
		user_file.store_string(FileAccess.get_file_as_string("res://Top250Billionaires.json"))
		user_file.close()
		
	var json_string = FileAccess.get_file_as_string("user://Top250Billionaires.json")
	var json = JSON.new()
	json.parse(json_string)
	
	for entry in json.data["list"]:
		names.append(entry["name"])
		
	names.shuffle()
	
