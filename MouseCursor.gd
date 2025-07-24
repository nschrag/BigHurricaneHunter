extends Line2D

class_name MouseCursor

func set_cursor_position(pos: Vector2):
	set_point_position(0, pos.normalized() * 10)
	set_point_position(1, pos)
	visible = pos.length() >= 10
