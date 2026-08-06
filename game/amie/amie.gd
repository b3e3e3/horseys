extends Node3D


var _viewport: Viewport
@onready var head: BoneAttachment3D = $"Uranium Johnson/RiggedLores/metarig/Skeleton3D/HeadAttachment"

@export var max_influence_distance := 5.0
@export var break_distance := 10.0
@export var influence_strength := 1.0 # you can tweak this dynamically

func _process(delta):
    var camera = get_viewport().get_camera_3d()
    var mouse_pos = get_viewport().get_mouse_position()

    # Raycast from camera through mouse
    var from = camera.project_ray_origin(mouse_pos)
    var dir = camera.project_ray_normal(mouse_pos)

    var target_pos = from + dir * 10.0 # arbitrary distance forward

    # Distance from head to mouse ray point
    var dist = head.global_position.distance_to(target_pos)

    # Normalize influence (1 near, 0 far)
    var t = clamp(1.0 - (dist / max_influence_distance), 0.0, 1.0)

    # Hard cutoff (break effect)
    if dist > break_distance:
        t = 0.0

    # Apply extra control
    t *= influence_strength

    # Get look rotation
    var desired = head.global_transform.looking_at(target_pos, Vector3.UP).basis

    # Blend between current and desired
    var new_basis = head.global_transform.basis.slerp(desired, t)

    global_transform.basis = new_basis