class_name BoostStatEffect extends SkillEffect

@export var duration: float = 3.0
# TODO: standardize stat names
@export var stats: Dictionary[String, RandValue]


func activate(_info: RaceInfo, horsey: Horsey):
	for s in stats:
		var val = stats[s].get_value()
		print("Boosting stat %s by %f for duration %s" % [s, val, duration])
		horsey.temporarily_boost_stat(s, val, duration)
