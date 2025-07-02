extends Label

func _process(delta: float) -> void:
	visible = Time.get_ticks_msec() / 1000 % 2
