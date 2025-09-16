extends CharacterState

func _enter() -> void:
	super._enter()
	owner.hitbox.monitoring = false
	blackboard.set_var(GameConstants.BlackboardVars.current_speed_var, 0)
