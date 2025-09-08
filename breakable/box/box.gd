extends RigidBody2D

@onready var damageable: DamageableComponent = $DamageableComponent
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collisionShape: CollisionShape2D = $CollisionShape2D
@export var hit_force: float = 100

func _ready() -> void:
	damageable.connect("on_hit", on_damageable_hit)

func on_damageable_hit(_node: Node, _amount: int, direction: Vector2) -> void:
	apply_impulse(hit_force * direction)
	if damageable.is_dead():
		var new_shape: Shape2D = null
		collisionShape.set_deferred("shape", new_shape)
		set_deferred("lock_rotation", true)
		set_deferred("freeze", true)
		animatedSprite.play()
