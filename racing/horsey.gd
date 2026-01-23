class_name Horsey extends PathFollow3D

@onready var race: Race = owner
# @onready var skill_act_points: Array[float] = race.info.skill_act_points
@onready var mesh: Node3D = get_child(0)

@export var current_skill_act_point: int = 0
@export var speed: Stat

@export var skills: Array[Skill] = []


var counter := 0.0

var total_progress: float = 0.0

var current_lap: int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	counter = 0.0

func advance_lap():
	current_lap += 1
	current_skill_act_point = 0
	# DEBUG: reset skills
	for skill in skills:
		skill.reset()
	# print("%s: Lap %d" % [self.name, current_lap])

func process_run(delta: float) -> void:
	# for stat in stats:
	speed.process_stat(delta)

	counter += delta * speed.current_value * 2

	var inc: float = (delta) * speed.current_value
	progress += inc
	total_progress += progress_ratio - total_progress#inc
	# print("%s: Progress %f (%f), %f" % [self.name, progress, progress_ratio, total_progress])

	# if current_skill_act_point < skill_act_points.size() - 1:
	# 	if progress_ratio >= skill_act_points[current_skill_act_point]:
	# 		inspire()
	# 		current_skill_act_point += 1

	if floor(total_progress) > current_lap:
		advance_lap()

	activate_skills()

	position.y = sin(counter) * 0.1 * speed.get_utilization()
	rotation.x = cos(counter) * 0.2 * speed.get_utilization()
	# rotation.y = sin(counter) * 0.1 * speed.get_utilization()
	rotation.z = sin(counter) * 0.1 * speed.get_utilization()

func inspire() -> void:
	print("Inspired")
	speed.boost_value = randf_range(0.5, 3.0)

func activate_skills() -> void:
	for skill in skills:
		if skill.can_activate(race.info, self):
			print(self.name, " activated skill ", skill.display_name)
			skill.activate(race.info, self)
