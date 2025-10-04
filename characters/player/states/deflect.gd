extends CharacterState

@onready var cooldown_timer: Timer = $Timer

func _ready():
    set_guard(cooldown_check)

func cooldown_check() -> bool:
    return cooldown_timer.is_stopped()

func _enter() -> void:
    super._enter()
    blackboard.set_var(GameConstants.BlackboardVars.current_speed_var, 0)
    cooldown_timer.start()
