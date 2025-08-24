extends State

class_name DeadState

func on_enter():
    dead = true
    playback.travel("death")
    SignalBus.emit_signal("character_died", character)
