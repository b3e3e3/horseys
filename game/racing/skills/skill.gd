class_name Skill extends Resource

enum Status {
	IDLE,
	ACTIVE,
}

@export var display_name: String
@export_range(0.0, 1.0, 0.05) var wit_effectiveness: float = 1.0

var current_status: Status = Status.IDLE


func activate(_info: RaceInfo, _horsey: Horsey) -> void:
	current_status = Status.ACTIVE

func can_activate(_info: RaceInfo, horsey: Horsey) -> bool:
	return current_status != Status.ACTIVE \
	and randf() < minf(wit_effectiveness * horsey.stats["wit"].current_value, 1.0)

func reset() -> void:
	current_status = Status.IDLE
