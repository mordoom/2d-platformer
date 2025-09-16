extends CharacterState

func _enter() -> void:
	var roll_dir = blackboard.get_var(GameConstants.BlackboardVars.dir_var)
	blackboard.set_var(GameConstants.BlackboardVars.roll_force_var, roll_dir.x * owner.roll_speed)
	owner.set_collision_mask_value(3, false)
	super._enter()

func _exit() -> void:
	blackboard.set_var(GameConstants.BlackboardVars.roll_force_var, 0)
	owner.set_collision_mask_value(3, true)
