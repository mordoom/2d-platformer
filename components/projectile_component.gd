class_name ProjectileComponent
extends Node2D

@export var bullet_scene: PackedScene = References.cannonball
@export var shoot_time: float = 2

@onready var shoot_timer: Timer = $ShootTimer
@onready var projectile_aim: Marker2D = $Marker2D

var bullets: Array[Area2D]
var bullet_index: int = 0

func _ready():
    bullets = [
        References.instantiate_deferred(bullet_scene, owner.get_parent(), projectile_aim.global_position),
        References.instantiate_deferred(bullet_scene, owner.get_parent(), projectile_aim.global_position),
        References.instantiate_deferred(bullet_scene, owner.get_parent(), projectile_aim.global_position)
    ]

    shoot_timer.wait_time = shoot_time
    shoot_timer.timeout.connect(shoot)

func start() -> void:
    if shoot_timer.is_stopped():
        shoot_timer.start()

func stop() -> void:
    shoot_timer.stop()

func shoot() -> void:
    shoot_bullet()
    shoot_timer.start()

func shoot_bullet() -> void:
    var bullet: Area2D = bullets[bullet_index]
    bullet.shoot(projectile_aim.global_transform)
    bullet_index += 1
    if (bullet_index >= bullets.size()):
        bullet_index = 0

func flip(current_direction: float) -> void:
    if current_direction < 0:
        position.x = abs(position.x) * -1
        transform.x = abs(transform.x) * -1
    elif current_direction > 0:
        position.x = abs(position.x)
        transform.x = abs(transform.x)