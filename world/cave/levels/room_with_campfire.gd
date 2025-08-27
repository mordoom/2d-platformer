extends Level

func _ready():
    SignalBus.emit_signal("on_display_message", "Interact with campfires to restore health")