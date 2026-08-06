extends Node
class_name RaceSimulator

signal finished
signal started

@export var race: Race
@export var simulation_count: int = 1000

var data: Dictionary[Horsey, Dictionary] = {}
var _sims_completed: int = 0


func _enter_tree() -> void:
	race.process_mode = Node.PROCESS_MODE_DISABLED

func _ready() -> void:
	await race.ready
	start()

func _process(delta: float) -> void:
	if %ProgressLabel:
		%ProgressLabel.text = "Simulating... (%d/%d)" % [_sims_completed, simulation_count]
	if %ProgressBar:
		%ProgressBar.max_value = simulation_count
		%ProgressBar.value = _sims_completed

func start() -> void:
	Engine.time_scale = 999999
	race.process_mode = Node.PROCESS_MODE_INHERIT

	for h in race.horseys:
		data[h] = {
			"wins": 0,
			"losses": 0,
			"wl_ratio": 0.0,
			"skill_rate": 0.0,
			"place_dist_pretty": "",
			"_place_dist": [] as Array[int],
		}
		(data[h]["_place_dist"] as Array).resize(race.horseys.size())
	
	started.emit()
	for i in range(simulation_count):
		_sims_completed = i + 1
		if race.process_mode == Node.PROCESS_MODE_DISABLED:
			break
		await race.finished
		var horseys_sorted := race.get_sorted()

		print("Finished race %s. Winner? %s" % [_sims_completed, horseys_sorted[0].name])

		for j in range(horseys_sorted.size()):
			var h := horseys_sorted[j]
			if horseys_sorted[0] == h:
				data[h]["wins"] += 1
			else:
				data[h]["losses"] += 1

			data[h]["wl_ratio"] = float(data[h]["wins"]) / float(data[h]["losses"])
			
			data[h]["skill_rate"] += h.get_skill_activation_rate()
			# print("%s skill rate: %s" % [h.name, data[h]["skill_rate"]])
			data[h]["_place_dist"][j] += 1

			

			var dist_strs: Array[String] = []
			var _place_dist := data[h]["_place_dist"] as Array
			for k in range(_place_dist.size()):
				dist_strs.append("#%d [%d]" % [k + 1, _place_dist[k]])
			
			data[h]["place_dist_pretty"] = ", ".join(dist_strs)
			
			
			# # print("%s finished %s" % [h.name, j])
			# if data[h]["_last_place"] == j:
			# 	data[h]["same_place"] += 1
			# data[h]["_last_place"] = j

		race.reset()
		race.start_race()

	for h in race.horseys:
		data[h]["skill_rate"] /= float(_sims_completed)
		# data[h]["same_place"] /= float(_sims_completed)1
	
	print("Finished simulating %s race(s)." % [_sims_completed])
	post_data()
	finished.emit()
	stop()

func stop() -> void:
	Engine.time_scale = 0.0
	race.process_mode = Node.PROCESS_MODE_DISABLED

func post_data() -> void:
	for h in race.horseys:
		var name_label := Label.new()
		name_label.text = h.name
		%GridContainer.add_child(name_label)

		for k in data[h]:
			if (k as String)[0] == "_":
				continue
			
			var v = data[h][k]
			var label := Label.new()
			label.text = "%s" % v
			%GridContainer.add_child(label)
