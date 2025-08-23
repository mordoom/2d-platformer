extends State

class_name PursueState

@export var chase_speed = GameConstants.SKELETON_CHASE_SPEED
@export var patrol_state: State
@export var attack_state: State
@export var min_chase_distance = GameConstants.SKELETON_MIN_CHASE_DISTANCE
@export var max_chase_distance = GameConstants.SKELETON_MAX_CHASE_DISTANCE

func state_physics_process(_delta):
	var position_difference = GameManager.player_position.x - character.position.x
	var direction_to_player = sign(position_difference)
	var distance_to_player = abs(position_difference)

	if direction_to_player != character.get_current_direction():
		character.set_direction(direction_to_player)

	if not character.can_patrol():
		next_state = patrol_state
		return

	if (distance_to_player > max_chase_distance):
		next_state = patrol_state
	elif (distance_to_player > min_chase_distance):
		character.velocity.x = direction_to_player * chase_speed
	else:
		character.velocity.x = 0
		next_state = attack_state
