@tool
extends EditorPlugin

var mapRootScene = preload("res://addons/map-editor/map_editor.tscn")
var initial_level = preload("res://world/cave/levels/room_with_enemies.tscn")

var mapRoot

func _enter_tree() -> void:
    mapRoot = mapRootScene.instantiate()
    add_control_to_bottom_panel(mapRoot, "MapEditor")

func _exit_tree() -> void:
    remove_control_from_bottom_panel(mapRoot)