extends Control


@onready var web: CefTexture = %Web
@onready var ctx := SchemaEditorContext.new()
@onready var loader: FileLoader = FileLoader.new()


func _ready() -> void:
	web.url = "http://localhost:3000"
	web.load_finished.connect(_on_page_loaded)
	web.ipc_message.connect(_on_message_received)

func _on_page_loaded(url: String, status: int):
	print("Page loaded: ", url)

func _on_message_received(message: String):
	var data = JSON.parse_string(message)
	if not data:
		print("IPC message is not JSON: ", message)
		return

	var response

	match data.get("type"):
		"request_files_in_dir":
			var dir_name = data.get("dir")
			if dir_name:
				response = {
					"type": "files_in_dir",
					"dir": dir_name,
					"data": loader.get_files_in_dir(dir_name),
				}
			
		"request_file_contents":
			var file_name = data.get("file")
			var dir_name = data.get("dir")
			if file_name and dir_name:
				response = {
					"type": "file_contents",
					"dir": dir_name,
					"data": loader.get_file_contents(file_name, dir_name),
				}
		_: pass

	if response:
		web.send_ipc_message(JSON.stringify(response))


func _on_web_console_message(level: int, message: String, source: String, line: int) -> void:
	print(message)
