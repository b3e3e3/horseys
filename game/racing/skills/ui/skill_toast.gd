extends Control

@export var follow_target: Node3D
@export var offset: Vector2 = Vector2(130, -100)

@export var icon_texture: Texture2D
@export var color: Color

var panel_texture: GradientTexture2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	# panel_texture = (self as Panel).theme.set_type_variation()

func activate() -> void:
	visible = true
	await get_tree().create_timer(2.0).timeout
	visible = false

func _physics_process(delta: float) -> void:
	if follow_target:
		var cam := get_viewport().get_camera_3d()
		if cam:
			var pos := cam.unproject_position(follow_target.global_position)
			position = position.lerp(pos + offset, delta * 5)


func _on_horsey_skill_activated(skill: Skill) -> void:
	%TitleLabel.text = skill.display_name
	activate()
