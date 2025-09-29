extends Area2D

signal begin_dialog()

@export var timeline_name := ""

func _ready() -> void:
    connect("begin_dialog", _begin_dialog)

func _begin_dialog():
    Dialogic.start(timeline_name)