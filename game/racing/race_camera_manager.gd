extends Node

@export var cameras: Array[CameraController]


func cycle_camera(repeat: bool = false):
	var controller := cameras.pop_front() as CameraController
	if not controller: return
	
	controller.camera.make_current()
	cameras.push_back(controller)

	if repeat:
		await get_tree().create_timer(3).timeout
		cycle_camera(repeat)

func _on_race_started() -> void:
	for c in cameras:
		c.camera.clear_current(false)
	
	cycle_camera(true)
