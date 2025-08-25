extends Control

@export var damage_color = Color.DARK_RED
@export var heal_color = Color.DARK_GREEN
var health_changed_label = References.health_changed_label

func _ready() -> void:
    SignalBus.connect("on_health_changed", on_signal_health_changed)

func on_signal_health_changed(node: Node, amount: int):
    var label_instance: Label = health_changed_label.instantiate()
    node.add_child(label_instance)
    label_instance.text = str(amount)
    if (amount >= 0):
        label_instance.modulate = heal_color
    else:
        label_instance.modulate = damage_color