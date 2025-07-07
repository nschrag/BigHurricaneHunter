extends VFlowContainer

class_name HighScoreDisplay

@export var entry_ui: PackedScene

signal high_score_entered()

var high_scores = [
	{ "name": "COMPUTER", "score":90000 },
	{ "name": "COMPUTER", "score":80000 },
	{ "name": "COMPUTER", "score":70000 },
	{ "name": "COMPUTER", "score":60000 },
	{ "name": "COMPUTER", "score":50000 },
	{ "name": "COMPUTER", "score":40000 },
	{ "name": "COMPUTER", "score":30000 },
	{ "name": "COMPUTER", "score":20000 },
	{ "name": "COMPUTER", "score":10000 },
	{ "name": "COMPUTER", "score":5000 }
]

var input_player_name = ""

func _ready() -> void:
	var i = 0
	for entry in high_scores:
		var ui = entry_ui.instantiate()
		ui.populate(i + 1, entry["name"], entry["score"])
		add_child(ui)
		i = i + 1
	
func refresh_display() -> void:
	var i = 0
	for entry in high_scores:
		var ui = get_child(i)
		ui.populate(i + 1, entry["name"], entry["score"])
		i = i + 1
		#print(get_viewport().gui_get_focus_owner())
		
func is_high_score(score: int) -> bool:
	return score > high_scores.back()["score"]
	
func insert_high_score(score: int) -> int:
	var index = 0
	for entry in high_scores:
		if score > entry["score"]:
			break
		index = index + 1
		
	high_scores.insert(index, { "name": "", "score": score })
	high_scores.pop_back()
	refresh_display()
	return index
	
func update_name() -> void:
	for entry in high_scores:
		if entry["name"].is_empty():
			entry["name"] = input_player_name
			break
			
	high_score_entered.emit()

func _on_reticule_fire(target_pos: Vector2, fully_charged: bool) -> void:
	for ui in get_children():
		ui.save_name()
