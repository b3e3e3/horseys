class_name CooldownCondition extends SkillCondition

@export var cooldown_time: int = 30000


func can_activate(skill: Skill, _info: RaceInfo, _horsey: Horsey) -> bool:
    return not skill.has_activated() or Time.get_ticks_msec() - skill.last_activate_time >= cooldown_time