class_name RaceInfo extends Resource

enum Phase {
	EARLY,
	MID,
	LATE,
	FINAL,
	FINISH,
}

# @export var skill_act_points: Array[float] = [0.25, 0.5, 0.75, 1.0,]
@export var phases: Dictionary[Phase, float] = {
	Phase.EARLY: 0.2,
	Phase.MID: 0.3,
	Phase.LATE: 0.6,
	Phase.FINAL: 0.9,
}

func get_current_phase(horsey: Horsey, reset_on_lap: bool = false) -> RaceInfo.Phase:
	var progress := horsey.total_progress
	if reset_on_lap:
		progress = horsey.progress_ratio

	if progress < phases[RaceInfo.Phase.EARLY]:
		return RaceInfo.Phase.EARLY
	if progress < phases[RaceInfo.Phase.MID]:
		return RaceInfo.Phase.MID
	if progress < phases[RaceInfo.Phase.LATE]:
		return RaceInfo.Phase.LATE
	if progress < phases[RaceInfo.Phase.FINAL]:
		return RaceInfo.Phase.FINAL
	return RaceInfo.Phase.FINISH
