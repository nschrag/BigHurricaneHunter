@tool
extends Node2D

@export var active: bool
@export var rate: float

func _process(delta: float) -> void:
	if !active:
		rotation = 0
		return
		
	rotation += PI * delta * rate
