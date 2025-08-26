extends StaticBody2D

@onready var damageable: Damageable = $Damageable

func _ready() -> void:
	damageable.connect("on_hit", on_damageable_hit)

func on_damageable_hit(_node: Node, _amount: int, direction: Vector2):
	if damageable.is_dead():
		queue_free()
