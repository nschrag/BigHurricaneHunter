extends Node2D

@export var speed = 300
@export var hurricane_parent: Node2D
@onready var horizontal = $Horizontal
@onready var vertical = $Vertical

func get_speed() -> float:
	if Input.is_action_pressed("fire"):
		return speed * 0.25
	else:
		return speed

func _process(delta: float) -> void:
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	horizontal.position += Vector2(0, input_vector.y * get_speed() * delta)
	vertical.position += Vector2(input_vector.x * get_speed() * delta, 0)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("fire"):
		for h in hurricane_parent.get_children():
			if h is Hurricane:
				var target_pos = Vector2(vertical.position.x, horizontal.position.y)
				var distance = (target_pos - h.position).length()
				if distance < 6:
					h.queue_free()
					print("hit")
