@tool
extends EditorPlugin

var mapRoot: Node
var initial_level = preload("res://world/cave/levels/room_with_enemies.tscn")

func _enter_tree() -> void:
    mapRoot = CanvasLayer.new()
    var level = initial_level
    var new_level = level.instantiate()
    mapRoot.add_child.call_deferred(new_level)

    add_control_to_bottom_panel(mapRoot, "MapEditor")

func _exit_tree() -> void:
    remove_control_from_bottom_panel(mapRoot)
    mapRoot.queue_free()