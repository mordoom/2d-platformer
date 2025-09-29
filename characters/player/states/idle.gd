extends CharacterState

func _update(_delta: float) -> void:
	var dir: Vector2 = blackboard.get_var(GameConstants.BlackboardVars.dir_var)
	var action_pressed: StringName = blackboard.get_var(GameConstants.BlackboardVars.action_pressed_var)
	
	if owner.paused:
		return

	if dir.y != 0:
		hsm.dispatch(&"climb_started")

	if action_pressed == &"drink_rum":
		hsm.dispatch(&"healing_started")
	if action_pressed == &"deflect" || InputBuffer.is_action_press_buffered(&"deflect"):
		hsm.dispatch(&"deflect_started")
	elif action_pressed == &"attack" || InputBuffer.is_action_press_buffered(&"attack"):
		hsm.dispatch(&"ground_attack_started")
	elif action_pressed == &"shoot" || InputBuffer.is_action_press_buffered(&"shoot"):
		hsm.dispatch(&"shoot_started")
	elif action_pressed == &"jump" || InputBuffer.is_action_press_buffered(&"jump"):
		hsm.dispatch(&"jump_started")
	elif not owner.is_on_floor():
		hsm.dispatch(&"fall_started")
	elif not dir.x == 0:
		hsm.dispatch(&"movement_started")
