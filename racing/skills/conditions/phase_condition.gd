class_name PhaseCondition extends SkillCondition

const DEBUG_reset_on_lap: bool = true

# @export var phases: Array[RaceInfo.Phase]
# @export_enum("ALL", "ANY") var condition: String = "ALL"
@export var phase: RaceInfo.Phase = RaceInfo.Phase.EARLY



func _init(phase_condition: RaceInfo.Phase = RaceInfo.Phase.EARLY):
	self.phase = phase_condition

func can_activate(info: RaceInfo, horsey: Horsey) -> bool:
	# var result := false
	# match condition:
	# 	"ALL":
	# 		for p in phases:
	# 			if info.get_current_phase(horsey) != p:
	# 				return false
	# 		result = true
	# 	"ANY":
	# 		for p in phases:
	# 			if info.get_current_phase(horsey) == p:
	# 				return true
	# 		result = false

	# return result

	return info.get_current_phase(horsey, DEBUG_reset_on_lap) == phase
