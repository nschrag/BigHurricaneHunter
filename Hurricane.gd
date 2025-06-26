extends PhysicsBody2D

class_name Hurricane

@export var speed: float = 100
var damage_per_second = 100
var p0: Vector2
var p1: Vector2
var p2: Vector2
var approx_distance: float
var distance_traveled: float = 0

var draw_debug = false
var debug_path: Line2D

func configure() -> void:
	var rect = get_parent().get_rect()
	p2 = Vector2(rect.position.x, randf_range(rect.position.y, rect.end.y))
	p0 = position
	p1 = Vector2(randf_range(p0.x, p2.x), randf_range(p0.y, p2.y))
	approx_distance = (2 * (p2 - p0).length() + ((p1 - p2).length() + (p1 - p0).length())) / 3
	
	if draw_debug:
		debug_path = Line2D.new()
		debug_path.width = 1
		debug_path.add_point(position)
		get_parent().add_child.call_deferred(debug_path)
	
func _physics_process(delta: float) -> void:
	distance_traveled += delta * speed
	#position = _quadratic_bezier(p0, p1, p2, distance_traveled / approx_distance)
	move_and_collide(_quadratic_bezier(p0, p1, p2, distance_traveled / approx_distance) - position)
	
	if debug_path != null:
		debug_path.add_point(position)
	
	if distance_traveled >= approx_distance:
		queue_free()

func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	return q0.lerp(q1, t)
