extends CharacterState

@onready var character: Player = owner

func _enter() -> void:
	super._enter()
	blackboard.set_var(GameConstants.BlackboardVars.current_speed_var, owner.movement_speed)
	character.velocity.y = character.jump_velocity

func _update(_delta: float) -> void:
	var has_double_jumped: bool = blackboard.get_var(GameConstants.BlackboardVars.has_double_jumped_var)
	var action_pressed: StringName = blackboard.get_var(GameConstants.BlackboardVars.action_pressed_var)
	var dir: Vector2 = blackboard.get_var(GameConstants.BlackboardVars.dir_var)

	# temp disable: 
	# if not has_double_jumped && Input.is_action_just_pressed(&"jump"):
	# 	character.velocity.y = character.jump_velocity
	# 	blackboard.set_var(GameConstants.BlackboardVars.has_double_jumped_var, true)

	if Input.is_action_just_released(&"jump"):
		character.velocity.y *= character.variable_height_jump_mult

	if dir.y < 0:
		hsm.dispatch(&"swing_started")
	if dir.y != 0:
		hsm.dispatch(&"climb_started")
	if action_pressed == &"attack" || InputBuffer.is_action_press_buffered(&"attack"):
		hsm.dispatch(&"jump_attack_started")
	elif owner.is_on_floor():
		blackboard.set_var(GameConstants.BlackboardVars.has_double_jumped_var, false)
		hsm.dispatch(EVENT_FINISHED)
