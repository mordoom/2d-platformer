@tool
extends BTAction

func _tick(_delta: float) -> Status:
    if blackboard.get_var(&"target"):
        return SUCCESS
    if agent.player_check.is_colliding():
        blackboard.set_var(&"target", agent.get_tree().get_first_node_in_group("Player"))

    return FAILURE
