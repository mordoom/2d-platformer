extends CharacterState

func _ready() -> void:
    set_guard(healing_guard)

func healing_guard() -> bool:
    return owner.rum_bottles > 0

func _enter() -> void:
    blackboard.set_var(GameConstants.BlackboardVars.current_speed_var, 0)
    super._enter()

func _update(_delta: float) -> void:
    if not animation_player.is_playing() or animation_player.assigned_animation != animation_name:
        SignalBus.emit_signal("rum_consumed")
        owner.set_health(owner.get_health() + 20)
        owner.rum_bottles = owner.rum_bottles - 1
        dispatch(EVENT_FINISHED)