extends BTAction

func _tick(_delta: float) -> Status:
    blackboard.set_var(&"current_speed", 0)
    return SUCCESS