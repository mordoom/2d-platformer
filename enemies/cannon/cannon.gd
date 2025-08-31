extends Node2D

@onready var cannonball = preload("res://enemies/cannon/cannonball.tscn")
@onready var sprite = $Sprite2D

@export var direction: Vector2 = Vector2.RIGHT

var time_since_shot = 0
var time_to_shoot = 3
var bullets: Array[CharacterBody2D]
var bullet_index = 0

func _ready():
    bullets = [
        References.instantiate_deferred(cannonball, sprite.global_position, self),
        References.instantiate_deferred(cannonball, sprite.global_position, self),
        References.instantiate_deferred(cannonball, sprite.global_position, self)
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
    bullet.global_position = sprite.global_position
    bullet.direction = direction
    bullet.in_motion = true
