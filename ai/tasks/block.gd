extends BTAction

@export var animation_name: String
@export var wait_for_attack: bool = true

var attack_states = ["GroundAttack", "RunAttack"]

func _tick(delta: float) -> Status:
	var target: Player = blackboard.get_var(&"target")

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
