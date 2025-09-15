extends CharacterState

func _update(_delta: float) -> void:
    var dir: Vector2 = blackboard.get_var(GameConstants.BlackboardVars.dir_var)
    var action_pressed = blackboard.get_var(GameConstants.BlackboardVars.action_pressed_var)
    
    if dir.y != 0:
        hsm.dispatch(&"climb_started")
    if action_pressed == &"roll" || InputBuffer.is_action_press_buffered(&"roll"):
        hsm.dispatch(&"roll_started")
    elif action_pressed == &"jump" || InputBuffer.is_action_press_buffered(&"jump"):
        hsm.dispatch(&"jump_started")
    elif action_pressed == &"attack" || InputBuffer.is_action_press_buffered(&"attack"):
        hsm.dispatch(&"run_attack_started")
    elif not owner.is_on_floor():
        hsm.dispatch(&"fall_started")
    elif dir.x == 0:
        hsm.dispatch(EVENT_FINISHED)
    else:
        blackboard.set_var(GameConstants.BlackboardVars.current_speed_var, owner.movement_speed)
