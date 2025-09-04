extends Area2D

class_name Interactable

@onready var button_prompt: TextureRect = $Label

func _ready() -> void:
	button_prompt.visible = false

func interact() -> void:
	pass

func show_prompt() -> void:
	button_prompt.visible = true

func hide_prompt() -> void:
	button_prompt.visible = false
