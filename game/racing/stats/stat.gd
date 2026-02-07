class_name Stat extends Resource

@export var display_name: String

@export var curve: Curve = preload("res://racing/stats/speed_curve.tres") # TODO! don't assume speed curve
@export var curve_scale: float = 20.0

@export var offset_value: Variant = 0.0
@export var max_effectiveness: Variant = 0.99

@export var stat_travel_speed: Variant = 1.0

var base_value: Variant = 1.0
var max_value: Variant = 1200.0

var target_value: Variant
var _current_value: Variant


func _init(name: String = "Unnamed Stat"):
	if not self.display_name:
		self.display_name = name

func _to_string() -> String:
	return "%s: %f - %s/%s(T:%s)" % [ self.display_name, self.get_value(), self._current_value, self.base_value, self.target_value]

func _get_sampled_value(val: Variant) -> Variant:
	return curve_scale * curve.sample(val) + offset_value

func get_value() -> Variant:
	var val = base_value if _current_value == null else _current_value
	return _get_sampled_value(val)

func process_stat(delta: float) -> void:
	if _current_value == null: _current_value = base_value
	if target_value == null: target_value = _current_value

	var travel_delta = delta * stat_travel_speed
	_current_value = move_toward(_current_value, target_value, travel_delta)

# func get_effectiveness() -> float:
# 	return min(_current_value / max_value, max_effectiveness)

func get_utilization() -> float:
	return get_value() / _get_sampled_value(base_value)
