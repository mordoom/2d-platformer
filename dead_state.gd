extends State

class_name DeadState

func on_enter():
    dead = true
    playback.travel("death")
