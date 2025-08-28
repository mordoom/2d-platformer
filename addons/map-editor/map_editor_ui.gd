@tool
extends Control

@onready var graph = %GraphEdit
@onready var add_level_button = %AddLevelButton

func _ready():
    add_level_button.pressed.connect(_on_add_level_button_pressed)

func _on_add_level_button_pressed() -> void:
    var new_level = GraphNode.new()
    new_level.title = "test"
    new_level.resizable = true
    new_level.size = Vector2(200, 50)
    new_level.position = Vector2(500, 50)
    new_level.set_slot(0, true, 0, Color(1, 1, 1, 1), true, 0, Color(1, 1, 1, 1))

    var scene_picker = EditorResourcePicker.new()
    scene_picker.base_type = "PackedScene"

    new_level.add_child(scene_picker)
    graph.add_child(new_level)
