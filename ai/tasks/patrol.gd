extends BTAction

@export var patrol_speed = 80

func _enter() -> void:
    blackboard.set_var(&"current_speed", patrol_speed)

func _tick(_delta: float) -> Status:
    if agent.can_patrol():
        return RUNNING
    else:
        return SUCCESS