extends StaticBody2D

@onready var cannonball: PackedScene = preload("res://enemies/cannon/cannonball.tscn")
@onready var sprite: Sprite2D = $Sprite2D
@onready var damageable: Damageable = $Damageable

@export var direction: Vector2 = Vector2.RIGHT

var time_since_shot: float = 0
var time_to_shoot: float = 3
var bullets: Array[CharacterBody2D]
var bullet_index: int = 0

var hit_stop_time_scale: float = 0.1
var hit_stop_duration: float = 0.2

var default_bullet_pos: Vector2 = Vector2(-35, 0)

func _ready() -> void:
    if GameState.enemy_is_dead(self):
        queue_free()

    damageable.connect("on_hit", on_damageable_hit)
    bullets = [
        References.instantiate_deferred(cannonball, self, default_bullet_pos),
        References.instantiate_deferred(cannonball, self, default_bullet_pos),
        References.instantiate_deferred(cannonball, self, default_bullet_pos)
    ]

func _physics_process(delta: float) -> void:
    time_since_shot -= delta
    if (time_since_shot <= 0):
        time_since_shot = time_to_shoot
        init_bullet()
        bullet_index += 1
        if (bullet_index >= bullets.size()):
            bullet_index = 0

func init_bullet() -> void:
    var bullet: CharacterBody2D = bullets[bullet_index]
    bullet.position = default_bullet_pos
    bullet.direction = direction
    bullet.in_motion = true
    bullet.visible = true

func on_damageable_hit(_node: Node, _amount: int, _direction: Vector2) -> void:
    Engine.time_scale = hit_stop_time_scale
    await get_tree().create_timer(hit_stop_duration * hit_stop_time_scale).timeout
    Engine.time_scale = 1

    if (damageable.is_dead()):
        GameState.add_perma_dead_enemy(self)
        queue_free()
