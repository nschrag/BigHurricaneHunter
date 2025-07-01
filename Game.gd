extends Node2D

enum State { BOOT, TITLE, PLAY, RESULTS }
var game_state = State.BOOT

@onready var reticule: Reticule = $Reticule
@onready var game_timer: GameTimer = $Reticule/Center/DateTime

@export var hurricane: PackedScene
@export var fire_effect: PackedScene
@export var spawn_rate: float = 2
var next_spawn_time = 0

func _ready() -> void:
	#game_timer.duration = 12000
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
		
	match game_state:
		State.TITLE:
			end_state_title()
		State.PLAY:
			end_state_play()
		State.RESULTS:
			end_state_results()
			
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
	reticule.show_text(false, true)
	
func process_state_title(delta: float) -> void:
	reticule.process_input(delta, false)
	
func end_state_title() -> void:
	pass
	
func begin_state_play() -> void:
	$HighScoreDisplay.visible = false
	$Map01/Area2D.damage = 0
	game_timer.start_timer()
	reticule.show_text(true, true)
			
func process_state_play(delta: float) -> void:
	reticule.process_input(delta, true)
	if Time.get_ticks_msec() > next_spawn_time:
		next_spawn_time = Time.get_ticks_msec() + spawn_rate * 1000
		
		var h: Hurricane = hurricane.instantiate()
		h.configure($Map01)
		
func end_state_play() -> void:
	reticule.reset_state()

func begin_state_results() -> void:
	game_timer.stop_timer()
	var scores = $HighScoreDisplay
	scores.visible = true
	if scores.is_high_score(game_timer.duration):
		var index = scores.insert_high_score(game_timer.duration)
		var y_pos = scores.get_child(index).global_position.y + 40
		reticule.set_reticule_position(Vector2(270, y_pos))
		reticule.show_text(false, false)
	else:
		reticule.set_reticule_position(Vector2(270, 270))
		reticule.show_text(false, true)
		
func end_state_results() -> void:
	for child in $Map01.get_children():
		if child is Hurricane:
			child.queue_free()
	
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
		State.PLAY:
			var vfx = FireEffect.fetch_effect(fire_effect, $Map01)
			vfx.play_vfx(target_pos)
				
func _on_max_damage_sustained() -> void:
	goto_state(State.RESULTS)

func _on_high_score_entered() -> void:
	goto_state(State.TITLE)
