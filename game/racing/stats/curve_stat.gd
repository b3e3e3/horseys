class_name CurveStat extends Stat

@export var curve: Curve = preload("res://racing/stats/speed_curve.tres") # TODO! don't assume speed curve
@export var scale: float = 20.0


func get_target() -> Variant:
	if _target_value == null:
		_target_value = _get_sampled_value(base_value)
	return _target_value

func set_target(new_target: Variant) -> void:
	_target_value = _get_sampled_value(new_target)

func _init(name: String = "Stat", offset: Variant = offset_value):
	super._init(name)
	offset_value = offset

func _get_sampled_value(val: Variant) -> Variant:
	return scale * curve.sample(val) + offset_value

func _cooked_value():
	return _get_sampled_value(base_value)

func get_value() -> Variant:
	return _get_sampled_value(current_value)

func get_utilization() -> float:
	return get_value() / _cooked_value()