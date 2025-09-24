extends BTAction

@export var max_chase_distance := 1000
@export var min_chase_distance := 50
@export var pursue_speed := 120

func _tick(_delta: float) -> Status:
	if not agent.floor_check.is_colliding() || agent.wall_check.is_colliding():
		blackboard.set_var(&"target", null)
		return FAILURE

	var target = blackboard.get_var(&"target")
	var position_difference: float = target.position.x - agent.position.x
	var direction_to_player: float = sign(position_difference)
	var distance_to_player: float = abs(position_difference)
	var current_direction: Vector2 = blackboard.get_var(&"current_dir")

	if sign(current_direction.x) != direction_to_player:
		agent.flip_direction()

	if distance_to_player > max_chase_distance:
		return FAILURE
	elif distance_to_player > min_chase_distance:
		blackboard.set_var(&"current_speed", pursue_speed)
	elif distance_to_player <= min_chase_distance:
		blackboard.set_var(&"current_speed", 0)
		return SUCCESS

	return RUNNING
