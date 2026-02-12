class_name Stat extends Resource

@export var display_name: String

@export var curve: Curve = preload("res://racing/stats/speed_curve.tres") # TODO! don't assume speed curve
@export var curve_scale: float = 20.0

@export var offset_value: Variant = 0.0
@export var max_effectiveness: Variant = 0.99

@export var target_value: Variant
@export var stat_travel_speed: Variant = 1.0

var base_value: Variant = 1.0
var max_value: Variant = 1200.0

var _driver_value: Variant

var _target_boosts: Dictionary[StringName, Variant] = {}


func initialize_values(\
	base: Variant, \
	driver: Variant = base, \
	target: Variant = driver if target_value == null else target_value \
):
	print("INIT %s: Base: %.3f Driver: %.3f Target %.3f" % [display_name, base, driver, target])
	base_value = base
	_driver_value = driver
	target_value = target


func _init(name: String = "Unnamed Stat"):
	if not self.display_name:
		self.display_name = name

func _to_string() -> String:
	return "%s: %.3f - %.3f/%.3f(T:%.3s)" % [ self.display_name, self.get_value(), self.get_driver_value(), self.base_value, self.get_target_value_with_boosts()]

func _get_sampled_value(val: Variant) -> Variant:
	return curve_scale * curve.sample(val) + offset_value

func _get_sampled_value_exceeding_domain(val: Variant) -> Variant:
	var _sample_base = val / curve.max_domain
	return (_get_sampled_value(val) + _sample_base)

func get_target_boost(idx: int) -> Variant:
	return _target_boosts.get(idx)

func add_target_boost(value: Variant) -> StringName:
	var id := str(value) + str(Time.get_ticks_msec())
	_target_boosts.set(id, value)
	return id

func remove_target_boost(id: StringName) -> void: # TODO: don't do this by value maybe?
	_target_boosts.erase(id)

func get_target_value_with_boosts() -> Variant:
	var sum := func(accum, boost):
		return accum + boost

	return _target_boosts.values().reduce(sum, target_value)

func set_driver_value(new_val: Variant) -> void:
	_driver_value = new_val

func get_driver_value() -> Variant:
	# if _driver_value == null: _driver_value = base_value
	return _driver_value

func get_value() -> Variant:
	return _get_sampled_value(get_driver_value())

func process_stat(delta: float) -> void:
	# if target_value == null: target_value = get_driver_value()
	_driver_value = move_toward(get_driver_value(), get_target_value_with_boosts(), stat_travel_speed * delta)
	# _driver_value = lerpf(get_driver_value(), get_target_value_with_boosts(), travel_delta)

# func get_effectiveness() -> float:
# 	return min(_driver_value / max_value, max_effectiveness)

func get_utilization() -> float:
	var val = get_driver_value() # max_value if _driver_value == null else _driver_value
	# if is_zero_approx(val): return 0
	if max_value == 0.0: return 0
	return val / max_value # get_value() / _get_sampled_value(base_value)
