extends Node2D

enum State { TITLE, PLAY, RESULTS }
var game_state = State.PLAY

@onready var reticule: Reticule

@export var hurricane: PackedScene
@export var spawn_rate: float = 2
var next_spawn_time = 0

func _process(delta: float) -> void:
	match game_state:
		State.TITLE:
			pass
		State.PLAY:
			process_play(delta)
		State.RESULTS:
			pass
			
func begin_state_title() -> void:
	pass
			
func process_play(delta: float) -> void:	
	if Time.get_ticks_msec() > next_spawn_time:
		next_spawn_time = Time.get_ticks_msec() + spawn_rate * 1000
		
		var h: Hurricane = hurricane.instantiate()
		h.configure($Map01)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
