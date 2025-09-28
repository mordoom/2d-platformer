extends CharacterState

func _ready():
    set_guard(climbing_allowed_check)

func climbing_allowed_check() -> bool:
    var dir: Vector2 = hsm.blackboard.get_var(GameConstants.BlackboardVars.dir_var)

    if dir.y < 0 && get_climbable_above():
        return true
    
    if dir.y > 0 && get_climbable_below():
        return true

    return false

func _enter() -> void:
    super._enter()
    blackboard.set_var(GameConstants.BlackboardVars.climbing_var, true)
    blackboard.set_var(GameConstants.BlackboardVars.current_speed_var, 0)

    var climbable_above = get_climbable_above()
    var climbable_below = get_climbable_below()
    var collisions_enabled = true
    if climbable_above:
        collisions_enabled = climbable_above.collisions_enabled
        owner.global_position.x = climbable_above.global_position.x
    elif climbable_below:
        collisions_enabled = climbable_below.collisions_enabled
        owner.global_position.x = climbable_below.global_position.x
    owner.set_collision_mask_value(1, collisions_enabled)

func _update(_delta: float) -> void:
    var dir: Vector2 = blackboard.get_var(GameConstants.BlackboardVars.dir_var)
    var action_pressed: StringName = blackboard.get_var(GameConstants.BlackboardVars.action_pressed_var)

    if dir.y == 0:
        animation_player.pause()

    if dir.y < 0:
        if not get_climbable_above():
            hsm.dispatch(EVENT_FINISHED)
            return
        else:
            animation_player.play()
    
    if dir.y > 0:
        if not get_climbable_below() || owner.is_on_floor():
            hsm.dispatch(EVENT_FINISHED)
            return
        else:
            animation_player.play()

    elif action_pressed == &"jump" && not owner.head_check.is_colliding():
        hsm.dispatch(&"jump_started")

func _exit() -> void:
    owner.set_collision_mask_value(1, true)
    blackboard.set_var(GameConstants.BlackboardVars.climbing_var, false)

func get_climbable_above() -> Climbable:
    return hsm.blackboard.get_var(GameConstants.BlackboardVars.climbable_above_var)

func get_climbable_below() -> Climbable:
    return hsm.blackboard.get_var(GameConstants.BlackboardVars.climbable_below_var)
