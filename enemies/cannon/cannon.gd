extends StaticBody2D

@onready var cannonball = preload("res://enemies/cannon/cannonball.tscn")
@onready var sprite = $Sprite2D
@onready var damageable = $Damageable

@export var direction: Vector2 = Vector2.RIGHT

var time_since_shot = 0
var time_to_shoot = 3
var bullets: Array[CharacterBody2D]
var bullet_index = 0

var hit_stop_time_scale = 0.1
var hit_stop_duration = 0.2

var default_bullet_pos = Vector2.ZERO

func _ready():
    if GameState.enemy_is_dead(self):
        queue_free()

    damageable.connect("on_hit", on_damageable_hit)
    default_bullet_pos = Vector2(-direction.x * 50, 0)
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

func init_bullet():
    var bullet = bullets[bullet_index]
    bullet.position = default_bullet_pos
    bullet.direction = direction
    bullet.in_motion = true
    bullet.visible = true

func on_damageable_hit(_node: Node, _amount: int, direction: Vector2):
    Engine.time_scale = hit_stop_time_scale
    await get_tree().create_timer(hit_stop_duration * hit_stop_time_scale).timeout
    Engine.time_scale = 1

    if (damageable.is_dead()):
        GameState.add_perma_dead_enemy(self)
        queue_free()
