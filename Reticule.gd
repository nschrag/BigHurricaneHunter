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
@onready var timer_label = $Center/DateTime

signal fire(target_pos:Vector2, fully_charged:bool)
signal charge_level_changed(value: int)

var charge: float = 0
var charge_level: int = 0
var charge_level_radius: Array[int]
@export var max_charge_level: int = 5
@export var full_charge_time: float = 2
@onready var charge_rate = full_charge_time / max_charge_level

var hit_streak: int = 0
var bonus_level: int = 0;

func get_speed() -> float:
	var s = speed + bonus_level * 10
	if Input.is_action_pressed("fire"):
		return s * 0.25
	else:
		return s

func _ready() -> void:
	charge_level_radius = [
		abs($Center/HHash4.position.x),
		abs($Center/HHash3.position.x),
		abs($Center/HHash2.position.x),
		abs($Center/HHash1.position.x),
		0 # full charge precision
	]
func is_fully_charged() -> bool:
	return charge_level >= max_charge_level
	
func get_firing_radius() -> float:
	return charge_level_radius[min(charge_level - 1, charge_level_radius.size() - 1)]
	
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
	
func reset_state() -> void:
	hit_streak = 0
	charge = 0
	charge_level = 0
	charge_level_changed.emit(charge_level)
	
func show_text(show_aim_speed: bool, show_timer: bool) -> void:
	aim_speed_label.visible = show_aim_speed
	timer_label.visible = show_timer

func random_in_circle(radius: float) -> Vector2:
	var r = radius * sqrt(randf())
	var theta = randf() * 2 * PI
	return Vector2(r * cos(theta), r * sin(theta))
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("fire") && charge_level > 0:
		var target_pos = Vector2(vertical.position.x, horizontal.position.y)
		target_pos = target_pos + random_in_circle(get_firing_radius())
		fire.emit(target_pos, charge_level >= max_charge_level)
		
		var success = false
		for h in hurricane_parent.get_children():
			if h is Hurricane:
				var distance = (target_pos - h.position).length()
				if distance <= h.get_eye_radius() + 3:
					success = true
					h.queue_free()
		
		if success:
			hit_streak += 1
			if hit_streak > max_charge_level:
				bonus_level += 1
				aim_speed_label.text = "%d mph" % get_speed()
		else:
			hit_streak = 0
		
		# bonus starting charge level for hit streaks
		charge_level = hit_streak
		charge = charge_level / float(max_charge_level)
		charge_level_changed.emit(charge_level)
