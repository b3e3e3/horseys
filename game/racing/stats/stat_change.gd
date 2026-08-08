extends RefCounted
class_name StatChangeInfo

enum Type {
	BOOST,
	SET,
}

var type: Type
var duration: float

func _init(change_duration: float, change_type: Type):
	type = change_type
	duration = change_duration

func is_timed_out() -> bool:
	return duration <= 0

# func revert() -> void:
	


# var horsey: Horsey
# var duration: float
# var stat_name: String
# var value: Variant
# var _original_value: Variant

# func _init(action_horsey: Horsey, action_duration: float, action_type: Type, action_stat_name: String, action_value: Variant):
# 	horsey = action_horsey
# 	duration = action_duration
# 	type = action_type
# 	stat_name = action_stat_name
# 	value = action_value
# 	_original_value = value

# 	Global.action_schedule.append(self)

# func process(delta: float) -> void:
# 	duration -= delta
# 	if duration <= 0.0:
# 		match type:
# 			Type.BOOST:
# 				horsey.stats[stat_name].set_driver_value(_original_value)
# 		Global.action_schedule.erase(self)