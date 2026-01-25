class_name Race extends Node3D

signal started

@export var info: RaceInfo
@export var race_path: Path3D
@export var ui_node: Control
@export var cameras: Array[CameraController]


# @onready var nametag: Control = preload("res://racing/nametag.tscn").instantiate()


var state: StringName = &"countdown"
var horseys: Array[Horsey] = []

enum Sort {
	PROGRESS,
	LAP_LEADER,
	COMEUP
}

func __sort_by_progress(a: Horsey, b: Horsey):
	return true if a.total_progress > b.total_progress else false

func __sort_by_lap_leader(a: Horsey, b: Horsey):
	return true if a.progress_ratio > b.progress_ratio else false

func __sort_by_comeup(a: Horsey, b: Horsey):
	return true if a.stats["speed"].current_value > b.stats["speed"].current_value else false

func get_sorted(sort_type: Sort = Sort.PROGRESS) -> Array[Horsey]:
	var arr := horseys
	var alg: Callable

	match sort_type:
		Sort.PROGRESS: alg = __sort_by_progress
		Sort.LAP_LEADER: alg = __sort_by_lap_leader
		Sort.COMEUP: alg = __sort_by_comeup

	arr.sort_custom(alg)
	return arr

func get_horseys(ignore_camera: bool = true) -> Array[Horsey]:
	if ignore_camera:
		return horseys.filter(func(horsey):
			return horsey is not CameraHorsey
		)
	return horseys

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for c in race_path.get_children():
		if c is Horsey:
			horseys.append(c)


	# if ui_node:
	# 	ui_node.add_child(nametag)

	# await get_tree().create_timer(3).timeout
	started.emit()
	state = &"running"

	for c in cameras:
		c.camera.clear_current(false)

	cycle_camera()

func cycle_camera():
	var controller := cameras.pop_front() as CameraController
	controller.camera.make_current()
	cameras.push_back(controller)

	await get_tree().create_timer(3).timeout
	cycle_camera()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	horseys.sort_custom(func(a, b):
		if a is CameraHorsey or b is CameraHorsey: return false
		return __sort_by_progress(a, b)
	)

	# nametag.activate(horseys[0])
	# nametag.position = nametag.position.lerp(get_viewport().get_camera_3d().unproject_position(horseys[0].global_position + (Vector3.UP * 2)), delta * 50)

	if state == &"running":
		for h in horseys:
			h.process_run(delta)
