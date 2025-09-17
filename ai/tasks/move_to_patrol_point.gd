extends BTAction

@export var patrol_speed = 80
@export var patrol_distance := 5

func _enter() -> void:
    blackboard.set_var(&"current_speed", patrol_speed)

func _tick(delta: float) -> Status:
    var patrol_point = blackboard.get_var(&"patrol_point")
    var direction_to_point = agent.position.direction_to(patrol_point)
    blackboard.set_var(&"current_dir", direction_to_point)

    if agent.position.distance_to(patrol_point) < patrol_distance:
        return SUCCESS

    if agent.flying:
        if agent.is_on_wall() || agent.is_on_floor() || agent.is_on_ceiling():
            return SUCCESS
    else:
        if agent.is_on_wall() || not agent.floor_check.is_colliding():
            return SUCCESS

    return RUNNING
