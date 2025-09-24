extends BTAction

@export var jump_velocity := 400
@export var jump_time := 1

var jump_timer := 0.0

func _enter() -> void:
    agent.velocity.y -= jump_velocity
    jump_timer = 0.0

func _tick(delta: float) -> Status:
    jump_timer += delta
    if jump_timer >= jump_time:
        jump_timer = 0.0
        return SUCCESS
    else:
        return RUNNING