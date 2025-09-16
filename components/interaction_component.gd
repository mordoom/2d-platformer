extends Node

class_name InteractionComponent

@export var signal_to_emit: String = "on_interacted"

func interact() -> void:
	SignalBus.emit_signal(signal_to_emit, get_parent())
