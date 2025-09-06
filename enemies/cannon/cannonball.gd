extends CharacterBody2D

@export var speed: float = -200

var direction: Vector2 = Vector2.LEFT
var in_motion: bool = false
var default_pos: Vector2

func _ready() -> void:
	visible = false
	default_pos = global_position

func _physics_process(_delta: float) -> void:
	if not in_motion:
		return

	velocity = speed * direction

	move_and_slide()

	if (global_position.x <= 0):
		reset()

func reset() -> void:
	in_motion = false
	visible = false
	global_position = default_pos