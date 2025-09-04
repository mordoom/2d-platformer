extends Node

class_name ButtonPromptComponent

@onready var button_prompt: TextureRect = get_parent().get_node("Label")

@export var action = "interact"

func _ready() -> void:
	button_prompt.visible = false
	button_prompt.texture.path = action

func show_prompt() -> void:
	button_prompt.visible = true

func hide_prompt() -> void:
	button_prompt.visible = false
