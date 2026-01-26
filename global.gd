extends Node


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

func resolve_schema_ref(schema: Dictionary, node: Dictionary) -> Dictionary:
	if not node.has("$ref"): return node

	var path = node["$ref"].trim_prefix("#/").split("/")
	var target = schema
	for p in path:
		target = target[p]

	return target