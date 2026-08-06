extends Node
class_name RaceSimulator

@export var race: Race
@export var simulation_count: int = 1000

var data: Dictionary[Horsey, Dictionary] = {}


func _enter_tree() -> void:
	race.process_mode = Node.PROCESS_MODE_DISABLED

func _ready() -> void:
	await race.ready
	start()

func start() -> void:
	Engine.time_scale = 999999
	race.process_mode = Node.PROCESS_MODE_INHERIT

	for h in race.horseys:
		data[h] = {
			"wins": 0,
			"losses": 0,
			"wl_ratio": 0.0,
			"skill_rate": 0.0,
			"same_place": 0,
			"_last_place": -1,
		}

	var count := 0
	for i in range(simulation_count):
		count = i + 1
		if race.process_mode == Node.PROCESS_MODE_DISABLED:
			break
		await race.finished
		var horseys_sorted := race.get_sorted()

		print("Finished race %s. Winner? %s" % [count, horseys_sorted[0].name])

		for j in range(horseys_sorted.size()):
			var h := horseys_sorted[j]
			if race.get_sorted()[0] == h:
				data[h]["wins"] += 1
			else:
				data[h]["losses"] += 1

			data[h]["wl_ratio"] = float(data[h]["wins"]) / float(data[h]["losses"])
			
			data[h]["skill_rate"] += h.get_skill_activation_rate()
			# print("%s skill rate: %s" % [h.name, data[h]["skill_rate"]])
			
			# print("%s finished %s" % [h.name, j])
			if data[h]["_last_place"] == j:
				data[h]["same_place"] += 1
			data[h]["_last_place"] = j

		race.reset()
		race.start_race()

	for h in race.horseys:
		data[h]["skill_rate"] /= float(count)
		data[h]["same_place"] /= float(count)
	
	print("Finished simulating %s race(s)." % [count])
	post_data()
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
