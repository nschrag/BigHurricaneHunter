extends Node

class_name HighScoreEntry

@onready var display: HighScoreDisplay = get_parent()
var player_name_edit: LineEdit

func populate(rank: int, player_name: String, score: int) -> void:
	$Rank.text = str(rank)
	$DateTime.text = GameTimer.format_time(score)
	$PlayerName.text = player_name
	player_name_edit = $PlayerName
	
	if player_name.is_empty():
		$PlayerName.editable = true
		$PlayerName.caret_force_displayed = true
		$PlayerName.call_deferred("grab_focus")
		update_text()
		
const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ."
var current_char = 0
var allow_input_at_time = 0

func update_text() -> void:
	$PlayerName.text = display.input_player_name + chars[current_char]
	$PlayerName.set_caret_column(display.input_player_name.length())
	
func _input(event: InputEvent) -> void:
	if !$PlayerName.editable:
		return
	
	if allow_input_at_time < Time.get_ticks_msec():	
		if event.is_action_pressed("ui_up"):
			allow_input_at_time = Time.get_ticks_msec() + 250
			current_char = (current_char + 1) % chars.length()
			update_text()
		if event.is_action_pressed("ui_down"):
			allow_input_at_time = Time.get_ticks_msec() + 250
			current_char = (current_char + chars.length() - 1) % chars.length()
			update_text()
		if event.is_action_pressed("ui_right"):
			allow_input_at_time = Time.get_ticks_msec() + 250
			display.input_player_name = display.input_player_name + chars[current_char]
			update_text()
		if event.is_action_pressed("ui_left"):
			allow_input_at_time = Time.get_ticks_msec() + 250
			display.input_player_name = display.input_player_name.substr(0, display.input_player_name.length() - 1)
			update_text()
	
	if event.is_action_pressed("ui_text_backspace"):
		display.input_player_name = display.input_player_name.substr(0, display.input_player_name.length() - 1)
		update_text()
		
	if event.is_action_pressed("ui_accept"):
		$PlayerName.editable = false
		$PlayerName.caret_force_displayed = false
		$PlayerName.text = display.input_player_name
		display.update_name()
		
	if !event.is_action_pressed("ui_cancel") && !event.is_action_released("fire"):
		get_viewport().set_input_as_handled()

func save_name() -> void:
	if player_name_edit != null && player_name_edit.editable:
		player_name_edit.editable = false
		player_name_edit.caret_force_displayed = false
		player_name_edit.text = display.input_player_name + chars[current_char]
		display.update_name()
