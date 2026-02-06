extends Node3D

@onready var loader := HorseyLoader.new()


func _ready() -> void:
	var horsey := loader.load_horsey("orange_horsey")
	print("===========\nLoaded %s")
	print("Name: %s" % horsey.display_name)
	print("Stats:")
	for s: Stat in horsey.stats.values():
		print("	%s" % s)

	print("Skills:")
	for s in horsey.skills:
		print("	%s" % s.display_name)
