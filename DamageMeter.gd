extends Node2D

@export var max_damage: float = 10**6
var damage_meter: Line2D
var damage_meter_length: float

func _ready() -> void:
	damage_meter = $Background/Value
	damage_meter_length = abs(damage_meter.get_point_position(0).y - damage_meter.get_point_position(1).y)

func _on_total_damage_changed(damage: float) -> void:
	var pct = 1 - damage / max_damage
	damage_meter.set_point_position(1, Vector2(damage_meter.get_point_position(0).x, damage_meter.get_point_position(0).y - damage_meter_length * pct))
