class_name RaceInfo extends Resource

const DEBUG_reset_on_lap: bool = true

enum Phase {
	START,
	EARLY,
	MID,
	LATE,
	FINAL,
	FINISH,
}

# @export var skill_act_points: Array[float] = [0.25, 0.5, 0.75, 1.0,]
@export var phases: Dictionary[Phase, float] = {
	Phase.START: - 1.0,
	Phase.EARLY: 0.0,
	Phase.MID: 0.3,
	Phase.LATE: 0.6,
	Phase.FINAL: 0.9,
	Phase.FINISH: 1.0,
}

func get_current_phase(horsey: Horsey, reset_on_lap: bool = DEBUG_reset_on_lap) -> RaceInfo.Phase:
	var progress := horsey.total_progress
	if reset_on_lap:
		progress = horsey.progress_ratio

	if progress < phases[Phase.MID]:
		return Phase.EARLY
	elif progress < phases[Phase.LATE]:
		return Phase.MID
	elif progress < phases[Phase.FINAL]:
		return Phase.LATE
	elif progress < phases[Phase.FINISH]:
		return Phase.FINAL
	return Phase.FINISH
