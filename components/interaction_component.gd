extends Node

class_name InteractionComponent

@export var signal_to_emit: String = "on_interacted"
@export var global := true
@export var sound_effect: AudioStream

func interact() -> void:
	if global:
		SignalBus.emit_signal(signal_to_emit, get_parent())
	else:
		owner.emit_signal(signal_to_emit)
	
	if sound_effect:
		SoundManager.play_sound(sound_effect)
