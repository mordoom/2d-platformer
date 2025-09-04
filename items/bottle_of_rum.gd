extends Interactable

func _ready() -> void:
    super._ready()
    if GameState.is_rum_bottle_collected(self):
        queue_free()

func interact() -> void:
    SignalBus.emit_signal("on_bottle_rum_collected", self)
    queue_free()