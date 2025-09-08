extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var damageable: Damageable = $Damageable
@onready var projectile_comp: ProjectileComponent = $ProjectileComponent

var hit_stop_time_scale: float = 0.1
var hit_stop_duration: float = 0.2

func _ready() -> void:
	if GameState.enemy_is_dead(self):
		queue_free()
		return

	damageable.connect("on_hit", on_damageable_hit)
	projectile_comp.start()

func on_damageable_hit(_node: Node, _amount: int, _direction: Vector2) -> void:
	Engine.time_scale = hit_stop_time_scale
	await get_tree().create_timer(hit_stop_duration * hit_stop_time_scale).timeout
	Engine.time_scale = 1

	if (damageable.is_dead()):
		GameState.add_perma_dead_enemy(self)
		queue_free()
