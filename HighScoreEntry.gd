extends Node

class_name HighScoreEntry

func populate(rank: int, name: String, score: int) -> void:
	$Rank.text = str(rank)
	$DateTime.text = GameTimer.format_time(score)
	$PlayerName.text = name
