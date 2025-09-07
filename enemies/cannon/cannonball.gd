extends Area2D

@export var damage_area: DamageArea
@export var speed: float = -200

var direction: Vector2 = Vector2.LEFT
var in_motion: bool = false
var default_pos: Vector2

func _ready() -> void:
	visible = false
	default_pos = global_position

func _physics_process(delta: float) -> void:
	if not in_motion:
		return

	position += speed * direction * delta

	if (global_position.x <= 0):
		reset()

func shoot(_direction: Vector2) -> void:
	direction = _direction
	in_motion = true
	visible = true
	damage_area.monitoring = true

func reset() -> void:
	in_motion = false
	visible = false
	global_position = default_pos
	damage_area.monitoring = false
