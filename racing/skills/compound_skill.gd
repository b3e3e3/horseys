class_name CompoundSkill extends Skill

@export_enum("ANY", "ALL") var condition_style: String = "ALL"

@export var conditions: Array[SkillCondition]
@export var effects: Array[SkillEffect]


func activate(info: RaceInfo, horsey: Horsey) -> void:
	for e in effects:
		e.activate(info, horsey)
	super.activate(info, horsey)

func can_activate(info: RaceInfo, horsey: Horsey) -> bool:
	var result := super.can_activate(info, horsey)
	if result == false: return false

	match condition_style:
		"ALL":
			for c in conditions:
				if c.can_activate(info, horsey) == false:
					return false
			result = true
		"ANY":
			for c in conditions:
				if c.can_activate(info, horsey) == true:
					return true
			result = false

	return result
