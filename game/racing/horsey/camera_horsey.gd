class_name CameraHorsey extends Horsey

const BASE_FOV = 75.0

@export var controller: CameraController

var target_pos = null


func _ready() -> void:
	super._ready()
	if not controller:
		controller = get_child(0)


func process_run(delta: float) -> void:
	if target_pos == null:
		target_pos = controller.horseys[0].global_position
	# stats["speed"].set_value(move_toward(stats["speed"].current_value, controller.horseys[0].stats["speed"].current_value, delta * 10))
	stats["speed"].target_value = controller.horseys[0].stats["speed"].get_value()

	target_pos = target_pos.lerp(controller.horseys[0].global_position, delta * 10)
	controller.look_at(target_pos)
	controller.camera.fov = BASE_FOV + (stats["speed"].get_value() / 10)

	anim_counter += delta * stats["speed"].get_value() * 20
	progress_ratio = controller.horseys[0].progress_ratio
