@tool
extends BTAction

@export var sound_effect: AudioStream
@export var animation_name: StringName

func _enter() -> void:
	if sound_effect:
		SoundManager.play_sound_with_pitch(sound_effect, Rng.generate_random_pitch(1))
	agent.animation_player.play(animation_name)

func _generate_name() -> String:
	return "Attack - " + animation_name

func _tick(_delta: float) -> Status:
	if agent.animation_player.is_playing():
		return RUNNING
	else:
		return SUCCESS
