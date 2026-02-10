class_name Commentators extends Node

@export var subtitles: Label


@export var race: Race
@onready var voice_ids := load_voices()
# @export var tts_engines: Array[TextToSpeech1D]

@export_multiline var stop_short_phrases: Array[String] = []

@export_multiline var lead_changed_phrases: Array[String] = []

@export_multiline var check_in_phrases: Array[String] = []
var check_in_timer: Timer = Timer.new()

var voice: String
# var phrase: String = ""

func _ready():
	check_in_timer.autostart = false
	check_in_timer.wait_time = 4.0
	check_in_timer.timeout.connect(_on_check_in_timer_timeout)
	add_child(check_in_timer)

	subtitles.text = ""

func start():
	check_in_timer.start()


# func _process(_delta: float) -> void:
# 	subtitles.visible = DisplayServer.tts_is_speaking()

func load_voices() -> Array:
	# var arr: PackedStringArray = []
	# var dir = DirAccess.open("res://addons/text_to_speech/tts_engines")
	# if dir:
	# 	dir.list_dir_begin()
	# 	var file_name = dir.get_next()
	# 	while file_name != "":
	# 		if not dir.current_is_dir():
	# 			var ext := ".flitevox.res"
	# 			if file_name.ends_with(ext):
	# 				arr.push_back(file_name.remove_chars(".flitevox.res"))
	# 				print("Found %s" % file_name)
	# 		file_name = dir.get_next()
	# return arr as Array
	return DisplayServer.tts_get_voices_for_language("en") as Array

func is_speaking() -> bool:
	return DisplayServer.tts_is_speaking()

func stop_speaking() -> void:
	DisplayServer.tts_stop()
	# for tts in tts_engines:
	# 	if tts.playing: continue
	# 	tts.stop()

func _on_race_watcher_lead_changed(new_lead: Horsey, prev_lead: Horsey) -> void:
	var phrase := get_phrase(lead_changed_phrases) \
		.replace("{new}", new_lead.display_name) \
		.replace("{prev}", prev_lead.display_name)
	say_phrase(phrase)

func get_phrase(phrases: Array[String]) -> String:
	var lead: Horsey = race.get_horseys().front()
	var last: Horsey = race.get_horseys().back()
	var random: Horsey = null

	while random == null or random == lead:
		random = race.get_horseys().pick_random()

	return phrases.pick_random() \
	.replace("{random}", race.get_horseys().pick_random().display_name) \
	.replace("{lead}", lead.display_name) \
	.replace("{last}", last.display_name)

func say_phrase(phrase: String) -> void:
	voice = (voice_ids as Array).pick_random()

	# var tts: TextToSpeech1D = tts_engines.pick_random()

	if is_speaking():
		stop_speaking()
		phrase = "%s %s" % [stop_short_phrases.pick_random(), phrase]

	DisplayServer.tts_speak(phrase, voice)
	# tts_engines.pick_random().say(phrase, voice)

	subtitles.text = phrase

func _on_check_in_timer_timeout():
	if is_speaking(): return
	var phrase := get_phrase(check_in_phrases)
	say_phrase(phrase)
