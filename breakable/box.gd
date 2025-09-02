extends RigidBody2D

@onready var damageable: Damageable = $Damageable
@onready var animatedSprite = $AnimatedSprite2D
@onready var collisionShape = $CollisionShape2D
@export var hit_force = 100

func _ready() -> void:
    damageable.connect("on_hit", on_damageable_hit)

func on_damageable_hit(_node: Node, _amount: int, direction: Vector2):
    apply_impulse(hit_force * direction)
    if damageable.is_dead():
        var new_shape = null
        collisionShape.set_deferred("shape", new_shape)
        set_deferred("lock_rotation", true)
        set_deferred("freeze", true)
        animatedSprite.play()
