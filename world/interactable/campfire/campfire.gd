extends Interactable

func interact() -> void:
	SignalBus.emit_signal("on_campfire_rested", self)
