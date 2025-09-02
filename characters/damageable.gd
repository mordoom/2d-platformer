extends Node

class_name Damageable

signal on_hit(node: Node, damage_taken: int, direction: Vector2)

var max_health = GameConstants.DEFAULT_HEALTH

@export var health = GameConstants.DEFAULT_HEALTH:
	get:
		return health
	set(value):
		SignalBus.emit_signal("on_health_changed", get_parent(), value - health)
		if (value > max_health):
			health = max_health
		else:
			health = value

func hit(damage: int, direction: Vector2):
	if health > 0:
		health -= damage
		emit_signal("on_hit", get_parent(), damage, direction)
	else:
		print_debug(get_parent().name + " died")

func is_dead() -> bool:
	return health <= 0
