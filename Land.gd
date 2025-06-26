extends Area2D

var hurricanes: Array[Node2D]
var damage: float

func _process(delta: float) -> void:
	for h in hurricanes:
		damage += delta * h.damage_per_second

func _on_body_entered(body: Node2D) -> void:
	hurricanes.append(body)

func _on_body_exited(body: Node2D) -> void:
	hurricanes.erase(body)
