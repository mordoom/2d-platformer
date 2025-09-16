extends BTAction

@export var patrol_speed = 80

func _enter() -> void:
    blackboard.set_var(&"current_speed", patrol_speed)

func _tick(delta: float) -> Status:
    if agent.floor_check.is_colliding() && not agent.is_on_wall():
        return RUNNING
    else:
        return SUCCESS