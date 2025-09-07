extends Area2D

@export var damage_area: DamageArea
@export var speed: float = 200

var in_motion: bool = false
var default_pos: Vector2

func _ready() -> void:
	visible = false
	default_pos = global_position

func _physics_process(delta: float) -> void:
	if not in_motion:
		return

	var poisiton_increase = speed * transform.x * delta
	position += poisiton_increase

	if global_position.x <= 0:
		reset()

func shoot(_transform: Transform2D) -> void:
	in_motion = true
	visible = true
	damage_area.monitoring = true
	transform = _transform

func reset() -> void:
	in_motion = false
	visible = false
	global_position = default_pos
	damage_area.monitoring = false
