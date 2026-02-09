class_name AnyCondition extends SkillCondition

@export var conditions: Array[SkillCondition]


func can_activate(skill: Skill, info: RaceInfo, horsey: Horsey) -> bool:
	# var result := super.can_activate(skill, info, horsey)
	# if result == false: return false
	for c in conditions:
		if c.can_activate(skill, info, horsey) == true:
			print("ANY CONDITION ACTIVATING ON PHASE %s(%d)! %s" % [RaceInfo.Phase.find_key(c.phase), c.phase, info.get_current_phase(horsey)])
			return true

	return false # result