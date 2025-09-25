@tool
extends BTAction

func _tick(_delta: float) -> Status:
	if blackboard.get_var(&"target"):
		return SUCCESS
	if agent.can_see_player():
		blackboard.set_var(&"target", agent.get_tree().get_first_node_in_group("Player"))

	return FAILURE
