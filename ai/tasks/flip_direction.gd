extends BTAction

func _tick(_delta: float) -> Status:
    agent.flip_direction()
    return SUCCESS