extends Node2D

class_name Reticule

@export var speed = 300

@export var hurricane_parent: Node2D

@onready var horizontal = $Horizontal
@onready var horizontal_left: Line2D = $Horizontal/Horizontal_L
@onready var horizontal_right: Line2D = $Horizontal/Horizontal_R
@onready var vertical = $Vertical
@onready var vertical_up: Line2D = $Vertical/Vertical_U
@onready var vertical_down: Line2D = $Vertical/Vertical_D
@onready var center = $Center
@onready var aim_speed_label = $Center/AimSpeed

signal fire(target_pos:Vector2, fully_charged:bool)
signal charge_level_changed(value: int)

var charge: float = 0
var charge_level: int = 0
@export var max_charge_level: int = 5
@export var full_charge_time: float = 2
@onready var charge_rate = full_charge_time / max_charge_level

var hit_streak: int = 0
var bonus_level: int = 0;

func is_fully_charged() -> bool:
	return charge_level >= max_charge_level

func get_speed() -> float:
	var s = speed + bonus_level * 10
	if Input.is_action_pressed("fire"):
		return s * 0.25
	else:
		return s

#func _ready() -> void:
	
func process_input(delta: float, aim: bool) -> void:
	if aim:
		var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		set_reticule_position(center.position + input_vector * get_speed() * delta)
	
	if Input.is_action_pressed("fire"):
		charge += charge_rate * delta
		if charge * max_charge_level > charge_level + 1:
			charge_level = charge * max_charge_level
			charge_level_changed.emit(charge_level)

func set_reticule_position(p: Vector2) -> void:
	center.position = p
	horizontal.position = Vector2(0, center.position.y)
	horizontal_left.points[0].x = center.position.x - 10
	horizontal_right.points[0].x = center.position.x + 10
	vertical.position = Vector2(center.position.x, 0)
	vertical_up.points[0].y = center.position.y - 10
	vertical_down.points[0].y = center.position.y + 10
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("fire"):
		fire.emit(Vector2(vertical.position.x, horizontal.position.y), charge_level >= max_charge_level)
		
		var success = false
		for h in hurricane_parent.get_children():
			if h is Hurricane:
				var target_pos = Vector2(vertical.position.x, horizontal.position.y)
				var distance = (target_pos - h.position).length()
				if distance <= 10:
					success = true
					h.queue_free()
					print("hit")
		
		if success:
			hit_streak += 1
			if hit_streak > max_charge_level:
				bonus_level += 1
				aim_speed_label.text = "%d mph" % get_speed()
		else:
			hit_streak = 0
			
		charge_level = hit_streak
		charge = charge_level / float(max_charge_level)
		charge_level_changed.emit(charge_level)
