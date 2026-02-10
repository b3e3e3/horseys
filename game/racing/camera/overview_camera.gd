extends CameraController


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not horseys or horseys.is_empty(): return
	var horsey := horseys[0]
	look_at_horsey(horsey, delta * 10)

	if camera.current:
		camera.fov = lerpf(camera.fov, 5, delta * 2)
	else:
		camera.fov = 50.0
