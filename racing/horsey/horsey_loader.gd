@tool
class_name HorseyLoader extends RefCounted

const DEFAULT_SKILL_DIR_PATH: String = "res://data/skills/"
const DEFAULT_HORSEY_DIR_PATH: String = "res://data/horseys/"


func load_json_file(path: String) -> Dictionary:
	print("Loading horsey JSON file...")
	assert(FileAccess.file_exists(path), "Could not find JSON file at %s" % path)

	var file = FileAccess.open(path, FileAccess.READ)
	assert(FileAccess.get_open_error() == OK, "Could not open JSON file at %s" % path)

	print("Parsing...")
	var parse_result = JSON.parse_string(file.get_as_text())
	file.close()

	assert(parse_result, "Could not parse JSON file at %s" % path)

	return parse_result


func load_horsey_from_JSON(horsey_id: String, path: String = DEFAULT_HORSEY_DIR_PATH) -> HorseyInfo:
	var full_path := "%s%s.json" % [path, horsey_id]
	var data := load_json_file(full_path)

	print("Matching version...")
	match int(data.get("version", 1)):
		1:
			return load_horsey_from_JSON_v1(
				data
			)
		_: print("Version %s not found." % data.get("version"))

	return null

func load_skill_from_JSON(skill_id: String, path: String = DEFAULT_SKILL_DIR_PATH) -> Skill:
	var full_path := "%s%s.json" % [path, skill_id]
	var data := load_json_file(full_path)

	match int(data.get("version", 1)):
		1:
			return load_skill_from_JSON_v1(
				data
			)

	return null

func load_horsey_from_JSON_v1(data: Dictionary) -> HorseyInfo:
	var horsey := HorseyInfo.new()
	
	horsey.display_name = data.get("name", "Wild Horse")
	if data.has("scene"):
		horsey.scene = load(data.get("scene"))

	print("Importing horse %s" % horsey.display_name)

	var stats: Dictionary = data.get("stats", {})
	for s in horsey.stats.keys():
		if not stats.has(s): continue
		print("Setting stat %s to %s" % [s, stats[s]])
		horsey.stats[s].base_value = stats[s]

	var skills: Array = data.get("skills", [])
	for s in skills:
		horsey.skills.append(load_skill_from_JSON(s))

	return horsey

func load_skill_from_JSON_v1(data: Dictionary) -> Skill:
	var skill := CompoundSkill.new()
	skill.display_name = data.get("name", "Mysterious Skill")
	skill.wit_effectiveness = data.get("wit_effectiveness", skill.wit_effectiveness)
	print("Importing skill %s" % skill.display_name)

	var conditions: Dictionary = data.get("conditions", {})
	for c in conditions.keys():
		var cdata = conditions[c]
		match c:
			"phase":
				print("Found phase condition")
				var condition := PhaseCondition.new(RaceInfo.Phase.get(cdata))
				skill.conditions.append(condition)

	var effects: Dictionary = data.get("effects", {})
	
	for e in effects.keys():
		var edata = effects[e]
		
		match e:
			"boost":
				assert(edata is Dictionary)
				print("Found boost effect")
				var effect := BoostEffect.new()
				for s in edata.keys():
					# print("Found stat %s (%s)" % [s, effect.stats[s]])
					var stat = edata[s]
					var value: StatValue
					if stat is Dictionary:
						value = RandValue.new()
						value.min_value = stat["min"]
						value.max_value = stat["max"]
					else:
						# TODO: single value class
						value = RandValue.new()
						value.min_value = stat
						value.max_value = stat
					effect.stats[s] = value
				skill.effects.append(effect)
			"print":
				print("Print test: %s" % edata)
	return skill
