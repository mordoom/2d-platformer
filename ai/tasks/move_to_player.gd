extends BTAction

@export var pursue_speed = 80
@export var pursue_distance := 5
@export var max_chase_distance := 300

func _enter() -> void:
    blackboard.set_var(&"current_speed", pursue_speed)

func _tick(_delta: float) -> Status:
    var target = blackboard.get_var(&"target")
    var direction_to_point = agent.global_position.direction_to(target.global_position)
    blackboard.set_var(&"current_dir", direction_to_point)

    var distance_to_player = agent.global_position.distance_to(target.global_position)
    if distance_to_player <= pursue_distance:
        return SUCCESS

    if distance_to_player > max_chase_distance:
        blackboard.set_var(&"target", null)
        return FAILURE

    return RUNNING