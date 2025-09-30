extends Node2D
class_name EnableComponent

func _on_enable() -> void:
    get_child(0).visible = true