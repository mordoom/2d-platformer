extends MovingEnemy

@onready var env_check_comp: EnvCheckComponent = $EnvCheckComponent

func can_patrol() -> bool:
    return env_check_comp.can_patrol()
