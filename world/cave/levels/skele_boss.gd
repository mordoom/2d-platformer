extends Node2D

@onready var floating_platform: Node2D = $FloatingPlatform

func _on_dinoskele_dead() -> void:
	floating_platform.begin_moving()
