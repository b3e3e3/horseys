class_name RandValue extends StatValue

@export var min_value: Variant = 0.0
@export var max_value: Variant = 1.0


func get_value() -> Variant:
	return randf_range(min_value, max_value)

func _to_string() -> String:
	return "%s (%s-%s)" % [get_value(), min_value, max_value]
