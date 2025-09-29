extends Area2D

signal on_interacted

@onready var wares_canvas: CanvasLayer = $Wares

func _ready():
    connect("on_interacted", _on_interacted)
    wares_canvas.visible = false

func _on_interacted():
    wares_canvas.visible = !wares_canvas.visible