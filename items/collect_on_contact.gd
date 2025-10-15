extends Area2D

@export var collection_component: CollectionComponent
@export var sound_effect: AudioStream

var collected = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player && not collected:
		collected = true
		collection_component.collect()
		SoundManager.play_sound(sound_effect)
