extends Line2D

@export var charge_level: int = 1
@onready var initial_color = default_color
var copies: Array[Line2D]

func _ready() -> void:
	copies = [ Line2D.new(), Line2D.new(), Line2D.new() ]
	for line in copies:
		line.default_color = default_color
		line.width = width
		
	copies[0].position = Vector2(-position.x, position.y)
	copies[0].add_point(points[0])
	copies[0].add_point(points[1])
	add_sibling.call_deferred(copies[0])
	
	copies[2].rotation = PI / 2
	copies[2].position = Vector2(position.y, position.x)
	copies[2].add_point(points[0])
	copies[2].add_point(points[1])
	add_sibling.call_deferred(copies[2])
	
	copies[1].rotation = PI / 2
	copies[1].position = Vector2(position.y, -position.x)
	copies[1].add_point(points[0])
	copies[1].add_point(points[1])
	add_sibling.call_deferred(copies[1])

func _on_charge_level_changed(value: int):
	if charge_level <= value:
		default_color = Color.RED
	else:
		default_color = initial_color
		
	for line in copies:
		line.default_color = default_color
