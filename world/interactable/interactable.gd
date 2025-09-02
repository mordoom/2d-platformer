extends Area2D

class_name Interactable

@onready var label = $Label

func _ready():
    label.visible = false

func interact():
    pass

func show_prompt():
    label.visible = true

func hide_prompt():
    label.visible = false