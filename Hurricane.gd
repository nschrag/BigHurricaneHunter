extends PhysicsBody2D

class_name Hurricane

@export var speed: float = 100
@export var damage_per_second = 1000
var spread_per_second = 0.1
var spread = 0

var p0: Vector2
var p1: Vector2
var p2: Vector2
var approx_distance: float
var distance_traveled: float = 0
var landfall: bool = false

var draw_debug = false
var debug_path: Line2D

func configure(parent: Node2D, spawn_rect: Rect2, dest_rect: Rect2) -> void:
	var label: Label = $Panel/Label
	label.text = " %s " % HurricaneNames.get_next_name()
	var panel: Panel = $Panel
	var num_spaces = label.text.count(" ")
	var num_nonspace_chars = label.text.length() - num_spaces
	panel.set_size(Vector2(10 + (num_nonspace_chars + num_spaces / 2.0) * 12, 24))
		
	var rect = parent.get_rect()
	position = Vector2(
		randf_range(spawn_rect.position.x, spawn_rect.end.x), 
		randf_range(spawn_rect.position.y, spawn_rect.end.y))
	parent.add_child(self)

	p2 = Vector2(
		randf_range(dest_rect.position.x, dest_rect.end.x), 
		randf_range(dest_rect.position.y, dest_rect.end.y))
	p0 = position
	p1 = Vector2(randf_range(p0.x, p2.x), randf_range(p0.y, p2.y))
	approx_distance = (2 * (p2 - p0).length() + ((p1 - p2).length() + (p1 - p0).length())) / 3
	
	spread_per_second = randf_range(0.0, 0.2)
	
	if draw_debug:
		debug_path = Line2D.new()
		debug_path.width = 1
		debug_path.add_point(position)
		get_parent().add_child.call_deferred(debug_path)
		
func get_dps() -> float:
	return damage_per_second * $Sprite2D.scale.x * modulate.a
	
func _physics_process(delta: float) -> void:
	var alpha = 1
	if landfall:
		speed *= 1 - (0.05 * delta)
		alpha = modulate.a - delta * 0.25
		modulate.a = alpha
	else:
		spread += delta * spread_per_second
		var scale = (1 + spread) * Vector2.ONE
		$CollisionShape2D.scale = scale
		$Sprite2D.scale = scale
		
	distance_traveled += delta * speed
	move_and_collide(_quadratic_bezier(p0, p1, p2, distance_traveled / approx_distance) - position)
	
	if debug_path != null:
		debug_path.add_point(position)
	
	if alpha <= 0:
		queue_free()

func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	return q0.lerp(q1, t)
