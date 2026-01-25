class_name CameraHorsey extends Horsey

@export var controller: CameraController

const BASE_FOV = 75.0


func _ready() -> void:
	super._ready()
	if not controller:
		controller = get_child(0)


func process_run(delta: float) -> void:
	stats["speed"].set_value(move_toward(stats["speed"].current_value, controller.horseys[0].stats["speed"].current_value, delta * 10))

	controller.look_at(controller.horseys[0].global_position)
	controller.camera.fov = BASE_FOV + (stats["speed"].current_value / 10)

	anim_counter += delta * stats["speed"].current_value * 20
	progress_ratio = controller.horseys[0].progress_ratio

func inspire() -> void:
	pass
