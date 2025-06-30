extends Label

class_name GameTimer
const game_days_per_real_millisecond = 2 * 0.001
const seconds_per_day = 24 * 60 * 60

const start_timestamp_string = { "year":2033, "month":6, "day":1}
const months = ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
static func get_start_timestamp() -> int:
	return Time.get_unix_time_from_datetime_dict({ "year":2033, "month":6, "day":1})
	
static func format_time(real_milliseconds:int) -> String:
	var game_milliseconds = real_milliseconds * game_days_per_real_millisecond * seconds_per_day
	var date_time = Time.get_datetime_dict_from_unix_time(get_start_timestamp() + game_milliseconds)
	return "%d %s %02d %02d:%02d" % [date_time["year"], months[date_time["month"]], date_time["day"], date_time["hour"], date_time["minute"]]
	
func _process(delta: float) -> void:
	text = format_time(Time.get_ticks_msec() )
