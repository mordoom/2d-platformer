extends State

class_name DeadState

@export var hit_box: CollisionShape2D

func on_enter():
    playback.travel("death")

func state_physics_process(_delta):
    player.move_and_slide()