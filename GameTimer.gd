extends Label

@onready var start_timestamp = Time.get_unix_time_from_datetime_dict({ "year":2033, "month":5, "day":1})
const months = ["January", "February", "March", "April", "May", "June", "July", "August", "Sept", "October", "November", "December"]

func _process(delta: float) -> void:
	var date_time = Time.get_datetime_dict_from_unix_time(start_timestamp + Time.get_ticks_msec() * 100)
	#text = "%d" % [date_time["year"]]
	text = "%d %s %02d %02d:%02d" % [date_time["year"], months[date_time["month"]], date_time["day"], date_time["hour"], date_time["minute"]]
