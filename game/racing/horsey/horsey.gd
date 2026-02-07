class_name Horsey extends PathFollow3D

@onready var race: Race
# @onready var skill_act_points: Array[float] = race.info.skill_act_points
@onready var mesh: Node3D = get_child(0)
@onready var path: Path3D = get_parent()

@export var current_skill_act_point: int = 0

@export var info: HorseyInfo = HorseyInfo.new()

var stats: Dictionary[String, Stat]:
	get:
		return info.stats if info else {}

# @export_category("Skills")
# @export var skills: Array[Skill] = []
var skills: Array[Skill]:
	get:
		return info.skills if info else []

var display_name: String:
	get:
		return info.display_name if info else str(name)


var anim_counter := 0.0

var total_progress: float = 0.0

var current_lap: int = -1

var skill_act_counter: int = 0


func _init(horsey_info: HorseyInfo = info, active_race: Race = race) -> void:
	self.info = horsey_info
	self.race = active_race

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_counter = 0.0

func advance_lap():
	current_lap += 1
	current_skill_act_point = 0
	# DEBUG: reset skills
	for skill in skills:
		skill.reset()
	# print("%s: Lap %d" % [self.name, current_lap])

func boost_stat(stat_name: String, by: Variant, duration: float = 3.0):
	print("Boosting stat %s by %f for %ds" % [stat_name, by, duration])

	stats[stat_name].target_value += by
	await get_tree().create_timer(duration).timeout
	stats[stat_name].target_value -= by

	print("%s boost finished" % stat_name)

func process_stats(delta: float) -> void:
	# var stam_rate = (stats["stamina"].scale - (stats["stamina"].base_value / (stats["stamina"].max_value * 100)))
	# stats["stamina"].stat_travel_rate = delta
	# print((stats["stamina"].base_value / (stats["stamina"].max_value / 2)))
	stats["stamina"].target_value = 0

	if stats["stamina"].get_value() <= 0:
		stats["speed"].target_value = 0

	for stat in stats.values():
		stat.process_stat(delta)
	
	# TODO: custom stat classes with process_stat that handles these
	
	# stats["stamina"].decline_stat(delta) # this is already taken care of by move_towards_target_value in process_stat

func process_run(delta: float) -> void:
	# for stat in stats:
	process_stats(delta)


	var inc: float = stats["speed"].get_value() * delta
	anim_counter += inc * stats["speed"].get_utilization()
	progress += inc
	total_progress += inc / path.curve.get_baked_length()

	# print("%s: Progress %f (%f), %f" % [self.display_name, progress, progress_ratio, total_progress])

	# if current_skill_act_point < skill_act_points.size() - 1:
	# 	if progress_ratio >= skill_act_points[current_skill_act_point]:
	# 		inspire()
	# 		current_skill_act_point += 1

	if floor(total_progress) > current_lap:
		advance_lap()

	activate_skills()

	position.y = sin(anim_counter) * 0.01 * stats["speed"].get_value()
	rotation.x = cos(anim_counter) * 0.01 * stats["speed"].get_value()
	# rotation.y = sin(anim_counter) * 0.1 * stats["speed"].get_value()
	rotation.z = sin(anim_counter) * 0.002 * stats["speed"].get_value()

func activate_skills() -> void:
	skill_act_counter += 1
	if skill_act_counter % 90 != 0:
		return
	
	for skill in skills:
		if skill.can_activate(race.info, self ):
			print(self.display_name, " activated skill ", skill.display_name)
			skill.activate(race.info, self )
