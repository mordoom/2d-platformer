extends AnimatableBody2D

var moving := false
var speed := 50

func _ready():
    SignalBus.connect("on_sloop_start", on_sloop_start)

func _physics_process(delta):
    if moving:
        position.x += speed * delta

func on_sloop_start(_area: Area2D):
    Dialogic.start_timeline("sloop repair")