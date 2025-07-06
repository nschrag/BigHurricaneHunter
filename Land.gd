extends Area2D

signal total_damage_changed(damage: float)

var hurricanes: Array[Node2D]
var damage: float

func _process(delta: float) -> void:
	var dps = 0
	for h in hurricanes:
		dps += h.get_dps()
		
	if dps > 0:
		damage += dps * delta
		total_damage_changed.emit(damage)

func _on_body_entered(body: Node2D) -> void:
	body.landfall = true
	hurricanes.append(body)

func _on_body_exited(body: Node2D) -> void:
	hurricanes.erase(body)
