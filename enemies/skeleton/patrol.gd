extends State

class_name PatrolState

enum States {IDLE, MOVING}

@export var initial_direction = 1.0
@export var speed: float = GameConstants.SKELETON_PATROL_SPEED
@export var pursue_state: State

var idle_time = GameConstants.SKELETON_IDLE_TIME
var idle_timer: float = 0
var patrol_state = States.MOVING

func on_enter():
	character.set_direction(initial_direction)

func state_physics_process(delta):
	var player_collision = character.get_player_collision()
	if (player_collision != null && player_collision.name == "Player"):
		emit_signal("on_change_state", pursue_state)
		return

	var can_patrol = character.can_patrol()
	match patrol_state:
		States.IDLE:
			idle_timer -= delta
			character.velocity.x = 0
			if (idle_timer <= 0):
				_flip_direction()
				patrol_state = States.MOVING
		States.MOVING:
			if (can_patrol):
				character.velocity.x = character.get_current_direction() * speed
			else:
				idle_timer = idle_time
				patrol_state = States.IDLE

func _flip_direction():
	character.set_direction(-character.get_current_direction())
