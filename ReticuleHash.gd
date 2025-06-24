extends Line2D

@export var charge_level: int = 1
@onready var initial_color = default_color

func _on_charge_level_changed(value: int):
	if charge_level <= value:
		default_color = Color.RED
	else:
		default_color = initial_color
