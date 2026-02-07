class_name CurveStat extends Stat

@export var curve: Curve = preload("res://racing/stats/speed_curve.tres") # TODO! don't assume speed curve
@export var offset_value: Variant

@export var scale: float = 20.0


func _init(name: String = "Stat", offset: Variant = 6.0):
	super._init(name)
	offset_value = offset

# func _init_current_value():
# 	_current_value = base_value

func _cooked_value():
	return scale * curve.sample(base_value) + offset_value

func get_value() -> Variant:
	return scale * curve.sample(super.get_value()) + offset_value

func get_utilization() -> float:
	return get_value() / _cooked_value()