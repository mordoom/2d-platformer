extends Level

func _on_message_trigger_body_entered(body: Node2D) -> void:
	SignalBus.emit_signal("on_display_message", "Interact with campfires to restore health")

func _on_message_trigger_body_exited(body: Node2D) -> void:
	SignalBus.emit_signal("on_remove_message")
