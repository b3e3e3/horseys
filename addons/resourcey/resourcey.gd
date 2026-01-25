@tool
extends EditorPlugin

var horsey_inspector_plugin: EditorInspectorPlugin


func _enter_tree():
	horsey_inspector_plugin = preload("res://addons/resourcey/horsey_inspector.gd").new()
	add_inspector_plugin(horsey_inspector_plugin)


func _exit_tree():
	remove_inspector_plugin(horsey_inspector_plugin)


func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass
