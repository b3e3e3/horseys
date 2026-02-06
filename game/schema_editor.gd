extends Control


@onready var web: WebView = %WebView
@onready var ctx := SchemaEditorContext.new()
@onready var loader: FileLoader = FileLoader.new()


func _ready() -> void:
	web.set_context_ref("ctx", ctx)
	web.set_context_ref("loader", loader)
	web.console_log.connect(console_log)

func console_log(level: int, message: String, lineNumber: int, sourceID: String):
	print(message)
