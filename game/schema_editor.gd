extends Control


@onready var web: WebView = %WebView
@onready var context := SchemaEditorContext.new()


func _ready() -> void:

	web.set_context_ref("ctx", context)
	web.console_log.connect(console_log)

func console_log(level: int, message: String, lineNumber: int, sourceID: String):
	print(message)
