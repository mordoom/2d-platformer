class_name HealthComponent
extends Node

@export var hurtbox: Hurtbox
@export var max_health = 50
@onready var health: int = max_health:
	get:
		return health
	set(value):
		SignalBus.emit_signal("on_health_changed", owner, value - health)
		if (value > max_health):
			health = max_health
		else:
			health = value

signal dead

func _ready():
	hurtbox.connect("on_hit", on_hit)

func on_hit(damage: int, _knockback_velocity: float, _direction: Vector2, _stun: bool) -> void:
	health -= damage
	if health <= 0:
		emit_signal("dead")
