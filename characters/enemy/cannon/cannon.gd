extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var projectile_comp: ProjectileComponent = $ProjectileComponent

func _ready() -> void:
	if GameState.enemy_is_dead(self):
		queue_free()
		return

	health_component.connect("dead", on_death)
	projectile_comp.start()

func on_death() -> void:
	GameState.add_perma_dead_enemy(self)
	get_tree().get_root().get_node("GameManager").update_save()
	queue_free()
