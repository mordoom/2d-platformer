extends BTAction

var attack_states = ["GroundAttack", "RunAttack"]

func _tick(delta: float) -> Status:
    var target: Player = blackboard.get_var(&"target")

    if attack_states.has(target.hsm.get_active_state().name):
        return SUCCESS
    
    return FAILURE