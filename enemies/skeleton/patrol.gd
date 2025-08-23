extends State

class_name PatrolState

enum States {IDLE, MOVING}

@export var initial_direction = 1.0
@export var speed: float = 50.0
@export var floor_check: RayCast2D
@export var wall_check: RayCast2D

var idle_time = 3
var idle_timer: float = 0
var patrol_state = States.MOVING
var direction = initial_direction

func state_physics_process(delta):
	wall_check.force_raycast_update()
	floor_check.force_raycast_update()

	var can_patrol = floor_check.is_colliding() && !wall_check.is_colliding()
	match patrol_state:
		States.IDLE:
			idle_timer -= delta
			player.velocity.x = 0
			if (idle_timer <= 0):
				patrol_state = States.MOVING
		States.MOVING:
			player.velocity.x = direction * speed
			if (!can_patrol):
				# print_debug("floor check", floor_check.is_colliding(), floor_check.get_collider())
				# print_debug("wall_check", wall_check.is_colliding(), wall_check.get_collider())
				idle_timer = idle_time
				patrol_state = States.IDLE

				direction *= -1
				wall_check.target_position = Vector2(-20.0 if direction < 0 else 20.0, 0.0)
				wall_check.position.x = -20 if direction < 0 else 20
				floor_check.position.x *= -1
