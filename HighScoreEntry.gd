extends Node

class_name HighScoreEntry

func populate(rank: int, player_name: String, score: int) -> void:
	$Rank.text = str(rank)
	$DateTime.text = GameTimer.format_time(score)
	$PlayerName.text = player_name
	
	if player_name.is_empty():
		$PlayerName.editable = true
		$PlayerName.caret_force_displayed = true
		$PlayerName.call_deferred("grab_focus")
		$PlayerName.text = current_string + chars[current_char]
		
const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ."
var current_char = 0
var current_string = ""
var allow_input_at_time = 0

func update_text() -> void:
	$PlayerName.text = current_string + chars[current_char]
	$PlayerName.set_caret_column(current_string.length())
	
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
			
	if event.is_action_pressed("fire"):
		current_string = current_string + chars[current_char]
		update_text()
	
	if event.is_action_pressed("ui_text_backspace"):
		current_string = current_string.substr(0, current_string.length() - 1)
		update_text()
		
	if event.is_action_pressed("ui_accept"):
		$PlayerName.editable = false
		$PlayerName.caret_force_displayed = false
		$PlayerName.text = current_string
		get_parent().update_name(current_string)
		
	if !event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		
