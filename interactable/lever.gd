extends Area2D

@onready var animation_player = $AnimationPlayer

func _ready():
	SignalBus.connect("on_env_change", _on_env_change)
	if GameState.env_is_changed(self):
		set_deferred("monitoring", false)
		animation_player.play("Swing right")
		animation_player.seek(animation_player.current_animation_length, true)
	else:
		animation_player.play("Starting position")

func _on_env_change(node: Node2D) -> void:
	if node == self:
		animation_player.play("Swing right")
		set_deferred("monitoring", false)
