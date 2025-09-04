extends Node

class_name InteractionComponent

@export var signal_to_emit: String = "on_interacted"
@export var button_prompt_comp: ButtonPromptComponent

func interact() -> void:
	SignalBus.emit_signal(signal_to_emit, get_parent())

func show_prompt() -> void:
	button_prompt_comp.show_prompt()

func hide_prompt() -> void:
	button_prompt_comp.hide_prompt()
