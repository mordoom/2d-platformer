extends BTAction

@export var animation_name: String
@export var wait_for_attack: bool = true

var attack_states = ["GroundAttack", "RunAttack"]

func _tick(delta: float) -> Status:
	var target: Player = blackboard.get_var(&"target")
	var position_difference: float = target.position.x - agent.position.x
	var direction_to_player: float = sign(position_difference)
	var distance_to_player: float = abs(position_difference)
	var current_direction: Vector2 = blackboard.get_var(&"current_dir")
	var target_behind = direction_to_player != sign(current_direction.x)

	if target_behind:
		return SUCCESS

	if wait_for_attack:
		if attack_states.has(target.hsm.get_active_state().name):
			if agent.animation_player.assigned_animation != animation_name:
				agent.animation_player.play(animation_name)
	else:
		if agent.animation_player.assigned_animation != animation_name:
				agent.animation_player.play(animation_name)
	

	if agent.animation_player.is_playing() && agent.animation_player.assigned_animation == animation_name:
		return RUNNING
	
	return SUCCESS
