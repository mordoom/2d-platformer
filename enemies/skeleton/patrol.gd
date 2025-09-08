extends State

class_name PatrolState

enum States {IDLE, MOVING}

@export var env_check_comp: EnvCheckComponent

var patrol_state: States = States.MOVING
var idle_timer: float = 0

func on_enter() -> void:
	character.set_direction(character.stats.initial_direction)

func state_physics_process(delta: float) -> void:
	var player_collision: Node = env_check_comp.cached_player_collision
	if player_collision != null && player_collision.is_in_group("Player"):
		emit_change_state("pursue")
		return

	var can_patrol: bool = character.can_patrol()
	match patrol_state:
		States.IDLE:
			idle_timer -= delta
			character.velocity.x = 0
			if idle_timer <= 0:
				_flip_direction()
				patrol_state = States.MOVING
		States.MOVING:
			if can_patrol:
				character.velocity.x = character.current_direction * character.stats.patrol_speed
			else:
				idle_timer = character.stats.idle_time
				patrol_state = States.IDLE

func _flip_direction() -> void:
	character.set_direction(-character.current_direction)
