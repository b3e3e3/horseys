class_name Stat extends Resource

@export var display_name: String = "Stat Name"

@export var base_value: Variant
@export var max_value: Variant
@export var boost_value: Variant
@export var max_effectiveness: float = 0.99


var current_value: Variant:
	get:
		return get_value()
	set(val):
		set_value(val)

func get_value() -> Variant:
	return base_value + boost_value

func set_value(value: Variant, reset_boost: bool = true) -> void:
	if reset_boost:
		boost_value = 0
	base_value = value - boost_value

func boost(value: Variant) -> void:
	boost_value += value
	print("BOOSTING!")

func get_effectiveness() -> float:
	return min(get_value() / max_value, max_effectiveness)

func get_utilization() -> float:
	return get_value() / base_value

func process_stat(delta: float) -> void:
	if boost_value > 0:
		boost_value -= delta
	else:
		boost_value = 0
