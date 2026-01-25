extends CameraController


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if camera.current:
		look_at(horseys[0].global_position)
		camera.fov = lerpf(camera.fov, 5, delta * 2)
	else:
		camera.fov = 50.0
