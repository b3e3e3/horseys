class_name PhaseCondition extends SkillCondition

@export var phase: RaceInfo.Phase = RaceInfo.Phase.EARLY


func _init(phase_condition: RaceInfo.Phase = RaceInfo.Phase.EARLY):
	self.phase = phase_condition

func can_activate(skill: Skill, info: RaceInfo, horsey: Horsey) -> bool:
	return not skill.has_activated_this_phase(info, horsey) and info.get_current_phase(horsey) == phase
