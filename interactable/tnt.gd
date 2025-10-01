extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	if GameState.env_is_changed(self):
		queue_free()
		return
	animation_player.play(&"Idle")

func _on_health_component_dead() -> void:
	animation_player.play(&"Explode")
	await animation_player.animation_finished
	SignalBus.emit_signal("on_env_change", self)
	queue_free()
