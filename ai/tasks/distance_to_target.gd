extends BTAction

@export var output_var: StringName = &"distance_to_target"

func _tick(_delta: float) -> Status:
    var target = blackboard.get_var(&"target")

    if target == null:
        return FAILURE

    var distance_to_target: Vector2 = target.position - agent.position
    blackboard.set_var(output_var, distance_to_target)
    return SUCCESS