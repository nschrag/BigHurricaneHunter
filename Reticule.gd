extends Node2D

class_name Reticule

var speed = 300

@export var hurricane_parent: Node2D

@onready var horizontal = $Horizontal
@onready var horizontal_left: Line2D = $Horizontal/Horizontal_L
@onready var horizontal_right: Line2D = $Horizontal/Horizontal_R
@onready var vertical = $Vertical
@onready var vertical_up: Line2D = $Vertical/Vertical_U
@onready var vertical_down: Line2D = $Vertical/Vertical_D
@onready var center = $Center
@onready var aim_speed_label = $Center/AimSpeed/Value
@onready var charge_speed_label = $Center/ChargeSpeed/Value
@onready var timer_label = $Center/DateTime

signal fire(target_pos:Vector2, fully_charged:bool)
signal charge_level_changed(value: int)

var charge: float = 0
var charge_level: int = 0
var charge_level_radius: Array[int]
@export var max_charge_level: int = 5
@export var full_charge_time: float = 2
#@onready var charge_rate = full_charge_time / max_charge_level

var hit_streak: int = 0
var speed_bonus_level: int = 0;
var charge_bonus_level: int = 0;

var mouse_target: Vector2

func get_speed() -> float:
	var s = speed * (1 + speed_bonus_level * 0.05)
	if Input.is_action_pressed("fire"):
		return s * 0.25
	else:
		return s
		
func get_charge_rate() -> float:
	var t = full_charge_time * (1 - charge_bonus_level * 0.05)
	return 1 / t

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
	
func get_mouse_vector() -> Vector2:
	var dif:Vector2 = get_global_mouse_position() - (center.position)
	var distance = dif.length()
	if distance <= 10:
		return Vector2.ZERO
	else:
		return dif.normalized() * min(1, distance / 1500.0)
	
func process_input(delta: float, aim: bool) -> void:
	if aim:
		if Input.get_connected_joypads().size() > 0:
			var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
			set_reticule_position(center.position + input_vector * get_speed() * delta)
		else:
			var dir = (mouse_target - center.position)
			var distance = get_speed() * delta
			if distance > dir.length():
				set_reticule_position(mouse_target)
			else:
				set_reticule_position(center.position + dir.normalized() * distance)
			
			pass
			#var dif:Vector2 = get_global_mouse_position() - center.position
			var dif:Vector2 = Input.get_last_mouse_velocity().normalized()
			var speed = min(1, dif.length() / 100) ** 2 * get_speed()
			#var speed = get_speed()
			set_reticule_position(center.position + dif * speed * delta)
			#set_reticule_position(dif)
			
	
	if Input.is_action_pressed("fire"):
		charge += get_charge_rate() * delta
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
	charge_bonus_level = 0
	speed_bonus_level = 0
	charge_level_changed.emit(charge_level)
	aim_speed_label.text = "1.00"
	charge_speed_label.text = "1.00"
	mouse_target = center.position
	
func show_text(show_aim_speed: bool, show_timer: bool) -> void:
	aim_speed_label.get_parent().visible = show_aim_speed
	charge_speed_label.get_parent().visible = show_aim_speed
	timer_label.visible = show_timer

func random_in_circle(radius: float) -> Vector2:
	var r = radius * sqrt(randf())
	var theta = randf() * 2 * PI
	return Vector2(r * cos(theta), r * sin(theta))

enum HitResult { HIT, CLOSE, MISS }
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var motion = event as InputEventMouseMotion
		mouse_target += motion.relative
		$MouseCursor.position = mouse_target
	if event.is_action_released("fire") && charge_level > 0:
		var target_pos = Vector2(vertical.position.x, horizontal.position.y)
		target_pos = target_pos + random_in_circle(get_firing_radius())
		fire.emit(target_pos, charge_level >= max_charge_level)
		
		var success = HitResult.MISS
		for h in hurricane_parent.get_children():
			if h is Hurricane:
				var distance = (target_pos - h.position).length()
				if distance <= h.get_eye_radius() + 3:
					success = HitResult.HIT
					h.queue_free()
					break
				elif distance <= h.get_storm_radius():
					success = HitResult.CLOSE
					h.waver()
					break
		
		match success:
			HitResult.HIT:
				hit_streak += 1
				if hit_streak > max_charge_level:
					if randf() <= 0.5:
						speed_bonus_level += 1
						aim_speed_label.text = str(1 + speed_bonus_level * 0.05)
					else:
						charge_bonus_level += 1
						charge_speed_label.text = str(1 + charge_bonus_level * 0.05)
			HitResult.CLOSE:
				hit_streak = 0
			HitResult.MISS:
				hit_streak = 0
		
		# bonus starting charge level for hit streaks
		charge_level = hit_streak
		charge = charge_level / float(max_charge_level)
		charge_level_changed.emit(charge_level)
