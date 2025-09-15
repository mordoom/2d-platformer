extends Area2D

@export var hitbox: Hitbox
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

func shoot(new_transform: Transform2D) -> void:
	in_motion = true
	visible = true
	hitbox.set_deferred("monitoring", true)
	transform = new_transform

func reset() -> void:
	in_motion = false
	visible = false
	hitbox.set_deferred("monitoring", false)

func _on_hitbox_on_damage_area_hit() -> void:
	reset()
