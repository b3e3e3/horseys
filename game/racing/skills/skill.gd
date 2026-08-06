class_name Skill extends Resource

enum Status {
	IDLE,
	ACTIVE,
}

@export var display_name: String
@export_range(0.0, 1.0, 0.05) var bp_effectiveness: float = 1.0

var current_status: Status = Status.IDLE

var last_activate_time: int = 0
var _last_activate_phase: RaceInfo.Phase = RaceInfo.Phase.START


func has_activated_this_phase(info: RaceInfo, horsey: Horsey) -> bool:
	return info.get_current_phase(horsey) == _last_activate_phase

func has_activated() -> bool: return last_activate_time > 0

func activate(_info: RaceInfo, _horsey: Horsey) -> void:
	last_activate_time = Time.get_ticks_msec()
	current_status = Status.ACTIVE

func is_active() -> bool:
	return current_status == Status.ACTIVE

func can_activate(info: RaceInfo, horsey: Horsey) -> bool:
	# print("%s PAC? %s is active? %s" % [horsey.name, passes_activation_check(info, horsey), is_active()])
	if is_active(): return false
	return passes_activation_check(info, horsey)

func passes_activation_check(_info: RaceInfo, horsey: Horsey) -> bool:
	var s := hash(horsey.progress_ratio)
	seed(s)
	# print("ACTIVATION CHECKING AT ", s)
	var random := randf()
	var sample := minf(bp_effectiveness * horsey.stats["brainpower"].get_value(), horsey.stats["brainpower"].max_effectiveness)
	var result := random < sample

	# print("%s PAC | %s < %s? %s | Is active? %s. Result: %s" % [horsey.name, random, sample, result, is_active(), result])
	return result

func reset() -> void:
	last_activate_time = 0
	current_status = Status.IDLE
