class_name RaceWatcher extends Node

signal lead_changed(new_lead: Horsey, prev_lead: Horsey)

@export var race: Race

var prev_lead: Horsey = null

@onready var tracker_label := Label.new()


func update_text(horseys: Array[Horsey]) -> void:
	tracker_label.text = ""
	for i in range(horseys.size()):
		var h := horseys[i]
		if h is CameraHorsey: continue
		tracker_label.text += "%d. %s: %f" % [i + 1, h.display_name, h.total_progress]
		tracker_label.text += " | %s | %s" % [h.stats["speed"], h.stats["stamina"]]
		tracker_label.text += "\n"

func _ready() -> void:
	update_text(race.horseys)
	%HorseList.add_child(tracker_label)

func _process(_delta: float) -> void:
	await get_tree().create_timer(0.3).timeout
	var horseys := race.get_sorted()
	update_text(horseys)

	if prev_lead and prev_lead != horseys[0]:
		# var diff := prev_lead.total_progress - horseys[0].total_progress
		lead_changed.emit(horseys[0], prev_lead)

	prev_lead = horseys[0]
