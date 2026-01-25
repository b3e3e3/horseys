class_name HorseyInfo extends Resource

@export var display_name: String = "Horsey"

@export_category("Stats")
@export var stats: Dictionary[String, Stat] = {
	"speed": CurveStat.new("Speed"),
	"wit": Stat.new("Wit"),
}

@export_category("Skills")
@export var skills: Array[Skill] = []
