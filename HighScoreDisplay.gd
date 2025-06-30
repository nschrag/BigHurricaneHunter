extends VFlowContainer

@export var entry_ui: PackedScene

var high_scores = [
	{ "name": "Thunberg", "score":90000 },
	{ "name": "Thunberg", "score":80000 },
	{ "name": "Thunberg", "score":70000 },
	{ "name": "Thunberg", "score":60000 },
	{ "name": "Thunberg", "score":50000 },
	{ "name": "Thunberg", "score":40000 },
	{ "name": "Thunberg", "score":30000 },
	{ "name": "Thunberg", "score":20000 },
	{ "name": "Thunberg", "score":10000 },
	{ "name": "Thunberg", "score":5000 }
]

func _ready() -> void:
	var i = 0
	for entry in high_scores:
		var ui = entry_ui.instantiate()
		ui.populate(i + 1, entry["name"], entry["score"])
		add_child(ui)
		i = i + 1
