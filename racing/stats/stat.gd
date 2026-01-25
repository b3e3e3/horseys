class_name Stat extends Resource

@export var display_name: String = "Stat Name"

@export var base_value: Variant = 1.0
@export var max_value: Variant = 1200.0
@export var boost_value: Variant = 0.0
@export var max_effectiveness: Variant = 0.99


var current_value: Variant:
	get:
		return get_value()
	set(val):
		set_value(val)


func _init(name: String = "Stat"):
	self.display_name = name

func _to_string() -> String:
	return "%s: %s" % [self.display_name, self.get_value()]

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
