extends MovingEnemy

@onready var damage_area: DamageArea = $AttackArea

@onready var healthbar: BossHealthbar = $BossHealthbar
@onready var damageable: DamageableComponent = $DamageableComponent

func _ready() -> void:
    super._ready()
    damageable.connect("on_hit", on_damageable_hit)

func on_damageable_hit(_node: Node, _damage_taken: int, _direction: Vector2) -> void:
    if (damageable.is_dead()):
        healthbar.dead()
        GameState.add_perma_dead_enemy(self)
        set_collision_layer_value(1, false)
