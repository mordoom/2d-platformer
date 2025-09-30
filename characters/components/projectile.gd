extends Area2D

@export var hitbox: Hitbox
@export var speed: float = 200
@export var apply_gravity: bool = false
@export var floor_check: RayCast2D

var in_motion: bool = false
var gravity_const: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	visible = false
	hitbox.connect("hit", _on_hitbox_on_damage_area_hit)

func _physics_process(delta: float) -> void:
	if not in_motion:
		return

	position += speed * transform.x * delta

	if apply_gravity and not floor_check.is_colliding():
		position.y += gravity_const * delta

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

func _on_body_entered(body: Node2D) -> void:
	reset()
