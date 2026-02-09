class_name CooldownCondition extends SkillCondition

@export var cooldown_time: int = 30000


func _init(time: int) -> void:
    cooldown_time = time

func can_activate(skill: Skill, _info: RaceInfo, horsey: Horsey) -> bool:
    var cooldown_finished = Time.get_ticks_msec() - skill.last_activate_time >= cooldown_time
    if cooldown_finished:
        skill.current_status = Skill.Status.IDLE
        # horsey.get_tree().create_timer(cooldown_time / 1000.0).timeout.connect(func():
        #     skill.current_status = Skill.Status.IDLE
        # , CONNECT_ONE_SHOT)
    #     print("%dms Cooldown finished" % cooldown_time)
    return cooldown_finished # and not skill.has_activated()