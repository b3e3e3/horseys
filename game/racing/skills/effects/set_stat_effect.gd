class_name SetStatEffect extends SkillEffect

@export var duration: float = 3.0
# TODO: standardize stat names
@export var stats: Dictionary[String, RandValue]

func activate(_info: RaceInfo, horsey: Horsey):
	for s in stats:
		var val = stats[s].get_value()
		print("Setting stat %s to %f" % [s, val])
		# horsey.stats[s].set_driver_value(val)
		horsey.temporarily_set_stat(s, val, duration)
