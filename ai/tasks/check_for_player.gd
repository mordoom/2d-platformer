@tool
extends BTAction

func _tick(_delta: float) -> Status:
    if blackboard.get_var(&"target") || agent.player_check.is_colliding():
        return SUCCESS

    return FAILURE
