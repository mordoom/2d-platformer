extends Node2D

var show_rum_tut := true

func _ready() -> void:
    SignalBus.connect("on_bottle_rum_collected", on_bottle_rum_collected)

func on_bottle_rum_collected(_area: Area2D, _amount: int) -> void:
    if show_rum_tut:
        Dialogic.start_timeline("rum tutorial")
        show_rum_tut = false
