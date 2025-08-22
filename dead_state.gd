extends State

class_name DeadState

@export var hit_box: CollisionShape2D

func on_enter():
    playback.travel("death")
    if (hit_box != null):
        hit_box.set_deferred("disabled", true)

