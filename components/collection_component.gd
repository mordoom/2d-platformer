extends Node

class_name CollectionComponent

@export var collection_signal: String = "on_collected"
@export var auto_collect_on_touch: bool = true
@export var button_prompt_comp: ButtonPromptComponent

func _ready() -> void:
	if GameState.is_item_collected(get_parent()):
		get_parent().queue_free()

func collect() -> void:
	SignalBus.emit_signal(collection_signal, get_parent())
	get_parent().queue_free()

func show_prompt() -> void:
	button_prompt_comp.show_prompt()

func hide_prompt() -> void:
	button_prompt_comp.hide_prompt()

func on_body_entered(body: Node2D) -> void:
	if auto_collect_on_touch and body.is_in_group("Player"):
		collect()