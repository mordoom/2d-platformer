extends Interactable

func interact():
	SignalBus.emit_signal("on_campfire_rested", self)
