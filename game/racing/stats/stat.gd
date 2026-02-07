class_name Stat extends Resource

@export var display_name: String

@export var base_value: Variant = 1.0
@export var max_value: Variant = 1200.0
@export var boost_value: Variant = 0.0
@export var max_effectiveness: Variant = 0.99

@export var stat_decline_rate: Variant = 1200.0


var _current_value_offset: Variant = 0.0
var current_value: Variant:
	get:
		return max(get_value(), 0)
	# set(val):
	# 	set_value(val)


func get_stat_decline_rate(delta: float) -> float:
	return delta * stat_decline_rate

func _init(name: String = "Unnamed Stat"):
	if not self.display_name:
		self.display_name = name

func _to_string() -> String:
	return "%s: %s" % [ self.display_name, self.get_value()]

func get_value() -> Variant:
	return base_value + _current_value_offset + boost_value

func set_value(value: Variant, reset_boost: bool = false) -> void:
	if reset_boost:
		boost_value = 0
	_current_value_offset = value - current_value

func boost(value: Variant) -> void:
	boost_value += value

func get_effectiveness() -> float:
	return min(get_value() / max_value, max_effectiveness)

func get_utilization() -> float:
	return get_value() / base_value

func process_stat(delta: float) -> void:
	if boost_value > 0:
		boost_value -= delta * get_stat_decline_rate(delta)
	else:
		boost_value = 0

func decline_stat(delta: float) -> void:
	if display_name == "Speed":
		# print(_current_value_offset)
		print("Declining to %f by %f" % [current_value - get_stat_decline_rate(delta), get_stat_decline_rate(delta)])
	_current_value_offset -= get_stat_decline_rate(delta)