extends State

class_name PatrolState

enum States {IDLE, MOVING}

@export var initial_direction = 1.0
@export var speed: float = GameConstants.SKELETON_PATROL_SPEED
@export var pursue_state: State

var floor_check: RayCast2D
var wall_check: RayCast2D
var player_check: RayCast2D

var idle_time = GameConstants.SKELETON_IDLE_TIME
var idle_timer: float = 0
var patrol_state = States.MOVING
var direction = initial_direction

func on_enter():
	floor_check = character.get_node("floor_check")
	wall_check = character.get_node("wall_check")
	player_check = character.get_node("player_check")

func state_physics_process(delta):
	wall_check.force_raycast_update()
	floor_check.force_raycast_update()

	var player_check_collision = player_check.get_collider()
	if (player_check_collision != null && player_check_collision.name == "Player"):
		next_state = pursue_state
		pursue_state.direction = direction
		return

	var can_patrol = floor_check.is_colliding() && !wall_check.is_colliding()
	match patrol_state:
		States.IDLE:
			idle_timer -= delta
			character.velocity.x = 0
			if (idle_timer <= 0):
				flip_direction()
				patrol_state = States.MOVING
		States.MOVING:
			if (can_patrol):
				character.velocity.x = direction * speed
			else:
				idle_timer = idle_time
				patrol_state = States.IDLE

func flip_direction():
	direction *= -1
	wall_check.target_position *= -1
	wall_check.position.x *= -1
	floor_check.position.x *= -1
	player_check.position.x *= -1
	player_check.target_position *= -1
