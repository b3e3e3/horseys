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
