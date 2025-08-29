extends Node2D

@onready var cannonball = preload("res://enemies/cannonball.tscn")
@onready var sprite = $Sprite2D

var time_since_shot = 0
var time_to_shoot = 3

func _physics_process(delta: float) -> void:
    time_since_shot -= delta
    if (time_since_shot <= 0):
        time_since_shot = time_to_shoot
        References.instantiate(cannonball, sprite.global_position)

    # TODO: reuse bullets rather than instantiating each time