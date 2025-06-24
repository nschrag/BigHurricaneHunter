extends Node2D

@export var speed = 300
@export var hurricane_parent: Node2D
@onready var horizontal = $Horizontal
@onready var vertical = $Vertical
@onready var center = $Center

signal charge_level_changed(value: int)

var charge: float = 0
var charge_level: int = 0
@export var max_charge_level: int = 5

func get_speed() -> float:
	if Input.is_action_pressed("fire"):
		return speed * 0.25
	else:
		return speed

#func _ready() -> void:
	
func _process(delta: float) -> void:
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	center.position += input_vector * get_speed() * delta
	horizontal.position = Vector2(0, center.position.y)
	vertical.position = Vector2(center.position.x, 0)
	
	if Input.is_action_pressed("fire"):
		charge += delta
		if charge * max_charge_level > charge_level + 1:
			charge_level = charge * max_charge_level
			charge_level_changed.emit(charge_level)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("fire"):
		charge = 0
		charge_level = 0
		charge_level_changed.emit(charge_level)
		
		for h in hurricane_parent.get_children():
			if h is Hurricane:
				var target_pos = Vector2(vertical.position.x, horizontal.position.y)
				var distance = (target_pos - h.position).length()
				if distance < 6:
					h.queue_free()
					print("hit")
