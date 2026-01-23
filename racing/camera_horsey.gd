class_name CameraHorsey extends Horsey

@export var controller: CameraController

const BASE_FOV = 75.0


func _ready() -> void:
	super._ready()
	if not controller:
		controller = get_child(0)


func process_run(delta: float) -> void:
	speed.set_value(move_toward(speed.current_value, controller.horseys[0].speed.current_value, delta * 10))

	controller.look_at(controller.horseys[0].global_position)
	controller.camera.fov = BASE_FOV + (speed.current_value / 10)

	counter += delta * speed.current_value * 20
	progress_ratio = controller.horseys[0].progress_ratio

func inspire() -> void:
	pass
