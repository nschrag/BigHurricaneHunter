extends Node2D

enum State { BOOT, TITLE, PLAY, RESULTS }
var game_state = State.BOOT

@onready var reticule: Reticule = $Reticule
@onready var game_timer: GameTimer = $Reticule/Center/DateTime

@export var hurricane: PackedScene
@export var spawn_rate: float = 2
var next_spawn_time = 0

func _ready() -> void:
	goto_state(State.TITLE)

func _process(delta: float) -> void:
	match game_state:
		State.TITLE:
			process_state_title(delta)
		State.PLAY:
			process_state_play(delta)
		State.RESULTS:
			pass
			
func goto_state(state: State) -> void:
	if game_state == state:
		return
		
	match state:
		State.TITLE:
			game_state = State.TITLE
			begin_state_title()
		State.PLAY:
			game_state = State.PLAY
			begin_state_play()
		State.RESULTS:
			game_state = State.RESULTS
			begin_state_results()

			
func begin_state_title() -> void:
	reticule.set_reticule_position(Vector2(270, 270))
	
func process_state_title(delta: float) -> void:
	reticule.process_input(delta, false)
	
func begin_state_play() -> void:
	$HighScoreDisplay.visible = false
	game_timer.start_timer()
			
func process_state_play(delta: float) -> void:
	reticule.process_input(delta, true)
	if Time.get_ticks_msec() > next_spawn_time:
		next_spawn_time = Time.get_ticks_msec() + spawn_rate * 1000
		
		var h: Hurricane = hurricane.instantiate()
		h.configure($Map01)

func begin_state_results() -> void:
	game_timer.stop_timer()
	var scores = $HighScoreDisplay
	if scores.is_high_score(game_timer.duration):
		scores.insert_high_score(game_timer.duration)
	$HighScoreDisplay.visible = true
	
func _unhandled_input(event: InputEvent) -> void:
	if game_state == State.TITLE:
		if event.is_action_released("fire") && reticule.is_fully_charged():
			goto_state(State.PLAY)
		
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
			
func _on_reticule_fire(target_pos: Vector2, fully_charged: bool) -> void:
	match game_state:
		State.TITLE:
			if fully_charged:
				goto_state(State.PLAY)
				
func _on_max_damage_sustained() -> void:
	goto_state(State.RESULTS)
