extends StaticBody2D

@onready var cannonball = preload("res://enemies/cannon/cannonball.tscn")
@onready var sprite = $Sprite2D
@onready var damageable = $Damageable
@onready var unique_key: String = get_parent().scene_file_path + str(self.get_path())

@export var direction: Vector2 = Vector2.RIGHT

var time_since_shot = 0
var time_to_shoot = 3
var bullets: Array[CharacterBody2D]
var bullet_index = 0

var hit_stop_time_scale = 0.1
var hit_stop_duration = 0.2

func _ready():
    if GameState.enemy_is_dead(unique_key):
        queue_free()

    damageable.connect("on_hit", on_damageable_hit)
    bullets = [
        References.instantiate_deferred(cannonball, self),
        References.instantiate_deferred(cannonball, self),
        References.instantiate_deferred(cannonball, self)
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
    bullet.position = Vector2.ZERO
    bullet.direction = direction
    bullet.in_motion = true
    bullet.visible = true

func on_damageable_hit(_node: Node, _amount: int, direction: Vector2):
    Engine.time_scale = hit_stop_time_scale
    await get_tree().create_timer(hit_stop_duration * hit_stop_time_scale).timeout
    Engine.time_scale = 1

    if (damageable.is_dead()):
        GameState.dead_enemies.append(unique_key)
        queue_free()
