class_name AnyCondition extends SkillCondition

@export var conditions: Array[SkillCondition]


func can_activate(skill: Skill, info: RaceInfo, horsey: Horsey) -> bool:
	var result := super.can_activate(skill, info, horsey)
	if result == false: return false

	for c in conditions:
		if c.can_activate(skill, info, horsey) == true:
			return true
	result = false

	return result