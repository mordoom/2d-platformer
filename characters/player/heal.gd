extends CharacterState

func _ready() -> void:
    set_guard(healing_guard)

func _enter() -> void:
    blackboard.set_var(GameConstants.BlackboardVars.current_speed_var, 0)
    SignalBus.emit_signal("rum_consumed")
    owner.set_health(owner.get_health() + 20)
    owner.rum_bottles = owner.rum_bottles - 1
    super._enter()

func healing_guard() -> bool:
    return owner.rum_bottles > 0