class_name HorseyLoader extends RefCounted

const DEFAULT_SKILL_DIR_PATH: String = "res://data/skills/"
const DEFAULT_HORSEY_DIR_PATH: String = "res://data/horseys/"


func load_horsey(horsey_id: String, path: String = DEFAULT_HORSEY_DIR_PATH) -> HorseyInfo:
	var full_path := "%s%s.json" % [path, horsey_id]
	var data := Global.load_json_file(full_path)

	print("Matching version...")
	match int(data.get("version", 1)):
		1:
			return parse_horsey_from_JSON_v1(
				data
			)
		_: print("Version %s not found." % data.get("version"))

	return null

func load_skill(skill_id: String, path: String = DEFAULT_SKILL_DIR_PATH) -> Skill:
	var full_path := "%s%s.json" % [path, skill_id]
	var data := Global.load_json_file(full_path)

	match int(data.get("version", 1)):
		1:
			return parse_skill_from_JSON_v1(
				data
			)

	return null

func parse_horsey_from_JSON_v1(data: Dictionary) -> HorseyInfo:
	var horsey := HorseyInfo.new()

	# load basic data
	horsey.display_name = data.get("name", "Wild Horse")

	print("Importing horse %s" % horsey.display_name)

	# load stats
	var stats: Dictionary = data.get("stats", {})
	for s in horsey.stats.keys():
		if not stats.has(s): continue
		horsey.stats[s].base_value = stats[s]
		print("Setting stat %s to %s" % [s, horsey.stats[s].base_value])

	# load skills
	var skills: Array = data.get("skills", [])
	for s in skills:
		# horsey.skills.append(load_skill(s))
		horsey.skills.append(load_skill(s))

	# load scene
	if data.has("scene"):
		horsey.scene = load(data.get("scene"))

	return horsey

func parse_skill_from_JSON_v1(data: Dictionary) -> Skill:
	var skill := CompoundSkill.new()

	# load basic data
	skill.display_name = data.get("name", "Mysterious Skill")
	skill.bp_effectiveness = data.get("bp_effectiveness", skill.bp_effectiveness)
	
	print("Importing skill %s" % skill.display_name)

	# load conditions
	var conditions: Array = data.get("conditions", [])
	for c in conditions:
		match c.get("condition_type"):
			"PHASE":
				print("Found phase condition")
				var condition := PhaseCondition.new(RaceInfo.Phase.get(c.get("phase")))
				skill.conditions.append(condition)
			"ANY_PHASE":
				print("Found any phase condition")
				var phases: Array = c.get("phases", [])
				var any := AnyCondition.new()

				for p in phases:
					var condition := PhaseCondition.new(RaceInfo.Phase.get(p))
					any.conditions.append(condition)
				
				skill.conditions.append(any)
			# TODO: PProximity type
			_:
				print("Didn't find a condition type match for %s" % c.get("condition_type", "unknown!"))

	# load effects
	var effects: Array = data.get("effects", [])
	for e in effects:
		match e.get("effect_type"):
			"STAT_BOOST":
				print("Found boost effect")
				var effect := BoostEffect.new()
				
				var value := RandValue.new()
				value.min_value = e.get("min")
				value.max_value = e.get("max", value.min_value)

				var stat_name = e.get("stat", "unknown!")
				effect.stats[stat_name] = value

				skill.effects.append(effect)
			"PRINT":
				print("Print test: %s" % e.get("message", "unknown!"))
			_:
				print("Didn't find an effect type match for %s" % e.get("effect_type", "unknown!"))
	
	return skill
