extends BTAction

func _tick(delta: float) -> Status:
    blackboard.set_var(&"current_speed", 0)
    return SUCCESS