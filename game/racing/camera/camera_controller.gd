class_name CameraController extends Node3D

@onready var race: Race = owner
var horseys: Array[Horsey]

@export var sort_type: Race.Sort = Race.Sort.PROGRESS
@export var camera: Camera3D


func _ready() -> void:
	race.started.connect(_on_race_started)
	if not camera:
		camera = $Camera3D

func _on_race_started() -> void:
	horseys = race.get_sorted(sort_type)

func look_at_horsey(horsey: Horsey, delta: float):
	var target_position := horsey.global_position
	var direction: Vector3 = global_position.direction_to(target_position)

	var target: Basis = Basis.looking_at(direction).get_rotation_quaternion()
	basis = basis.slerp(target, delta)