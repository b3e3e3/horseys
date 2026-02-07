class_name Stat extends Resource

@export var display_name: String

@export var base_value: Variant = 1.0
@export var max_value: Variant = 1200.0
@export var offset_value: Variant = 0.0
# @export var boost_value: Variant = 0.0
@export var max_effectiveness: Variant = 0.99

@export var stat_travel_rate: Variant = 1200.0

var _target_value: Variant = null
var target_value: Variant:
	get:
		return get_target()
	set(val):
		set_target(val)

var current_value: Variant = base_value


# var _current_value_offset: Variant = 0.0
# var current_value: Variant:
# 	get:
# 		return max(current_value, 0)
# 	# set(val):
# 	# 	set_value(val)


func get_target() -> Variant:
	if _target_value == null: _target_value = base_value
	return _target_value

func set_target(new_target: Variant) -> void:
	_target_value = new_target

func _init(name: String = "Unnamed Stat"):
	if not self.display_name:
		self.display_name = name

func _to_string() -> String:
	return "%s: %s/%s(T:%s)" % [ self.display_name, self.get_value(), self.base_value, self.target_value]

func get_value() -> Variant:
	return current_value + offset_value
# 	return base_value + _current_value_offset + boost_value

# func set_value(value: Variant, reset_boost: bool = false) -> void:
# 	if reset_boost:
# 		boost_value = 0
# 	_current_value_offset = value - current_value

func get_effectiveness() -> float:
	return min(current_value / max_value, max_effectiveness)

func get_utilization() -> float:
	return current_value / base_value

func move_towards_target_value(delta: float):
	var decline_delta = delta * stat_travel_rate
	current_value = max(move_toward(current_value, target_value, decline_delta), offset_value)


func process_stat(delta: float) -> void:
	move_towards_target_value(delta)

	# if boost_value > 0:
	# 	boost_value -= delta * stat_travel_rate
	# else:
	# 	boost_value = 0

func decline_stat(delta: float) -> void:
	pass # if display_name == "Speed":
	# 	# print(_current_value_offset)
	# 	print("Declining to %f by %f" % [current_value - delta * stat_travel_rate, delta * stat_travel_rate])
	# _current_value_offset -= delta * stat_travel_rate