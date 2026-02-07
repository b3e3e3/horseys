class_name HorseyInfo extends Resource

@export var display_name: String = "Horsey"
@export var scene: PackedScene

@export_category("Stats")
@export var stats: Dictionary[String, Stat] = {
	"speed": load("res://racing/stats/speed_stat.tres").duplicate(),
	"stamina": load("res://racing/stats/stamina_stat.tres").duplicate(),
	"power": CurveStat.new("Power"),
	"resolve": CurveStat.new("Resolve"),
	"brainpower": load("res://racing/stats/brainpower_stat.tres").duplicate(),
}

@export_category("Skills")
@export var skills: Array[Skill] = []
