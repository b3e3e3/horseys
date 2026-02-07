class_name Skill extends Resource

enum Status {
	IDLE,
	ACTIVE,
}

@export var display_name: String
@export_range(0.0, 1.0, 0.05) var bp_effectiveness: float = 1.0

var current_status: Status = Status.IDLE

var last_activate_time: int = 0


func has_activated() -> bool: return last_activate_time > 0

func activate(_info: RaceInfo, _horsey: Horsey) -> void:
	last_activate_time = Time.get_ticks_msec()
	current_status = Status.ACTIVE

func can_activate(_info: RaceInfo, horsey: Horsey) -> bool:
	if current_status == Status.ACTIVE: return false
	var random := randf()
	return random < minf(bp_effectiveness * horsey.stats["brainpower"].current_value, 1.0)

func reset() -> void:
	current_status = Status.IDLE
