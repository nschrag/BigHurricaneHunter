extends Node

class_name HurricaneNames

var name_data: Dictionary

static func load_name_data() -> void:
	if !FileAccess.file_exists("user://Top250Billionaires.json"):
		#file = FileAccess.open("res://Top250Billionaires.json", FileAccess.READ)
		var user_file = FileAccess.open("user://Top250Billionaires.json", FileAccess.WRITE)
		user_file.store_string(FileAccess.get_file_as_string("res://Top250Billionaires.json"))
		user_file.close()
		
	var json_string = FileAccess.get_file_as_string("user://Top250Billionaires.json")
	var json = JSON.new()
	json.parse(json_string)
	
	print(json.data["list"][0]["name"])
	
