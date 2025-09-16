extends CharacterState

var coyote_timer: float = 0

func _enter() -> void:
    super._enter()
    blackboard.set_var(GameConstants.BlackboardVars.current_speed_var, owner.movement_speed)
    coyote_timer = owner.coyote_time

func _update(delta: float) -> void:
    coyote_timer -= delta
    var action_pressed: StringName = blackboard.get_var(GameConstants.BlackboardVars.action_pressed_var)
    var dir: Vector2 = blackboard.get_var(GameConstants.BlackboardVars.dir_var)
    
    if dir.y != 0:
        hsm.dispatch(&"climb_started")
    if action_pressed == &"attack" || InputBuffer.is_action_press_buffered(&"attack"):
        hsm.dispatch(&"jump_attack_started")
    if action_pressed == &"jump":
        if coyote_timer >= 0:
            hsm.dispatch(&"jump_started")
    elif owner.is_on_floor():
        hsm.dispatch(EVENT_FINISHED)