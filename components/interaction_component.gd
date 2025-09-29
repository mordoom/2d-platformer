extends Node

class_name InteractionComponent

@export var signal_to_emit: String = "on_interacted"
@export var global := true

func interact() -> void:
	if global:
		SignalBus.emit_signal(signal_to_emit, get_parent())
	else:
		owner.emit_signal(signal_to_emit)
