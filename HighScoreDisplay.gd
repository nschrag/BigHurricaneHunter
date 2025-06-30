extends VFlowContainer

@export var entry: PackedScene

func _ready() -> void:
	for i in 10:
		var e = entry.instantiate()
		add_child(e)
