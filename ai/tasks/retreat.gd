extends BTAction

@export var retreat_speed := 80
@export var retreat_time := 1.0

var time_elapsed := 0.0

func _enter() -> void:
    time_elapsed = 0
    blackboard.set_var(&"current_speed", retreat_speed)
    agent.flip_direction()

func _tick(delta: float) -> Status:
    time_elapsed += delta
    if time_elapsed <= retreat_time:
        return RUNNING
    return SUCCESS