class_name SchemaEditorContext extends RefCounted

const HORSEYS_DIR: String = "res://data/horseys"
const SKILLS_DIR: String = "res://data/skills"

var horseys: Array = []
var skills: Array = []


func load_horseys():
	var dir := DirAccess.open(HORSEYS_DIR)
	for file in dir.get_files():
		horseys.append(file)

func load_skills():
	var dir := DirAccess.open(SKILLS_DIR)
	for file in dir.get_files():
		skills.append(file)

func load_horsey(file_name: String) -> String:
	var file := FileAccess.open(HORSEYS_DIR + "/" + file_name, FileAccess.READ)
	var text := file.get_as_text()
	file.close()
	return text

func load_skill(file_name: String) -> String:
	var file := FileAccess.open(HORSEYS_DIR + "/" + file_name, FileAccess.READ)
	var text := file.get_as_text()
	file.close()
	return text

func save_horsey(file_name: String) -> String:
	var file := FileAccess.open(HORSEYS_DIR + "/" + file_name, FileAccess.READ)
	var text := file.get_as_text()
	file.close()
	return text

func save_skill(file_name: String, text: String) -> String:
	var file := FileAccess.open(HORSEYS_DIR + "/" + file_name, FileAccess.READ_WRITE)
	file.
	file.close()
	return text

func _init() -> void:
	load_horseys()
	load_skills()

