extends Node2D

@export var speed = 300
@onready var horizontal = $Horizontal
@onready var vertical = $Vertical

func _process(delta: float) -> void:
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	horizontal.position += Vector2(0, input_vector.y * speed * delta)
	vertical.position += Vector2(input_vector.x * speed * delta, 0)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("fire"):
		for h in get_parent().get_children():
			if h is Hurricane:
				var target_pos = Vector2(vertical.position.x, horizontal.position.y)
				var distance = (target_pos - h.position).length()
				if distance < 6:
					h.queue_free()
					print("hit")
