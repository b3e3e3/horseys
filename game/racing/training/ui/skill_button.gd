extends TextureButton

enum ButtonState {
	IDLE,
	HOVER,
	PRESSED,
}

@export var skill: Skill

var current_offset_top: float = 0
var current_size_offset: float = 0



var state: ButtonState = ButtonState.IDLE

@onready var base_size: Vector2 = self.size


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	# pressed.connect(_on_pressed)

	button_up.connect(_on_button_up)
	button_down.connect(_on_button_down)

func _on_mouse_entered() -> void:
	state = ButtonState.HOVER
	# current_offset_top = 10

func _on_mouse_exited() -> void:
	if state == ButtonState.HOVER:
		state = ButtonState.IDLE
	# current_offset_top = 0

# func _on_pressed() -> void:
	# print("Clicked %s" % name)

func _process(delta: float) -> void:
	offset_top = lerp(offset_top, -current_offset_top, delta * 30)
	scale = lerp(scale, Vector2.ONE + Vector2.ONE * current_size_offset, delta * 30)
	
	match state:
		ButtonState.IDLE:
			current_size_offset = 0
			current_offset_top = 0
		ButtonState.HOVER:
			current_offset_top = 10
			current_size_offset = 0
		ButtonState.PRESSED:
			current_offset_top = 10
			current_size_offset = 0.15

func _on_button_up() -> void:
	state = ButtonState.IDLE
	# current_size_offset = 0
	# current_offset_top = 0

func _on_button_down() -> void:
	state = ButtonState.PRESSED
	# current_size_offset = 0.15
	# current_offset_top = 10
