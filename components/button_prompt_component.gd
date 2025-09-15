extends Node

class_name ButtonPromptComponent

@onready var button_prompt: TextureRect = $Label

@export var action = "interact"
@export var interact_area: Area2D

func _ready() -> void:
	interact_area.connect("body_entered", _on_body_entered)
	interact_area.connect("body_exited", _on_body_exited)
	button_prompt.visible = false
	if button_prompt.texture and button_prompt.texture.has_method("set_path"):
		button_prompt.texture.path = action

func show_prompt() -> void:
	button_prompt.visible = true

func hide_prompt() -> void:
	button_prompt.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		show_prompt()

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		hide_prompt()
