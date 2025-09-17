extends BTAction

func _tick(delta: float) -> Status:
    agent.flip_direction()
    return SUCCESS