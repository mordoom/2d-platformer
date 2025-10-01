extends Node2D
class_name EnableComponent

@export var enabler: Node2D
@export var enabler_string: String

func _ready():
    if enabler_string:
        if not GameState.env_is_changed(enabler_string):
            get_child(0).visible = false
            SignalBus.connect("on_env_change", _on_enable)
    else:
        if not GameState.env_is_changed(enabler):
            get_child(0).visible = false
            SignalBus.connect("on_env_change", _on_enable)

func _on_enable(node: Node2D) -> void:
    if node == enabler:
        get_child(0).visible = true