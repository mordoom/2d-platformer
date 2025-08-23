extends State

class_name PatrolState

enum States {IDLE, MOVING}

@export var initial_direction = 1.0
@export var speed: float = 50.0
@export var floor_check: RayCast2D
@export var wall_check: RayCast2D
@export var player_check: RayCast2D

var idle_time = 3
var idle_timer: float = 0
var patrol_state = States.MOVING
var direction = initial_direction

func state_physics_process(delta):
	wall_check.force_raycast_update()
	floor_check.force_raycast_update()

	var player_check_collision = player_check.get_collider()
	if (player_check_collision != null && player_check_collision.name == "Player"):
		print_debug("I see player")

	var can_patrol = floor_check.is_colliding() && !wall_check.is_colliding()
	match patrol_state:
		States.IDLE:
			idle_timer -= delta
			player.velocity.x = 0
			if (idle_timer <= 0):
				flip_direction()
				patrol_state = States.MOVING
		States.MOVING:
			player.velocity.x = direction * speed
			if (!can_patrol):
				idle_timer = idle_time
				patrol_state = States.IDLE

func flip_direction():
	direction *= -1
	wall_check.target_position *= -1
	wall_check.position.x *= -1
	floor_check.position.x *= -1
	player_check.position.x *= -1
	player_check.target_position *= -1
