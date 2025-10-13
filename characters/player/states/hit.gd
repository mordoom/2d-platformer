extends CharacterState

@export var hit_sound: AudioStream

func _enter() -> void:
	super._enter()
	owner.hitbox.monitoring = false
	blackboard.set_var(GameConstants.BlackboardVars.current_speed_var, 0)
	SoundManager.play_sound(hit_sound)
