extends Node

class_name CollectionComponent

@export var collection_signal: String = "on_collected"

func _ready() -> void:
	if GameState.is_item_collected(get_parent()):
		get_parent().queue_free()

func collect() -> void:
	SignalBus.emit_signal(collection_signal, get_parent())
	get_parent().queue_free()
