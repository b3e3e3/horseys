class_name CurveStat extends Stat

@export var curve: Curve = Curve.new()
@export var offset_value: Variant = 6.0


func get_value() -> Variant:
	var val = base_value
	return curve.sample(val) + offset_value + boost_value
