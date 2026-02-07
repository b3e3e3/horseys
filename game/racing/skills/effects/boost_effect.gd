class_name BoostEffect extends SkillEffect

# TODO: standardize stat names
@export var stats: Dictionary[String, RandValue]

func activate(_info: RaceInfo, horsey: Horsey):
	for s in stats:
		horsey.boost_stat(s, stats[s].get_value())
