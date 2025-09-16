extends BTAction


@export var retreat_speed = 80

func _enter() -> void:
    blackboard.set_var(&"current_speed", retreat_speed)
    agent.flip_direction()