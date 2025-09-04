extends Node

class_name InteractionComponent

@export var signal_to_emit: String = "on_interacted"

@onready var button_prompt: TextureRect = get_parent().get_node("Label")

func _ready() -> void:
	button_prompt.visible = false

func interact() -> void:
	SignalBus.emit_signal(signal_to_emit, get_parent())

func show_prompt() -> void:
	button_prompt.visible = true

func hide_prompt() -> void:
	button_prompt.visible = false