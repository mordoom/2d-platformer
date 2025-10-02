extends AnimatableBody2D

var moving := false
@export var speed := 50
@export var collision_shape: StaticBody2D

func _ready():
    SignalBus.connect("on_sloop_start", on_sloop_start)

func _physics_process(delta):
    if moving:
        position.x += speed * delta

func on_sloop_start(_area: Area2D):
    if GameState.env_is_changed("res://world/beach/starting_beach2.tscn/root/GameManager/StartingBeach/Tnt"):
        moving = true
        collision_shape.set_collision_layer_value(1, false)
    else:
        Dialogic.start_timeline("sloop repair")