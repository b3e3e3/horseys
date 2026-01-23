class_name Skill extends Resource

@export var display_name: String

enum Status {
	IDLE,
	ACTIVE,
}
var current_status: Status = Status.IDLE

func activate(_info: RaceInfo, _horsey: Horsey) -> void:
	current_status = Status.ACTIVE

func can_activate(_info: RaceInfo, _horsey: Horsey) -> bool:
	return current_status != Status.ACTIVE

func reset() -> void:
	current_status = Status.IDLE
