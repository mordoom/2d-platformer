extends Node

class_name ButtonPromptComponent

@onready var button_prompt: TextureRect = $Label

@export var action = "interact"

func _ready() -> void:
	button_prompt.visible = false
	if button_prompt.texture and button_prompt.texture.has_method("set_path"):
		button_prompt.texture.path = action

func show_prompt() -> void:
	button_prompt.visible = true

func hide_prompt() -> void:
	button_prompt.visible = false
