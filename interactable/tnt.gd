extends StaticBody2D
class_name TNT

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var sound_effect: AudioStream
@export var components: Array[Node]

func _ready():
	if GameState.env_is_changed(self):
		queue_free()
		return
	animation_player.play(&"Idle")

func _on_health_component_dead() -> void:
	animation_player.play(&"Explode")
	SoundManager.play_sound(sound_effect)
	await animation_player.animation_finished
	SignalBus.emit_signal("on_env_change", self)
	queue_free()
