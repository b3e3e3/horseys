class_name BoostStatEffect extends SkillEffect

# TODO: standardize stat names
@export var stats: Dictionary[String, RandValue]

func activate(_info: RaceInfo, horsey: Horsey):
	for s in stats:
		var val = stats[s].get_value()
		print("Boosting stat %s by %f" % [s, val])
		horsey.temporarily_boost_stat(s, val)
