extends Sprite2D

@export var hurricane: PackedScene
@export var spawn_rate: float = 2
var next_spawn_time = 0

func _process(delta: float) -> void:
	if Time.get_ticks_msec() > next_spawn_time:
		next_spawn_time = Time.get_ticks_msec() + spawn_rate * 1000
		
		var h: Hurricane = hurricane.instantiate()
		add_child(h)
		var rect = get_rect()
		h.position = Vector2(randf_range(rect.get_center().x, rect.end.x), 
								randf_range(rect.position.y, rect.end.y))
		h.configure()
