extends State

class_name DeadState

func on_enter() -> void:
	dead = true
	character.climbing = false
	playback.travel("death")
	SignalBus.emit_signal("character_died", character)
