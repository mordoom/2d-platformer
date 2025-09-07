extends Area2D

@export var damage_area: DamageArea
@export var speed: float = 200

var in_motion: bool = false

func _ready() -> void:
	visible = false

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
	damage_area.monitoring = false

func _on_hitbox_on_damage_area_hit() -> void:
	reset()
