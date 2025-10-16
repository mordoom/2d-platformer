class_name DeflectBox
extends Area2D

@export var sound_effect: AudioStream
@export var is_deflecting := false

@onready var deflect_effect = preload("res://effects/deflect_effect.tscn")
@onready var deflect_point = $DeflectPoint

func deflect():
	var new_effect = deflect_effect.instantiate()
	new_effect.global_position = deflect_point.global_position
	get_tree().get_root().add_child(new_effect)
	SoundManager.play_sound_with_pitch(sound_effect, Rng.generate_random_pitch(1))

func flip(current_direction: float) -> void:
	if current_direction < 0:
		scale.x = -1
	elif current_direction > 0:
		scale.x = 1