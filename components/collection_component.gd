extends Node

class_name CollectionComponent

@export var collection_signal: String = "on_collected"
@export var auto_collect_on_touch: bool = true

@onready var button_prompt: TextureRect = get_parent().get_node("Label")

func _ready() -> void:
	button_prompt.visible = false
	if GameState.is_item_collected(get_parent()):
		get_parent().queue_free()

func collect() -> void:
	SignalBus.emit_signal(collection_signal, get_parent())
	get_parent().queue_free()

func show_prompt() -> void:
	button_prompt.visible = true

func hide_prompt() -> void:
	button_prompt.visible = false

func on_body_entered(body: Node2D) -> void:
	if auto_collect_on_touch and body.is_in_group("Player"):
		collect()