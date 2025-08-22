extends State

class_name DeadState

func on_enter():
    playback.travel("death")

# func state_physics_process(_delta):
#     player.move_and_slide()