extends CharacterState

func _enter() -> void:
	var roll_dir = blackboard.get_var(GameConstants.BlackboardVars.dir_var)
	blackboard.set_var(GameConstants.BlackboardVars.roll_force_var, roll_dir.x * owner.roll_speed)
	
	owner.collision_shape.position = Vector2(4, 5)
	owner.collision_shape.shape.height = 15
	owner.set_collision_mask_value(3, false)
	super._enter()

func _update(_delta: float) -> void:
	if not owner.head_check.is_colliding():
		super._update(_delta)

func _exit() -> void:
	blackboard.set_var(GameConstants.BlackboardVars.roll_force_var, 0)
	owner.set_collision_mask_value(3, true)
	owner.collision_shape.position = Vector2(3, -6)
	owner.collision_shape.shape.height = 44
