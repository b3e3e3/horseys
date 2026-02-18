class_name FileLoader extends RefCounted

signal file_loaded(contents: String, dir_name: String)
signal dir_loaded(files: Array[String], dir_name: String)

const base_dir := "res://data"


func get_files_in_dir(dir_name: String) -> Array[String]:
	var dir := DirAccess.open("%s/%s" % [base_dir, dir_name])
	var files: Array[String]
	files.assign(dir.get_files())
	dir_loaded.emit(files, dir_name)

	return files

func get_file_contents(file_name: String, dir_name: String) -> String:
	var file := FileAccess.open("%s/%s/%s" % [base_dir, dir_name, file_name], FileAccess.READ)
	var contents := file.get_as_text()

	file_loaded.emit(contents, dir_name)

	return contents
