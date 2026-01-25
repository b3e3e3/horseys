class_name CurveStat extends Stat

@export var curve: Curve = preload("res://racing/stats/speed_curve.tres") # TODO! don't assume speed curve
@export var offset_value: Variant = 6.0

@export var scale: float = 20.0


func _cooked_value():
	return scale * curve.sample(base_value) + offset_value

func get_value() -> Variant:
	return scale * curve.sample(base_value + boost_value) + offset_value

func get_utilization() -> float:
	return get_value() / _cooked_value()