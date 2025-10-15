extends RigidBody2D

@onready var hurtbox: Hurtbox = $Hurtbox
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collisionShape: CollisionShape2D = $CollisionShape2D
@export var hit_force: float = 200

func _on_health_component_dead() -> void:
	hurtbox.set_deferred("monitoring", false)
	hurtbox.set_deferred("monitorable", false)
	var new_shape: Shape2D = null
	collisionShape.set_deferred("shape", new_shape)
	set_deferred("lock_rotation", true)
	set_deferred("freeze", true)
	animatedSprite.play()


func _on_hurtbox_on_hit(_damage: int, _knockback_velocity: float, direction: Vector2, _stun: bool) -> void:
	apply_impulse(hit_force * direction)
