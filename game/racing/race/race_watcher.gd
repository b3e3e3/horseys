class_name RaceWatcher extends Node

signal lead_changed(new_lead: Horsey, prev_lead: Horsey)

@export var race: Race


var prev_lead: Horsey = null


func _ready() -> void:
	for i in range(race.horseys.size()):
		var h := race.horseys[i]
		var label := Label.new()
		label.text = "%d. %s: %f" % [i+1, h.display_name, h.total_progress]
		%HorseList.add_child(label)

func _process(_delta: float) -> void:
	await get_tree().create_timer(0.3).timeout
	var horseys := race.get_sorted()

	for i in range(horseys.size()):
		var h := horseys[i]
		var label := %HorseList.get_child(i)
		label.text = "%d. %s: %f" % [i+1, h.display_name, h.total_progress]

	if prev_lead and prev_lead != horseys[0]:
		# var diff := prev_lead.total_progress - horseys[0].total_progress
		lead_changed.emit(horseys[0], prev_lead)

	prev_lead = horseys[0]
